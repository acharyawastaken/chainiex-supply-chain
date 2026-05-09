// ─── Categories Routes (/api/categories) ───
const router = require('express').Router();
const db     = require('../db');

// GET /api/categories
router.get('/', async (_req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM categories ORDER BY category_id LIMIT 100');
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch categories' });
  }
});

// GET /api/categories/:id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM categories WHERE category_id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ success: false, error: 'Category not found' });
    res.json({ success: true, data: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch category' });
  }
});

// POST /api/categories
router.post('/', async (req, res) => {
  try {
    const { category_name } = req.body;
    if (!category_name) {
      return res.status(400).json({ success: false, error: 'category_name is required' });
    }
    const [result] = await db.query(
      'INSERT INTO categories (category_name) VALUES (?)',
      [category_name]
    );
    res.status(201).json({ success: true, data: { category_id: result.insertId, message: 'Category created' } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Create failed' });
  }
});

// PATCH /api/categories/:id
router.patch('/:id', async (req, res) => {
  try {
    const { category_name } = req.body;
    await db.query(
      'UPDATE categories SET category_name = COALESCE(?, category_name) WHERE category_id = ?',
      [category_name, req.params.id]
    );
    res.json({ success: true, data: { message: 'Category updated' } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Update failed' });
  }
});

// DELETE /api/categories/:id
router.delete('/:id', async (req, res) => {
  try {
    const [result] = await db.query('DELETE FROM categories WHERE category_id = ?', [req.params.id]);
    if (!result.affectedRows) return res.status(404).json({ success: false, error: 'Category not found' });
    res.json({ success: true, data: { message: 'Category deleted' } });
  } catch (err) {
    if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.errno === 1451) {
      return res.status(409).json({ success: false, error: 'Cannot delete — products are assigned to this category' });
    }
    console.error(err);
    res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
