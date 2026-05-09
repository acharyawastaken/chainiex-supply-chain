// ─── Suppliers Routes (/api/suppliers) ───
const router = require('express').Router();
const db     = require('../db');

// GET /api/suppliers
router.get('/', async (_req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM suppliers ORDER BY supplier_id LIMIT 200');
    res.json({ success: true, data: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch suppliers' });
  }
});

// GET /api/suppliers/:id
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM suppliers WHERE supplier_id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ success: false, error: 'Supplier not found' });
    res.json({ success: true, data: rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to fetch supplier' });
  }
});

// POST /api/suppliers
router.post('/', async (req, res) => {
  try {
    const { company_name, contact_email, phone_number, bank_details } = req.body;
    if (!company_name || !contact_email) {
      return res.status(400).json({ success: false, error: 'company_name and contact_email are required' });
    }
    const [result] = await db.query(
      'INSERT INTO suppliers (company_name, contact_email, phone_number, bank_details) VALUES (?, ?, ?, ?)',
      [company_name, contact_email, phone_number || null, bank_details || null]
    );
    res.status(201).json({ success: true, data: { supplier_id: result.insertId, message: 'Supplier created' } });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ success: false, error: 'Email already exists' });
    }
    console.error(err);
    res.status(500).json({ success: false, error: 'Create failed' });
  }
});

// PATCH /api/suppliers/:id
router.patch('/:id', async (req, res) => {
  try {
    const { company_name, contact_email, phone_number, bank_details } = req.body;
    await db.query(
      `UPDATE suppliers SET
         company_name  = COALESCE(?, company_name),
         contact_email = COALESCE(?, contact_email),
         phone_number  = COALESCE(?, phone_number),
         bank_details  = COALESCE(?, bank_details)
       WHERE supplier_id = ?`,
      [company_name, contact_email, phone_number, bank_details, req.params.id]
    );
    res.json({ success: true, data: { message: 'Supplier updated' } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Update failed' });
  }
});

// DELETE /api/suppliers/:id
router.delete('/:id', async (req, res) => {
  try {
    const [result] = await db.query('DELETE FROM suppliers WHERE supplier_id = ?', [req.params.id]);
    if (!result.affectedRows) return res.status(404).json({ success: false, error: 'Supplier not found' });
    res.json({ success: true, data: { message: 'Supplier deleted' } });
  } catch (err) {
    if (err.code === 'ER_ROW_IS_REFERENCED_2' || err.errno === 1451) {
      return res.status(409).json({ success: false, error: 'Cannot delete — supplier has active products' });
    }
    console.error(err);
    res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
