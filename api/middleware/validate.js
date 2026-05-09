// ─────────────────────────────────────────────
// Request Body Validation Middleware
// ─────────────────────────────────────────────

const VALID_STATUSES = ['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];

/**
 * Require specific fields in req.body
 */
function requireFields(...fields) {
  return (req, res, next) => {
    const missing = fields.filter(f => req.body[f] === undefined || req.body[f] === '');
    if (missing.length) {
      return res.status(400).json({
        success: false,
        error: `Missing required fields: ${missing.join(', ')}`
      });
    }
    next();
  };
}

/**
 * Validate order status is in the allowed enum
 */
function validateOrderStatus(req, res, next) {
  if (req.body.status && !VALID_STATUSES.includes(req.body.status)) {
    return res.status(400).json({
      success: false,
      error: `Invalid status. Must be one of: ${VALID_STATUSES.join(', ')}`
    });
  }
  next();
}

module.exports = { requireFields, validateOrderStatus, VALID_STATUSES };
