const BASE = 'https://www.joinkfa.com';
const FILE_BASE = 'https://files.joinkfa.com';
const JSON_HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json, text/plain, */*',
  'User-Agent':
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
  'Referer': 'https://www.joinkfa.com/portal/mat/matchList.do',
  'Origin': 'https://www.joinkfa.com',
  'X-Requested-With': 'XMLHttpRequest',
};

function fallbackImageUrl(path) {
  return `${BASE}${path}`;
}

function resolveJoinKfaImage(raw, type = 'emblem') {
  const fallback = type === 'human'
      ? fallbackImageUrl('/service/match/images/img_WF_Profile.png')
      : fallbackImageUrl('/service/match/images/no_emblem_big.png');

  if (!raw) return fallback;

  const [folderName = '', fileName = ''] = String(raw).split('|');
  if (!folderName || !fileName) return fallback;

  return `${FILE_BASE}/${folderName}/${fileName}`;
}

function normalizeTeamName(value) {
  return String(value ?? '')
    .toLowerCase()
    .replaceAll(/[\s\-_]/g, '');
}

async function getSessionCookies() {
  try {
    const res = await fetch(`${BASE}/portal/mat/matchList.do`, {
      headers: {
        'User-Agent': JSON_HEADERS['User-Agent'],
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
    });
    const raw = res.headers.get('set-cookie') || '';
    const cookies = {};
    for (const part of raw.split(/,(?=[^ ])/)) {
      const kv = part.split(';')[0].trim();
      const idx = kv.indexOf('=');
      if (idx > 0) cookies[kv.slice(0, idx).trim()] = kv.slice(idx + 1).trim();
    }
    return Object.entries(cookies).map(([k, v]) => `${k}=${v}`).join('; ');
  } catch {
    return '';
  }
}

async function postJson(path, body, cookieStr = '') {
  const headers = { ...JSON_HEADERS };
  if (cookieStr) headers['Cookie'] = cookieStr;

  const res = await fetch(`${BASE}${path}`, {
    method: 'POST',
    headers,
    body: JSON.stringify(body),
  });

  if (!res.ok) {
    throw new Error(`JoinKFA request failed: ${res.status} ${res.statusText}`);
  }

  const newCookieRaw = res.headers.get('set-cookie') || '';
  let merged = cookieStr;
  if (newCookieRaw) {
    const newCookies = {};
    for (const part of newCookieRaw.split(/,(?=[^ ])/)) {
      const kv = part.split(';')[0].trim();
      const idx = kv.indexOf('=');
      if (idx > 0) newCookies[kv.slice(0, idx).trim()] = kv.slice(idx + 1).trim();
    }
    const existing = {};
    for (const part of cookieStr.split(';')) {
      const kv = part.trim();
      const idx = kv.indexOf('=');
      if (idx > 0) existing[kv.slice(0, idx).trim()] = kv.slice(idx + 1).trim();
    }
    Object.assign(existing, newCookies);
    merged = Object.entries(existing).map(([k, v]) => `${k}=${v}`).join('; ');
  }

  return { data: await res.json(), cookieStr: merged };
}

function buildDetailRequestXml({matchIdx, singleIdx}) {
  return `<?xml version="1.0" encoding="UTF-8"?>
<Root xmlns="http://www.nexacroplatform.com/platform/dataset">
  <Parameters>
    <Parameter id="GP_EMPL_ID" type="string"></Parameter>
    <Parameter id="GP_SYS_CD" type="string">USER</Parameter>
    <Parameter id="GP_MENU_ID" type="string">MAT_02_HIDDEN</Parameter>
    <Parameter id="GP_SVC_PATH" type="string">/generate/MAT_04_001/SEARCH00.do</Parameter>
    <Parameter id="GP_SERVICE_ID" type="string">SEARCH00</Parameter>
    <Parameter id="GP_AUTH_GROUP" type="string"></Parameter>
    <Parameter id="GP_LOG_YN" type="string">N</Parameter>
  </Parameters>
  <Dataset id="dsReqParam">
    <ColumnInfo>
      <Column id="v_MATCH_IDX" type="STRING" size="256"/>
      <Column id="v_SINGLE_IDX" type="STRING" size="256"/>
      <Column id="v_USER_ID" type="STRING" size="256"/>
    </ColumnInfo>
    <Rows>
      <Row>
        <Col id="v_MATCH_IDX">${matchIdx}</Col>
        <Col id="v_SINGLE_IDX">${singleIdx}</Col>
        <Col id="v_USER_ID"></Col>
      </Row>
    </Rows>
  </Dataset>
</Root>`;
}

async function fetchAnonymousDetail({matchIdx, singleIdx}) {
  const res = await fetch(
    `${BASE}/generate/MAT_04_001/SEARCH00.do?CALL_TYPE=NEXACRO`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'text/xml; charset=UTF-8',
        'Accept': 'text/xml, application/xml, */*',
        'User-Agent': JSON_HEADERS['User-Agent'],
      },
      body: buildDetailRequestXml({matchIdx, singleIdx}),
    },
  );

  const xml = await res.text();
  const errorCodeMatch = xml.match(
    /<Parameter id="ErrorCode" type="string">([^<]*)<\/Parameter>/,
  );
  const errorMsgMatch = xml.match(
    /<Parameter id="ErrorMsg" type="string">([^<]*)<\/Parameter>/,
  );

  return {
    status: res.status,
    ok: res.ok,
    errorCode: errorCodeMatch?.[1] ?? null,
    errorMsg: errorMsgMatch?.[1] ?? null,
    rawXml: xml,
  };
}

