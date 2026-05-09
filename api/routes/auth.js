// ─── Auth Routes (/api/auth) ───
const router  = require('express').Router();
const bcrypt  = require('bcryptjs');
const jwt     = require('jsonwebtoken');
const db      = require('../db');

const SECRET  = process.env.JWT_SECRET || 'replace_this_before_production';
const EXPIRES = '24h';

// POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { full_name, email, password, shipping_address } = req.body;
    if (!full_name || !email || !password) {
      return res.status(400).json({ success: false, error: 'full_name, email, and password are required' });
    }
    const hash = await bcrypt.hash(password, 12);
    const result = await db.query(
      'INSERT INTO users (full_name, email, password_hash, shipping_address) VALUES ($1, $2, $3, $4) RETURNING user_id',
      [full_name, email, hash, shipping_address || null]
    );
    const userId = result.rows[0].user_id;
    const token = jwt.sign({ id: userId, role: 'user' }, SECRET, { expiresIn: EXPIRES });
    res.status(201).json({ success: true, token, user_id: userId, full_name });
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({ success: false, error: 'Email already registered' });
    }
    console.error(err);
    res.status(500).json({ success: false, error: 'Registration failed' });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, error: 'Email and password required' });
    }
    const result = await db.query('SELECT * FROM users WHERE email = $1', [email]);
    if (!result.rows.length) {
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }
    const user = result.rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ success: false, error: 'Invalid credentials' });
    }
    const token = jwt.sign({ id: user.user_id, role: 'user' }, SECRET, { expiresIn: EXPIRES });
    res.json({ success: true, token, user_id: user.user_id, full_name: user.full_name });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Login failed' });
  }
});

// POST /api/auth/logout
router.post('/logout', (_req, res) => {
  res.json({ success: true, data: { message: 'Logged out' } });
});

module.exports = router;
