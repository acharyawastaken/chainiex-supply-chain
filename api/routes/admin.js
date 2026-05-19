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

// GET /api/admin/analytics
router.get('/analytics', async (_req, res) => {
  try {
    // 1. Revenue by supplier
    const revBySupplier = await db.query(`
      SELECT s.company_name, COALESCE(SUM(oi.quantity * oi.price_at_purchase),0) as revenue
      FROM suppliers s
      LEFT JOIN products p ON p.supplier_id = s.supplier_id
      LEFT JOIN order_items oi ON oi.product_id = p.product_id
      LEFT JOIN orders o ON o.order_id = oi.order_id AND o.status != 'Cancelled'
      GROUP BY s.company_name ORDER BY revenue DESC
    `);

    // 2. Products by category
    const prodsByCat = await db.query(`
      SELECT c.category_name, COUNT(p.product_id) as count
      FROM categories c LEFT JOIN products p ON p.category_id = c.category_id
      GROUP BY c.category_name ORDER BY count DESC
    `);

    // 3. Order status distribution
    const orderStatus = await db.query(`
      SELECT status, COUNT(*) as count FROM orders GROUP BY status
    `);

    // 4. Stock by supplier
    const stockBySupplier = await db.query(`
      SELECT s.company_name, COALESCE(SUM(p.stock_quantity),0) as total_stock
      FROM suppliers s LEFT JOIN products p ON p.supplier_id = s.supplier_id
      GROUP BY s.company_name ORDER BY total_stock DESC
    `);

    // 5. Monthly revenue trend (last 6 months)
    const monthlyRev = await db.query(`
      SELECT TO_CHAR(DATE_TRUNC('month', order_date), 'Mon YYYY') as month,
             SUM(total_amount) as revenue
      FROM orders WHERE status != 'Cancelled'
      GROUP BY DATE_TRUNC('month', order_date)
      ORDER BY DATE_TRUNC('month', order_date) DESC LIMIT 6
    `);

    res.json({
      success: true,
      revenueBySupplier: revBySupplier.rows,
      productsByCategory: prodsByCat.rows,
      orderStatus: orderStatus.rows,
      stockBySupplier: stockBySupplier.rows,
      monthlyRevenue: monthlyRev.rows.reverse()
    });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Analytics failed' }); }
});

module.exports = router;
