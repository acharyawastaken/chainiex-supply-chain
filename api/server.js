// ─────────────────────────────────────────────
// ChaiNIEx API — Express Entry Point
// ─────────────────────────────────────────────
require('dotenv').config({ path: '../.env' });
const express = require('express');
const cors    = require('cors');
const path    = require('path');

const app  = express();
const PORT = process.env.PORT || 4000;

// ─── Middleware ───
app.use(cors());
app.use(express.json());

// Request logger (dev)
app.use((req, _res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// ─── API Routes ───
app.use('/api/auth',       require('./routes/auth'));
app.use('/api/users',      require('./routes/users'));
app.use('/api/suppliers',  require('./routes/suppliers'));
app.use('/api/categories', require('./routes/categories'));
app.use('/api/products',   require('./routes/products'));
app.use('/api/orders',     require('./routes/orders'));
app.use('/api/admin',      require('./routes/admin'));

// ─── Health check ───
app.get('/api/health', (_req, res) => {
  res.json({ success: true, data: { status: 'ok', timestamp: new Date().toISOString() } });
});

// ─── Serve Frontend Portals ───
const frontendDir = path.join(__dirname, '..', 'frontend');

// Customer portal at /
app.get('/', (_req, res) => res.sendFile(path.join(frontendDir, 'customer', 'index.html')));

// Admin portal at /admin
app.get('/admin', (_req, res) => res.sendFile(path.join(frontendDir, 'admin', 'index.html')));

// Supplier/Delivery portal at /supplier
app.get('/supplier', (_req, res) => res.sendFile(path.join(frontendDir, 'supplier', 'index.html')));

// Serve static frontend assets (CSS, JS, images if any)
app.use('/frontend', express.static(frontendDir));

// ─── 404 fallback ───
app.use((_req, res) => {
  res.status(404).json({ success: false, error: 'Route not found' });
});

// ─── Global error handler ───
app.use((err, _req, res, _next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ success: false, error: 'Internal server error' });
});

// ─── Start ───
app.listen(PORT, () => {
  console.log(`🚀 ChaiNIEx API running on http://localhost:${PORT}`);
  console.log(`   Customer: http://localhost:${PORT}/`);
  console.log(`   Admin:    http://localhost:${PORT}/admin`);
  console.log(`   Delivery: http://localhost:${PORT}/supplier`);
});
