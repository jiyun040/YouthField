/**
 * Vercel Serverless Function — YouTube Search Proxy
 *
 * Flutter Web에서 직접 YouTube API를 호출하면 API 키가 노출되므로
 * 이 프록시를 통해 서버 사이드에서 호출합니다.
 *
 * GET /api/youtube?q=축구+스킬&maxResults=20&pageToken=xxx
 */

const YOUTUBE_API = 'https://www.googleapis.com/youtube/v3/search';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', '*');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });

  const apiKey = process.env.YOUTUBE_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'YouTube API key not configured' });
  }

  const {
    q = '축구 스킬',
    maxResults = '20',
    pageToken,
  } = req.query;

  const params = new URLSearchParams({
    part: 'snippet',
    type: 'video',
    q,
    maxResults,
    regionCode: 'KR',
    relevanceLanguage: 'ko',
    key: apiKey,
  });

  if (pageToken) params.set('pageToken', pageToken);

  try {
    const ytRes = await fetch(`${YOUTUBE_API}?${params}`);
    const data = await ytRes.json();

    if (!ytRes.ok) {
      return res.status(ytRes.status).json({ error: data?.error?.message ?? 'YouTube API error' });
    }

    // 필요한 필드만 추려서 반환 (API 키 등 민감 정보 노출 방지)
    const items = (data.items ?? []).map((item) => ({
      videoId: item.id?.videoId,
      title: item.snippet?.title,
      channelTitle: item.snippet?.channelTitle,
      thumbnail: item.snippet?.thumbnails?.medium?.url,
      publishedAt: item.snippet?.publishedAt,
    }));

    return res.status(200).json({
      items,
      nextPageToken: data.nextPageToken ?? null,
    });
  } catch (err) {
    console.error('[youtube proxy]', err);
    return res.status(500).json({ error: err.message ?? 'Internal server error' });
  }
}