function withEmblems(single) {
  return {
    ...single,
    TEAM_HOME_EMBLEM_URL: resolveJoinKfaImage(single.TEAM_HOME_EMBLEM, 'emblem'),
    TEAM_AWAY_EMBLEM_URL: resolveJoinKfaImage(single.TEAM_AWAY_EMBLEM, 'emblem'),
  };
}

function withTeamEmblem(team) {
  return {
    ...team,
    EMBLEM_URL: resolveJoinKfaImage(team.EMBLEM, 'emblem'),
  };
}

function withPlayerPhoto(player) {
  return {
    ...player,
    PHOTO_URL: resolveJoinKfaImage(
      `${player.PHOTO_FILE_PATH ?? ''}|${player.PHOTO ?? ''}`,
      'human',
    ),
  };
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET') {
    return res.status(405).json({error: 'Method not allowed'});
  }

  const {
    mode = 'init',
    itemCd = 'S',
    year = String(new Date().getFullYear()),
    style = 'LEAGUE2',
    mgcIdx = '',
    areaCode = '',
    sigunguCode = '',
    title = '',
    teamId = '',
    matchIdx = '',
    yearMonth = '',
    singleIdx = '',
    mgcType = 'S',
    grades = '2,3',
    page = '1',
    pageSize = '1000',
  } = req.query;

  try {
    switch (mode) {
      case 'init': {
        const { data } = await postJson('/portal/mat/getInitData1.do', {
          v_ITEM_CD: itemCd,
        });
        return res.status(200).json(data);
      }

      case 'matchList': {
        const cookieStr = await getSessionCookies();
        const { data } = await postJson('/portal/mat/getMatchList.do', {
          v_CURPAGENUM: String(page),
          v_ROWCOUNTPERPAGE: String(pageSize),
          v_ORDERBY: '',
          v_YEAR: year,
          v_STYLE: style,
          v_MGC_IDX: mgcIdx,
          v_AREACODE: areaCode,
          v_SIGUNGU_CODE: sigunguCode,
          v_ITEM_CD: itemCd,
          v_TITLE: title,
          v_TEAMID: teamId,
          v_USER_ID: '',
        }, cookieStr);
        return res.status(200).json(data);
      }

      case 'allCompetitions': {
        const cookieStr = await getSessionCookies();

        const gradeCombos = [
          { style: 'LEAGUE2', mgcIdx: '2' },
          { style: 'LEAGUE2', mgcIdx: '3' },
          { style: 'MATCH',   mgcIdx: '52' },
          { style: 'MATCH',   mgcIdx: '53' },
        ];

        const results = await Promise.allSettled(
          gradeCombos.map(({ style: s, mgcIdx: g }) =>
            postJson('/portal/mat/getMatchList.do', {
              v_CURPAGENUM: '1',
              v_ROWCOUNTPERPAGE: '200',
              v_ORDERBY: '',
              v_YEAR: year,
              v_STYLE: s,
              v_MGC_IDX: g,
              v_AREACODE: '',
              v_SIGUNGU_CODE: '',
              v_ITEM_CD: itemCd,
              v_TITLE: '',
              v_TEAMID: '',
              v_USER_ID: '',
            }, cookieStr),
          ),
        );

        const competitions = [];
        for (let i = 0; i < gradeCombos.length; i++) {
          const r = results[i];
          if (r.status !== 'fulfilled') continue;
          const matchList = r.value.data.matchList ?? [];
          for (const match of matchList) {
            competitions.push({
              ...match,
              _style: gradeCombos[i].style,
              _mgcIdx: gradeCombos[i].mgcIdx,
            });
          }
        }

        return res.status(200).json({
          year,
          totalCount: competitions.length,
          competitions,
          _debug: results.map((r, i) => ({
            ...gradeCombos[i],
            status: r.status,
            count: r.status === 'fulfilled' ? (r.value.data.matchList?.length ?? 0) : 0,
            error: r.status === 'rejected' ? r.reason?.message : undefined,
          })),
        });
      }

      case 'matchInfo': {
        if (!matchIdx) {
          return res.status(400).json({error: 'matchIdx is required'});
        }
        const cookieStr = await getSessionCookies();
        const { data } = await postJson('/portal/mat/getMatchInfo.do', {
          v_MATCH_IDX: matchIdx,
        }, cookieStr);
        return res.status(200).json(data);
      }

      case 'singleList': {
        if (!matchIdx || !yearMonth) {
          return res
            .status(400)
            .json({error: 'matchIdx and yearMonth are required'});
        }
        const cookieStr = await getSessionCookies();
        const { data } = await postJson('/portal/mat/getMatchSingleList.do', {
          v_CURPAGENUM: String(page),
          v_ROWCOUNTPERPAGE: String(pageSize),
          v_ORDERBY: '',
          v_MATCH_IDX: matchIdx,
          v_YEAR_MONTH: yearMonth,
          v_TEAMID: teamId,
          v_USER_ID: '',
        }, cookieStr);
        return res.status(200).json({
          ...data,
          singleList: (data.singleList ?? []).map(withEmblems),
        });
      }

      case 'applyTeams': {
        if (!matchIdx) {
          return res.status(400).json({error: 'matchIdx is required'});
        }
        const cookieStr = await getSessionCookies();
        const { data } = await postJson('/portal/mat/getApplyTeamList.do', {
          v_MATCH_IDX: matchIdx,
        }, cookieStr);
        return res.status(200).json({
          ...data,
          applyTeamList: (data.applyTeamList ?? []).map(withTeamEmblem),
        });
      }

      case 'applyPlayers': {
        if (!matchIdx || !teamId) {
          return res
            .status(400)
            .json({error: 'matchIdx and teamId are required'});
        }
        const cookieStr = await getSessionCookies();
        const { data } = await postJson('/portal/mat/getApplyPlayerList.do', {
          v_TEAMID: teamId,
          v_MATCH_IDX: matchIdx,
          v_MGC_TYPE: mgcType,
        }, cookieStr);
        return res.status(200).json({
          ...data,
          applyPlayerList: (data.applyPlayerList ?? []).map(withPlayerPhoto),
        });
      }

      case 'teamEmblems': {
        const gradeList = String(grades)
          .split(',')
          .map((value) => value.trim())
          .filter(Boolean);

        const cookieStr = await getSessionCookies();
        const emblemByTeam = {};
        const tournaments = [];

        const gradeResults = await Promise.allSettled(
          gradeList.map((grade) =>
            postJson('/portal/mat/getMatchList.do', {
              v_CURPAGENUM: '1',
              v_ROWCOUNTPERPAGE: '200',
              v_ORDERBY: '',
              v_YEAR: year,
              v_STYLE: style,
              v_MGC_IDX: grade,
              v_AREACODE: '',
              v_SIGUNGU_CODE: '',
              v_ITEM_CD: itemCd,
              v_TITLE: '',
              v_TEAMID: '',
              v_USER_ID: '',
            }, cookieStr),
          ),
        );

        const allMatchIdxs = new Set();
        for (let i = 0; i < gradeList.length; i++) {
          const gradeResult = gradeResults[i];
          if (gradeResult.status !== 'fulfilled') continue;
          const matchList = gradeResult.value.data.matchList ?? [];
          for (const match of matchList.slice(0, 8)) {
            if (!allMatchIdxs.has(match.IDX)) {
              allMatchIdxs.add(match.IDX);
              tournaments.push({ grade: gradeList[i], matchIdx: match.IDX, title: match.TITLE });
            }
          }
        }

        const teamResults = await Promise.allSettled(
          tournaments.map((t) =>
            postJson('/portal/mat/getApplyTeamList.do', {
              v_MATCH_IDX: t.matchIdx,
            }, cookieStr),
          ),
        );

        for (const result of teamResults) {
          if (result.status !== 'fulfilled') continue;
          for (const team of result.value.data.applyTeamList ?? []) {
            const normalizedTeamName = normalizeTeamName(team.TEAMNAME);
            if (!normalizedTeamName) continue;
            const emblemUrl = resolveJoinKfaImage(team.EMBLEM, 'emblem');

            if (!emblemByTeam[normalizedTeamName]) {
              emblemByTeam[normalizedTeamName] = emblemUrl;
            }

            const nameWithoutAge = normalizedTeamName.replace(/u\d{2}/g, '');
            if (nameWithoutAge && nameWithoutAge !== normalizedTeamName && !emblemByTeam[nameWithoutAge]) {
              emblemByTeam[nameWithoutAge] = emblemUrl;
            }

            const shortName = nameWithoutAge
              .replace(/현대모터스|드래곤즈|블루윙즈|시티즌|하나|이랜드fc|이랜드|아이파크/g, '')
              .replace(/^(fc|경기)/, '')
              .replace(/(fc|고등학교|중학교|클럽)$/, '')
              .trim();
            if (shortName && shortName.length >= 2 && shortName !== nameWithoutAge && !emblemByTeam[shortName]) {
              emblemByTeam[shortName] = emblemUrl;
            }
          }
        }

        return res.status(200).json({
          year,
          style,
          grades: gradeList,
          tournamentCount: tournaments.length,
          teamCount: Object.keys(emblemByTeam).length,
          emblemByTeam,
        });
      }

      case 'detail': {
        if (!matchIdx || !singleIdx) {
          return res
            .status(400)
            .json({error: 'matchIdx and singleIdx are required'});
        }

        const detail = await fetchAnonymousDetail({matchIdx, singleIdx});
        const requiresLogin = detail.errorMsg?.includes('로그인정보가 없습니다.');

        if (requiresLogin) {
          return res.status(403).json({
            requiresLogin: true,
            errorCode: detail.errorCode,
            message:
              'JoinKFA detailed match records are blocked for anonymous requests.',
            sourceMessage: detail.errorMsg,
          });
        }

        return res.status(200).json({
          requiresLogin: false,
          errorCode: detail.errorCode,
          sourceMessage: detail.errorMsg,
          rawXml: detail.rawXml,
        });
      }

      default:
        return res.status(400).json({error: `Unsupported mode: ${mode}`});
    }
  } catch (error) {
    console.error('[joinkfa proxy]', error);
    return res.status(500).json({
      error: error.message ?? 'Internal server error',
    });
  }
}
