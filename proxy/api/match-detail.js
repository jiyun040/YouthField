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

function parseLineupTable(tbodyHtml, side) {
  const starters = [];
  const subs = [];
  let inSubSection = false;

  const rowRe = /<tr>([\s\S]*?)<\/tr>/gi;
  let rowMatch;
  while ((rowMatch = rowRe.exec(tbodyHtml)) !== null) {
    const rowContent = rowMatch[1];
    if (rowContent.includes('<th')) continue;

    const tds = extractTdValues(rowContent);

    if (tds.length === 0) {
      inSubSection = true;
      continue;
    }

    if (tds.length < 7) continue;

    let player;
    if (side === 'home') {
      const yellow = tds[0].trim() === '1';
      const red = tds[1].trim() === '1';
      const goals = parseInt(tds[2].trim()) || 0;
      const minutes = parseInt(tds[3].trim()) || 0;
      const name = tds[4].trim();
      const number = parseInt(tds[5].trim()) || 0;
      const position = tds[6].trim();
      if (!name) continue;
      player = { position, number, name, minutes, goals, yellowCard: yellow, redCard: red };
    } else {
      const position = tds[0].trim();
      const number = parseInt(tds[1].trim()) || 0;
      const name = tds[2].trim();
      const minutes = parseInt(tds[3].trim()) || 0;
      const goals = parseInt(tds[4].trim()) || 0;
      const yellow = tds[5].trim() === '1';
      const red = tds[6].trim() === '1';
      if (!name) continue;
      player = { position, number, name, minutes, goals, yellowCard: yellow, redCard: red };
    }

    if (inSubSection) {
      subs.push(player);
    } else {
      starters.push(player);
    }
  }

  return { starters, subs };
}

function parseMatchHtml(html) {
  const result = {
    homeTeam: '', awayTeam: '', score: '',
    homeLineup: [], awayLineup: [],
    homeSubstitutes: [], awaySubstitutes: [],
  };

  const scoreBoxStart = html.indexOf('score-box">');
  if (scoreBoxStart !== -1) {
    const scoreBoxSection = html.slice(scoreBoxStart, scoreBoxStart + 2000);

    const teamBoxRe = /<div class="team-box">([\s\S]*?)<\/div>/g;
    const teamBoxes = [...scoreBoxSection.matchAll(teamBoxRe)];
    if (teamBoxes.length >= 1) result.homeTeam = stripTags(teamBoxes[0][1]);
    if (teamBoxes.length >= 2) result.awayTeam = stripTags(teamBoxes[1][1]);

    const scoreMatch = scoreBoxSection.match(/class="score campton">([\s\S]*?)<\/div>/);
    if (scoreMatch) {
      const scoreText = stripTags(scoreMatch[1]).replace(/\s/g, '');
      const sm = scoreText.match(/(\d+)-(\d+)/);
      if (sm) result.score = `${sm[1]}:${sm[2]}`;
    }
  }

  const innerTableRe = /<table style="width: 100%; border-top: 0;">([\s\S]*?)<\/table>/g;
  const innerTables = [...html.matchAll(innerTableRe)];

  if (innerTables.length >= 1) {
    const tbodyMatch = innerTables[0][1].match(/<tbody>([\s\S]*?)<\/tbody>/i);
    if (tbodyMatch) {
      const { starters, subs } = parseLineupTable(tbodyMatch[1], 'home');
      result.homeLineup = starters;
      result.homeSubstitutes = subs;
    }
  }
  if (innerTables.length >= 2) {
    const tbodyMatch = innerTables[1][1].match(/<tbody>([\s\S]*?)<\/tbody>/i);
    if (tbodyMatch) {
      const { starters, subs } = parseLineupTable(tbodyMatch[1], 'away');
      result.awayLineup = starters;
      result.awaySubstitutes = subs;
    }
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
