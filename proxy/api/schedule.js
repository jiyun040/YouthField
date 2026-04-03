const BASE = 'https://www.kleague.com';
const STYLE = 'LEAGUE2';

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

async function postJson(endpoint, body, cookieStr) {
  const res = await fetch(`${BASE}${endpoint}`, {
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
    body: JSON.stringify(body),
  });

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

  const data = await res.json();
  return { data, cookieStr: merged };
}

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const { year = '2026' } = req.query;

  try {

    let cookieStr = await getSessionCookies();

    const yearRes = await postJson(
      '/youth/junior/yearChange.do',
      { year, style: STYLE },
      cookieStr,
    );
    cookieStr = yearRes.cookieStr;

    const yearData = yearRes.data;
    if (yearData.resultCode !== '200') {
      return res.status(502).json({ error: yearData.resultMsg ?? 'yearChange failed' });
    }

    const leagues = yearData.data?.leagueNameList ?? [];

    const allSchedules = {};

    for (const m of (yearData.data?.scheduleList ?? [])) {
      if (!allSchedules[m.leagueId]) allSchedules[m.leagueId] = [];
      allSchedules[m.leagueId].push(m);
    }

    const remainingLeagues = leagues.filter(
      (l) => !allSchedules[l.leagueId] || allSchedules[l.leagueId].length === 0
    );

    for (const league of remainingLeagues) {
      try {
        const leagueRes = await postJson(
          '/youth/junior/leagueNameChange.do',
          { leagueId: String(league.leagueId), style: STYLE },
          cookieStr,
        );
        cookieStr = leagueRes.cookieStr;

        if (leagueRes.data.resultCode === '200') {
          const sched = leagueRes.data.data?.scheduleList ?? [];
          allSchedules[league.leagueId] = sched;
        }
      } catch (e) {
        console.error(`[schedule] leagueId=${league.leagueId} failed:`, e.message);
      }
    }

    const mergedSchedules = Object.values(allSchedules).flat();

    return res.status(200).json({
      leagueNameList: leagues,
      scheduleList: mergedSchedules,

      _sampleMatch: mergedSchedules[0] ?? null,
    });

  } catch (err) {
    console.error('[schedule proxy]', err);
    return res.status(500).json({ error: err.message ?? 'Internal server error' });
  }
}
