// ─────────────────────────────────────────────
// Lambda: chainex-health-check  (Node.js 20.x)
// Trigger: EventBridge schedule — rate(5 minutes)
// Env var: APP_URL = http://<your-ALB-DNS-name>
// ─────────────────────────────────────────────
export const handler = async () => {
  const url = `${process.env.APP_URL}/api/health`;
  const start = Date.now();
  try {
    const res = await fetch(url, { signal: AbortSignal.timeout(5000) });
    const body = await res.json();
    const ms = Date.now() - start;
    const status = res.ok ? 'UP' : 'DOWN';
    console.log(JSON.stringify({ status, httpCode: res.status, latencyMs: ms, body }));
    return { status, latencyMs: ms };
  } catch (err) {
    console.error(JSON.stringify({ status: 'DOWN', error: err.message }));
    return { status: 'DOWN', error: err.message };
  }
};
