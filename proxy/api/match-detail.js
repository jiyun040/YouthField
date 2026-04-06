const BASE = 'https://www.kleague.com';

async function getSessionCookies() {
  const res = await fetch(`${BASE}/youth/junior.do`, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': 'text/html,application/xhtml+xml',
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
}

function stripTags(html) {
  return html.replace(/<[^>]+>/g, '').replace(/&amp;/g, '&').replace(/&nbsp;/g, ' ').replace(/&lt;/g, '<').replace(/&gt;/g, '>').trim();
}

function extractTdValues(rowHtml) {
  const tds = [];
  const re = /<td[^>]*>([\s\S]*?)<\/td>/gi;
  let m;
  while ((m = re.exec(rowHtml)) !== null) {
    tds.push(stripTags(m[1]));
  }
  return tds;
}

function parseCount(value) {
  const normalized = String(value ?? '').replace(/[^\d-]/g, '').trim();
  if (!normalized) return 0;
  return Number.parseInt(normalized, 10) || 0;
}

function parseLineupTable(tbodyHtml, side) {
  const starters = [];
  const subs = [];
  let inSubSection = false;

  const rowRe = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
  let rowMatch;
  while ((rowMatch = rowRe.exec(tbodyHtml)) !== null) {
    const rowContent = rowMatch[1];
    if (rowContent.includes('<th')) continue;

    const tds = extractTdValues(rowContent);

    if (tds.length === 0 || rowContent.includes('colspan="7"')) {
      inSubSection = true;
      continue;
    }

    if (tds.length < 7) continue;

    let player;
    if (side === 'home') {
      const yellowCards = parseCount(tds[0]);
      const redCards = parseCount(tds[1]);
      const goals = parseCount(tds[2]);
      const minutes = parseCount(tds[3]);
      const name = tds[4].trim();
      const number = parseCount(tds[5]);
      const position = tds[6].trim();
      if (!name) continue;
      player = {
        position,
        number,
        name,
        minutes,
        goals,
        yellowCards,
        yellowCard: yellowCards > 0,
        redCards,
        redCard: redCards > 0,
      };
    } else {
      const position = tds[0].trim();
      const number = parseCount(tds[1]);
      const name = tds[2].trim();
      const minutes = parseCount(tds[3]);
      const goals = parseCount(tds[4]);
      const yellowCards = parseCount(tds[5]);
      const redCards = parseCount(tds[6]);
      if (!name) continue;
      player = {
        position,
        number,
        name,
        minutes,
        goals,
        yellowCards,
        yellowCard: yellowCards > 0,
        redCards,
        redCard: redCards > 0,
      };
    }

    if (inSubSection) {
      subs.push(player);
    } else {
      starters.push(player);
    }
  }

  return { starters, subs };
}

function extractHeroSection(html) {
  const start = html.indexOf('<div class="sub-top match youth-match">');
  if (start === -1) return '';
  const end = html.indexOf('<div class="sub-contents-wrap record youth-match"', start);
  return end === -1 ? html.slice(start) : html.slice(start, end);
}

function extractTbodyByHeader(html, headerMatcher) {
  const match = html.match(headerMatcher);
  return match?.[1] ?? '';
}

function parseMatchHtml(html) {
  const result = {
    homeTeam: '', awayTeam: '', score: '',
    homeLineup: [], awayLineup: [],
    homeSubstitutes: [], awaySubstitutes: [],
  };

  const heroSection = extractHeroSection(html);
  if (heroSection) {
    const scoreBoxMatch = heroSection.match(
      /<div class="score-box">([\s\S]*?)<\/div>\s*<p class="txt">/i,
    );
    const scoreBoxSection = scoreBoxMatch?.[1] ?? heroSection;

    const teamBoxRe = /<div class="team-box">([\s\S]*?)<\/div>/g;
    const teamBoxes = [...scoreBoxSection.matchAll(teamBoxRe)];
    if (teamBoxes.length >= 1) result.homeTeam = stripTags(teamBoxes[0][1]);
    if (teamBoxes.length >= 2) result.awayTeam = stripTags(teamBoxes[1][1]);

    const scoreMatch = scoreBoxSection.match(
      /<div class="score campton">\s*(\d+)\s*<span>\s*-\s*<\/span>\s*(\d+)\s*<\/div>/i,
    );
    if (scoreMatch) {
      result.score = `${scoreMatch[1]}:${scoreMatch[2]}`;
    }
  }

  const homeTbody = extractTbodyByHeader(
    html,
    /<thead class="th-line">[\s\S]*?<th colspan="2" class="no-bl">카드<\/th>[\s\S]*?<tbody>([\s\S]*?)<\/tbody>/i,
  );
  if (homeTbody) {
    const { starters, subs } = parseLineupTable(homeTbody, 'home');
    result.homeLineup = starters;
    result.homeSubstitutes = subs;
  }

  const awayTbody = extractTbodyByHeader(
    html,
    /<thead class="th-line">[\s\S]*?<th rowspan="2">위치<\/th>[\s\S]*?<th rowspan="2">배번<\/th>[\s\S]*?<tbody>([\s\S]*?)<\/tbody>/i,
  );
  if (awayTbody) {
    const { starters, subs } = parseLineupTable(awayTbody, 'away');
    result.awayLineup = starters;
    result.awaySubstitutes = subs;
  }

  return result;
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const { leagueId, matchNum, debug } = req.query;

  if (!leagueId || !matchNum) {
    return res.status(400).json({ error: 'leagueId and matchNum are required' });
  }

  try {
    const cookieStr = await getSessionCookies();

    const jsonRes = await fetch(`${BASE}/youth/junior/matchResultChange.do`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Referer': `${BASE}/youth/junior.do`,
        'Origin': BASE,
        'Cookie': cookieStr,
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: JSON.stringify({ leagueId, matchNum }),
    });

    if (jsonRes.ok) {
      const contentType = jsonRes.headers.get('content-type') || '';
      if (contentType.includes('application/json')) {
        const data = await jsonRes.json();
        if (data && (data.resultCode === '200' || data.data)) {
          return res.status(200).json({ source: 'api', data });
        }
      }
    }

    const popUrl = `${BASE}/youth/result-pop.do?leagueId=${encodeURIComponent(leagueId)}&matchNum=${encodeURIComponent(matchNum)}`;
    const popRes = await fetch(popUrl, {
      headers: {
        'Referer': `${BASE}/youth/junior.do`,
        'Cookie': cookieStr,
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
    });

    if (!popRes.ok) {
      return res.status(popRes.status).json({ error: `Upstream error: ${popRes.status}` });
    }

    const html = await popRes.text();

    if (debug === '1') {
      return res.status(200).send(html);
    }

    const parsed = parseMatchHtml(html);
    return res.status(200).json({ source: 'html', leagueId, matchNum, ...parsed, _htmlLen: html.length });

  } catch (err) {
    console.error('[match-detail proxy]', err);
    return res.status(500).json({ error: err.message ?? 'Internal server error' });
  }
}
