// ─── Admin Routes (/api/admin) ───
const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../db');
const SECRET = process.env.JWT_SECRET || 'replace_this_before_production';

// POST /api/admin/login
router.post('/login', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    const field = username ? 'username' : 'email';
    const val = username || email;
    if (!val || !password) return res.status(400).json({ success: false, error: 'Credentials required' });
    const result = await db.query(`SELECT * FROM admins WHERE ${field} = $1`, [val]);
    if (!result.rows.length) return res.status(401).json({ success: false, error: 'Invalid credentials' });
    const admin = result.rows[0];
    const match = await bcrypt.compare(password, admin.password_hash);
    if (!match) return res.status(401).json({ success: false, error: 'Invalid credentials' });
    const token = jwt.sign({ id: admin.admin_id, role: 'admin' }, SECRET, { expiresIn: '8h' });
    res.json({ success: true, token, admin_id: admin.admin_id, username: admin.username });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Login failed' }); }
});

// GET /api/admin/stats
router.get('/stats', async (_req, res) => {
  try {
    const totalOrders  = (await db.query('SELECT COUNT(*) as count FROM orders')).rows[0].count;
    const totalRevenue = (await db.query("SELECT COALESCE(SUM(total_amount),0) as sum FROM orders WHERE status != 'Cancelled'")).rows[0].sum;
    const totalUsers   = (await db.query('SELECT COUNT(*) as count FROM users')).rows[0].count;
    const lowStock     = (await db.query('SELECT COUNT(*) as count FROM products WHERE stock_quantity < 10')).rows[0].count;
    res.json({ success: true, totalOrders, totalRevenue, totalUsers, lowStock });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Stats failed' }); }
});

module.exports = router;
