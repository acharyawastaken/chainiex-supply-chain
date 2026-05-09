// ─── Products Routes (/api/products) ───
const router = require('express').Router();
const db     = require('../db');

router.get('/', async (_req, res) => {
  try {
    const result = await db.query(`
      SELECT p.*, c.category_name, s.company_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.category_id
      LEFT JOIN suppliers  s ON p.supplier_id  = s.supplier_id
      ORDER BY p.product_id LIMIT 200
    `);
    res.json({ success: true, data: result.rows });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed to fetch products' }); }
});

router.get('/:id', async (req, res) => {
  try {
    const result = await db.query(`
      SELECT p.*, c.category_name, s.company_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.category_id
      LEFT JOIN suppliers  s ON p.supplier_id  = s.supplier_id
      WHERE p.product_id = $1
    `, [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Product not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed' }); }
});

router.post('/', async (req, res) => {
  try {
    const { product_name, description, price, stock_quantity, supplier_id, category_id } = req.body;
    if (!product_name || price === undefined || !supplier_id || !category_id) {
      return res.status(400).json({ success: false, error: 'product_name, price, supplier_id, and category_id are required' });
    }
    const result = await db.query(
      'INSERT INTO products (product_name, description, price, stock_quantity, supplier_id, category_id) VALUES ($1, $2, $3, $4, $5, $6) RETURNING product_id',
      [product_name, description || null, price, stock_quantity || 0, supplier_id, category_id]
    );
    res.status(201).json({ success: true, data: { product_id: result.rows[0].product_id, message: 'Product created' } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Create failed' }); }
});

router.patch('/:id', async (req, res) => {
  try {
    const { product_name, description, price, stock_quantity, supplier_id, category_id } = req.body;
    await db.query(`
      UPDATE products SET
        product_name   = COALESCE($1, product_name),
        description    = COALESCE($2, description),
        price          = COALESCE($3, price),
        stock_quantity = COALESCE($4, stock_quantity),
        supplier_id    = COALESCE($5, supplier_id),
        category_id    = COALESCE($6, category_id)
      WHERE product_id = $7
    `, [product_name, description, price, stock_quantity, supplier_id, category_id, req.params.id]);
    res.json({ success: true, data: { message: 'Product updated' } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Update failed' }); }
});

router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM products WHERE product_id = $1', [req.params.id]);
    if (!result.rowCount) return res.status(404).json({ success: false, error: 'Product not found' });
    res.json({ success: true, data: { message: 'Product deleted' } });
  } catch (err) {
    if (err.code === '23503') return res.status(409).json({ success: false, error: 'Cannot delete — product has order references' });
    console.error(err); res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
