// ─────────────────────────────────────────────
// MySQL Connection Pool (mysql2)
// ─────────────────────────────────────────────
require('dotenv').config({ path: '../.env' });
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host:     process.env.DB_HOST || 'localhost',
  port:     parseInt(process.env.DB_PORT || '3306', 10),
  user:     process.env.DB_USER || 'root',
  password: process.env.DB_PASS || 'root',
  database: process.env.DB_NAME || 'chainex_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  // Return dates as strings, not JS Date objects
  dateStrings: true
});

// Quick connectivity check on startup
pool.getConnection()
  .then(conn => {
    console.log('✅ MySQL pool connected to', process.env.DB_NAME || 'chainex_db');
    conn.release();
  })
  .catch(err => {
    console.error('❌ MySQL connection failed:', err.message);
  });

module.exports = pool;
