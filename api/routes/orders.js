const router = require('express').Router();
const db = require('../db');
const { validateOrderStatus } = require('../middleware/validate');

router.get('/', async (_req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT o.*, u.full_name FROM orders o
       LEFT JOIN users u ON o.user_id = u.user_id
       ORDER BY o.order_date DESC LIMIT 200`
    );
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch orders' });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const [orders] = await db.query(
      `SELECT o.*, u.full_name FROM orders o
       LEFT JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?`,
      [req.params.id]
    );
    if (!orders.length) return res.status(404).json({ success: false, error: 'Not found' });
    const [items] = await db.query(
      `SELECT oi.*, p.product_name FROM order_items oi
       LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?`,
      [req.params.id]
    );
    res.json({ success: true, data: { ...orders[0], items } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed' });
  }
});

router.get('/:id/items', async (req, res) => {
  try {
    const [items] = await db.query(
      `SELECT oi.*, p.product_name FROM order_items oi
       LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?`,
      [req.params.id]
    );
    res.json({ success: true, data: items });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed' });
  }
});

router.post('/', async (req, res) => {
  const conn = await db.getConnection();
  try {
    const { items, total_amount } = req.body;
    const user_id = req.body.user_id || 1;
    if (!items?.length) { conn.release(); return res.status(400).json({ success: false, error: 'Need items' }); }
    await conn.beginTransaction();
    let calc = 0;
    for (const item of items) {
      const [p] = await conn.query('SELECT product_id, price, stock_quantity FROM products WHERE product_id = ? FOR UPDATE', [item.product_id]);
      if (!p.length) { await conn.rollback(); conn.release(); return res.status(404).json({ success: false, error: `Product ${item.product_id} not found` }); }
      if (p[0].stock_quantity < item.quantity) { await conn.rollback(); conn.release(); return res.status(400).json({ success: false, error: `Insufficient stock for ${item.product_id}` }); }
      item._price = p[0].price;
      calc += p[0].price * item.quantity;
    }
    const [r] = await conn.query('INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, ?)', [user_id, total_amount || calc, 'Pending']);
    for (const item of items) {
      await conn.query('INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)', [r.insertId, item.product_id, item.quantity, item._price]);
      await conn.query('UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?', [item.quantity, item.product_id]);
    }
    await conn.commit(); conn.release();
    res.status(201).json({ success: true, data: { order_id: r.insertId } });
  } catch (err) {
    await conn.rollback(); conn.release();
    console.error(err);
    res.status(500).json({ success: false, error: 'Order failed' });
  }
});

router.patch('/:id', validateOrderStatus, async (req, res) => {
  try {
    const { status } = req.body;
    if (status === 'Cancelled') {
      const [cur] = await db.query('SELECT status FROM orders WHERE order_id = ?', [req.params.id]);
      if (cur.length && cur[0].status === 'Pending') {
        const [items] = await db.query('SELECT product_id, quantity FROM order_items WHERE order_id = ?', [req.params.id]);
        for (const i of items) await db.query('UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ?', [i.quantity, i.product_id]);
      }
    }
    const [r] = await db.query('UPDATE orders SET status = ? WHERE order_id = ?', [status, req.params.id]);
    if (!r.affectedRows) return res.status(404).json({ success: false, error: 'Not found' });
    res.json({ success: true, data: { message: `Status → ${status}` } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Update failed' });
  }
});

module.exports = router;
