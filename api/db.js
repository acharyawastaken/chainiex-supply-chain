// ─────────────────────────────────────────────
// PostgreSQL Connection Pool (pg)
// ─────────────────────────────────────────────
require('dotenv').config({ path: '../.env' });
const { Pool } = require('pg');

const pool = new Pool({
  host:     process.env.DB_HOST || 'localhost',
  port:     parseInt(process.env.DB_PORT || '5432', 10),
  user:     process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'postgres',
  database: process.env.DB_NAME || 'chainex_db',
  max:      10, // connection pool size
  idleTimeoutMillis: 30000,
});

// Quick connectivity check on startup
pool.query('SELECT NOW()')
  .then(() => {
    console.log('✅ PostgreSQL pool connected to', process.env.DB_NAME || 'chainex_db');
  })
  .catch(err => {
    console.error('❌ PostgreSQL connection failed:', err.message);
  });

module.exports = pool;
