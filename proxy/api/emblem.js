const BASE = 'https://www.kleague.com';

const VALID_CODE = /^K\d{2}$/;

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const { code } = req.query;

  if (!code || !VALID_CODE.test(code)) {
    return res.status(400).json({ error: 'Invalid or missing code parameter (expected e.g. K35)' });
  }

  const imageUrl = `${BASE}/assets/images/emblem/emblem_${code}.png`;

  try {
    const upstream = await fetch(imageUrl, {
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Referer': `${BASE}/`,
        'Accept': 'image/png,image/*,*/*',
      },
    });

    if (!upstream.ok) {
      return res.status(upstream.status).json({
        error: `Upstream responded with ${upstream.status}`,
      });
    }

    const contentType = upstream.headers.get('content-type') ?? 'image/png';
    const buffer = await upstream.arrayBuffer();

    res.setHeader('Content-Type', contentType);
    res.setHeader('Cache-Control', 'public, max-age=86400');
    res.status(200).send(Buffer.from(buffer));
  } catch (err) {
    console.error('[emblem proxy]', err);
    return res.status(500).json({ error: err.message ?? 'Internal server error' });
  }
}
