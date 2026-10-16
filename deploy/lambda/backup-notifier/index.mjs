// ─────────────────────────────────────────────
// Lambda: chainex-backup-notifier  (Node.js 20.x)
// Trigger: S3 bucket → Event notification → s3:ObjectCreated:* on prefix "backups/"
// ─────────────────────────────────────────────
export const handler = async (event) => {
  const results = event.Records.map((r) => {
    const info = {
      bucket: r.s3.bucket.name,
      key: decodeURIComponent(r.s3.object.key.replace(/\+/g, ' ')),
      sizeKB: (r.s3.object.size / 1024).toFixed(1),
      time: r.eventTime,
    };
    console.log(`📦 New ChaiNIEx backup received: ${JSON.stringify(info)}`);
    return info;
  });
  return { processed: results.length, results };
};
