// ─── Suppliers Routes (/api/suppliers) ───
const router = require('express').Router();
const db     = require('../db');

router.get('/', async (_req, res) => {
  try {
    const result = await db.query('SELECT * FROM suppliers ORDER BY supplier_id LIMIT 200');
    res.json({ success: true, data: result.rows });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed to fetch suppliers' }); }
});

router.get('/:id', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM suppliers WHERE supplier_id = $1', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ success: false, error: 'Supplier not found' });
    res.json({ success: true, data: result.rows[0] });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Failed' }); }
});

router.post('/', async (req, res) => {
  try {
    const { company_name, contact_email, phone_number, bank_details } = req.body;
    if (!company_name || !contact_email) return res.status(400).json({ success: false, error: 'company_name and contact_email required' });
    const result = await db.query(
      'INSERT INTO suppliers (company_name, contact_email, phone_number, bank_details) VALUES ($1, $2, $3, $4) RETURNING supplier_id',
      [company_name, contact_email, phone_number || null, bank_details || null]
    );
    res.status(201).json({ success: true, data: { supplier_id: result.rows[0].supplier_id, message: 'Supplier created' } });
  } catch (err) {
    if (err.code === '23505') return res.status(409).json({ success: false, error: 'Email already exists' });
    console.error(err); res.status(500).json({ success: false, error: 'Create failed' });
  }
});

router.patch('/:id', async (req, res) => {
  try {
    const { company_name, contact_email, phone_number, bank_details } = req.body;
    await db.query(
      `UPDATE suppliers SET
         company_name  = COALESCE($1, company_name),
         contact_email = COALESCE($2, contact_email),
         phone_number  = COALESCE($3, phone_number),
         bank_details  = COALESCE($4, bank_details)
       WHERE supplier_id = $5`,
      [company_name, contact_email, phone_number, bank_details, req.params.id]
    );
    res.json({ success: true, data: { message: 'Supplier updated' } });
  } catch (err) { console.error(err); res.status(500).json({ success: false, error: 'Update failed' }); }
});

router.delete('/:id', async (req, res) => {
  try {
    const result = await db.query('DELETE FROM suppliers WHERE supplier_id = $1', [req.params.id]);
    if (!result.rowCount) return res.status(404).json({ success: false, error: 'Supplier not found' });
    res.json({ success: true, data: { message: 'Supplier deleted' } });
  } catch (err) {
    if (err.code === '23503') return res.status(409).json({ success: false, error: 'Cannot delete — supplier has active products' });
    console.error(err); res.status(500).json({ success: false, error: 'Delete failed' });
  }
});

module.exports = router;
