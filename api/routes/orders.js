// ─── Orders Routes (/api/orders) ───
const router = require('express').Router();
const db     = require('../db');
const { validateOrderStatus } = require('../middleware/validate');

router.get('/', async (_req, res) => {
  try {
    const result = await db.query(
      `SELECT o.*, u.full_name FROM orders o
       LEFT JOIN users u ON o.user_id = u.user_id
       ORDER BY o.order_date DESC LIMIT 200`
    );
    res.json({ success: true, data: result.rows });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed to fetch orders' }); }
});

router.get('/:id', async (req, res) => {
  try {
    const orders = await db.query(
      `SELECT o.*, u.full_name FROM orders o
       LEFT JOIN users u ON o.user_id = u.user_id WHERE o.order_id = $1`,
      [req.params.id]
    );
    if (!orders.rows.length) return res.status(404).json({ success: false, error: 'Not found' });
    const items = await db.query(
      `SELECT oi.*, p.product_name FROM order_items oi
       LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = $1`,
      [req.params.id]
    );
    res.json({ success: true, data: { ...orders.rows[0], items: items.rows } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed' }); }
});

router.get('/:id/items', async (req, res) => {
  try {
    const items = await db.query(
      `SELECT oi.*, p.product_name FROM order_items oi
       LEFT JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = $1`,
      [req.params.id]
    );
    res.json({ success: true, data: items.rows });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed' }); }
});

// POST /api/orders — transactional order placement
router.post('/', async (req, res) => {
  const client = await db.connect(); // get a client from pool for transaction
  try {
    const { items, total_amount } = req.body;
    const user_id = req.body.user_id || 1;
    if (!items?.length) { client.release(); return res.status(400).json({ success: false, error: 'Need items' }); }

    await client.query('BEGIN');

    // 1. Lock product rows and verify stock
    let calc = 0;
    for (const item of items) {
      const p = await client.query(
        'SELECT product_id, price, stock_quantity FROM products WHERE product_id = $1 FOR UPDATE',
        [item.product_id]
      );
      if (!p.rows.length) { await client.query('ROLLBACK'); client.release(); return res.status(404).json({ success: false, error: `Product ${item.product_id} not found` }); }
      if (p.rows[0].stock_quantity < item.quantity) { await client.query('ROLLBACK'); client.release(); return res.status(400).json({ success: false, error: `Insufficient stock for ${item.product_id}` }); }
      item._price = p.rows[0].price;
      calc += parseFloat(p.rows[0].price) * item.quantity;
    }

    // 2. Insert order
    const r = await client.query(
      'INSERT INTO orders (user_id, total_amount, status) VALUES ($1, $2, $3) RETURNING order_id',
      [user_id, total_amount || calc, 'Pending']
    );
    const orderId = r.rows[0].order_id;

    // 3. Insert items + decrement stock
    for (const item of items) {
      await client.query(
        'INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES ($1, $2, $3, $4)',
        [orderId, item.product_id, item.quantity, item._price]
      );
      await client.query(
        'UPDATE products SET stock_quantity = stock_quantity - $1 WHERE product_id = $2',
        [item.quantity, item.product_id]
      );
    }

    await client.query('COMMIT');
    client.release();
    res.status(201).json({ success: true, data: { order_id: orderId } });
  } catch (err) {
    await client.query('ROLLBACK');
    client.release();
    console.error(err);
    res.status(500).json({ success: false, error: 'Order failed' });
  }
});

// PATCH /api/orders/:id — update status
router.patch('/:id', validateOrderStatus, async (req, res) => {
  try {
    const { status } = req.body;
    // If cancelling a Pending order, restore stock
    if (status === 'Cancelled') {
      const cur = await db.query('SELECT status FROM orders WHERE order_id = $1', [req.params.id]);
      if (cur.rows.length && cur.rows[0].status === 'Pending') {
        const items = await db.query('SELECT product_id, quantity FROM order_items WHERE order_id = $1', [req.params.id]);
        for (const i of items.rows) {
          await db.query('UPDATE products SET stock_quantity = stock_quantity + $1 WHERE product_id = $2', [i.quantity, i.product_id]);
        }
      }
    }
    const r = await db.query('UPDATE orders SET status = $1 WHERE order_id = $2', [status, req.params.id]);
    if (!r.rowCount) return res.status(404).json({ success: false, error: 'Not found' });
    res.json({ success: true, data: { message: `Status → ${status}` } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Update failed' }); }
});

module.exports = router;
