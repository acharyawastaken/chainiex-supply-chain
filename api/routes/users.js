// ─── Users Routes (/api/users) ───
const router = require('express').Router();
const db     = require('../db');
const { authenticate } = require('../middleware/auth');

// GET /api/users
router.get('/', async (_req, res) => {
  try {
    const result = await db.query(
      'SELECT user_id, full_name, email, shipping_address, created_at FROM users ORDER BY created_at DESC LIMIT 200'
    );
    res.json({ success: true, data: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch users' });
  }
});

// GET /api/users/:id
router.get('/:id', authenticate, async (req, res) => {
  try {
    const result = await db.query(
      'SELECT user_id, full_name, email, shipping_address, created_at FROM users WHERE user_id = $1',
      [req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'User not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch user' });
  }
});

// PATCH /api/users/:id
router.patch('/:id', authenticate, async (req, res) => {
  try {
    const { full_name, shipping_address } = req.body;
    await db.query(
      'UPDATE users SET full_name = COALESCE($1, full_name), shipping_address = COALESCE($2, shipping_address) WHERE user_id = $3',
      [full_name, shipping_address, req.params.id]
    );
    res.json({ success: true, data: { message: 'User updated' } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Update failed' });
  }
});

// DELETE /api/users/:id
router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM users WHERE user_id = $1', [req.params.id]);
    if (!result.rowCount) return res.status(404).json({ success: false, error: 'User not found' });
    res.json({ success: true, data: { message: 'User deleted' } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
