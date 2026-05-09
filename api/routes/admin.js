const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../db');
const { authenticate, requireAdmin } = require('../middleware/auth');
const SECRET = process.env.JWT_SECRET || 'replace_this_before_production';

// POST /api/admin/login
router.post('/login', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    const field = username ? 'username' : 'email';
    const val = username || email;
    if (!val || !password) return res.status(400).json({ success: false, error: 'Credentials required' });
    const [rows] = await db.query(`SELECT * FROM admins WHERE ${field} = ?`, [val]);
    if (!rows.length) return res.status(401).json({ success: false, error: 'Invalid credentials' });
    const admin = rows[0];
    const match = await bcrypt.compare(password, admin.password_hash);
    if (!match) return res.status(401).json({ success: false, error: 'Invalid credentials' });
    const token = jwt.sign({ id: admin.admin_id, role: 'admin' }, SECRET, { expiresIn: '8h' });
    res.json({ success: true, token, admin_id: admin.admin_id, username: admin.username });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Login failed' });
  }
});

// GET /api/admin/stats
router.get('/stats', async (_req, res) => {
  try {
    const [[{totalOrders}]] = await db.query('SELECT COUNT(*) as totalOrders FROM orders');
    const [[{totalRevenue}]] = await db.query('SELECT COALESCE(SUM(total_amount),0) as totalRevenue FROM orders WHERE status != "Cancelled"');
    const [[{totalUsers}]] = await db.query('SELECT COUNT(*) as totalUsers FROM users');
    const [[{lowStock}]] = await db.query('SELECT COUNT(*) as lowStock FROM products WHERE stock_quantity < 10');
    res.json({ success: true, totalOrders, totalRevenue, totalUsers, lowStock });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Stats failed' });
  }
});

module.exports = router;
