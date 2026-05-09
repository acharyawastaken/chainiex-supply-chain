// ─────────────────────────────────────────────
// JWT Authentication Middleware
// ─────────────────────────────────────────────
const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'replace_this_before_production';

/**
 * Verify JWT from Authorization header.
 * Attaches decoded payload to req.user
 */
function authenticate(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, error: 'Authentication required' });
  }
  try {
    const token = header.split(' ')[1];
    req.user = jwt.verify(token, SECRET);
    next();
  } catch {
    return res.status(401).json({ success: false, error: 'Invalid or expired token' });
  }
}

/**
 * Require admin role in JWT payload
 */
function requireAdmin(req, res, next) {
  if (req.user?.role !== 'admin') {
    return res.status(403).json({ success: false, error: 'Admin access required' });
  }
  next();
}

module.exports = { authenticate, requireAdmin };
