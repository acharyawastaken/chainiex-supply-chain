// ─── Categories Routes (/api/categories) ───
const router = require('express').Router();
const db     = require('../db');

router.get('/', async (_req, res) => {
  try {
    const result = await db.query('SELECT * FROM categories ORDER BY category_id LIMIT 100');
    res.json({ success: true, data: result.rows });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed to fetch categories' }); }
});

router.get('/:id', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM categories WHERE category_id = $1', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Category not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed' }); }
});

router.post('/', async (req, res) => {
  try {
    const { category_name } = req.body;
    if (!category_name) return res.status(400).json({ success: false, error: 'category_name is required' });
    const result = await db.query(
      'INSERT INTO categories (category_name) VALUES ($1) RETURNING category_id',
      [category_name]
    );
    res.status(201).json({ success: true, data: { category_id: result.rows[0].category_id, message: 'Category created' } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Create failed' }); }
});

router.patch('/:id', async (req, res) => {
  try {
    const { category_name } = req.body;
    await db.query('UPDATE categories SET category_name = COALESCE($1, category_name) WHERE category_id = $2', [category_name, req.params.id]);
    res.json({ success: true, data: { message: 'Category updated' } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Update failed' }); }
});

router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM categories WHERE category_id = $1', [req.params.id]);
    if (!result.rowCount) return res.status(404).json({ success: false, error: 'Category not found' });
    res.json({ success: true, data: { message: 'Category deleted' } });
  } catch (err) {
    if (err.code === '23503') return res.status(409).json({ success: false, error: 'Cannot delete — products are assigned to this category' });
    console.error(err); res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
