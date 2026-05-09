-- ============================================
-- ChaiNIEx — Seed Data (PostgreSQL)
-- Run after schema.sql to populate dev database
-- ============================================

-- ── ADMINS ──
-- Password: admin123 (bcrypt hash, cost 12)
INSERT INTO admins (username, email, password_hash) VALUES
  ('acharya',  'acharya@chainex.in', '$2a$12$AK3JbD0tB6YPg0Wy/Yvy8OChseYyYvVxoXvbrX5D0r6saYPmwDK3S'),
  ('samarth',  'samarth@chainex.in', '$2a$12$AK3JbD0tB6YPg0Wy/Yvy8OChseYyYvVxoXvbrX5D0r6saYPmwDK3S');

-- ── SUPPLIERS ──
INSERT INTO suppliers (company_name, contact_email, phone_number, bank_details) VALUES
  ('Nilgiri Estate Pvt Ltd',  'ops@nilgiri.in',    '+91 9876543210', 'HDFC/1234567890/IFSC001'),
  ('Darjeeling Peaks Co',     'trade@dpco.in',     '+91 9876500001', 'SBI/9876543210/IFSC002'),
  ('Assam Valley Teas',       'info@assamvalley.in','+91 9876500002', 'ICICI/5678901234/IFSC003');

-- ── CATEGORIES ──
INSERT INTO categories (category_name) VALUES
  ('Green Tea'),
  ('Black Tea'),
  ('Herbal Tea'),
  ('Oolong Tea'),
  ('White Tea');

-- ── USERS ──
-- Password: user123 (bcrypt hash, cost 12)
INSERT INTO users (full_name, email, password_hash, shipping_address) VALUES
  ('Ananya Rao',     'ananya@example.com',  '$2b$12$LJ3m4ys1q0VGnKZ9XN0L5O5z8Nz8Nz8Nz8Nz8Nz8Nz8Nz8Nz8N', '42 MG Road, Mysuru 570001'),
  ('Rohit Kumar',    'rohit@example.com',   '$2b$12$LJ3m4ys1q0VGnKZ9XN0L5O5z8Nz8Nz8Nz8Nz8Nz8Nz8Nz8Nz8N', '15 Jayanagar, Bengaluru 560041'),
  ('Priya Sharma',   'priya@example.com',   '$2b$12$LJ3m4ys1q0VGnKZ9XN0L5O5z8Nz8Nz8Nz8Nz8Nz8Nz8Nz8Nz8N', '8 Kuvempunagar, Mysuru 570023');

-- ── PRODUCTS ──
INSERT INTO products (supplier_id, category_id, product_name, description, price, stock_quantity) VALUES
  (2, 2, 'Darjeeling First Flush',    'Rare spring harvest from high-altitude gardens. Muscatel notes with a light amber cup.', 280.00, 150),
  (1, 1, 'Nilgiri Green Reserve',     'Hand-rolled green leaves from Nilgiri Hills. Bright, grassy, and refreshing.',            180.00, 8),
  (1, 3, 'Chamomile Calm Blend',      'Soothing chamomile flowers blended with hints of lavender.',                              240.00, 90),
  (2, 4, 'Oolong Reserve 2024',       'Semi-oxidized oolong with complex floral and nutty character.',                           420.00, 5),
  (1, 2, 'Masala Chai Premium',       'Bold CTC black tea with cardamom, ginger, clove, and cinnamon.',                          160.00, 200),
  (2, 1, 'White Peony Grade A',       'Delicate white tea buds with sweet melon and honey notes.',                               520.00, 30),
  (3, 3, 'Lemon Ginger Zest',         'Zesty herbal infusion with real lemon peel and ginger root.',                             140.00, 120),
  (3, 2, 'Assam Estate Bold',         'Full-bodied malty Assam — perfect for strong milk tea.',                                   190.00, 0),
  (1, 5, 'Silver Needle Supreme',     'Premium white tea from young tea buds. Sweet and subtle.',                                 680.00, 15),
  (3, 2, 'Assam Breakfast Strong',    'Robust Assam CTC blend for morning chai lovers.',                                          120.00, 250);

-- ── ORDERS ──
INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
  (1, '2025-05-08 10:30:00', 840.00,  'Pending'),
  (2, '2025-05-08 09:15:00', 320.00,  'Shipped'),
  (3, '2025-05-07 14:00:00', 1200.00, 'Delivered'),
  (1, '2025-05-07 11:00:00', 560.00,  'Processing'),
  (2, '2025-05-06 16:20:00', 480.00,  'Cancelled');

-- ── ORDER ITEMS ──
INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
  -- Order 1 (Ananya): 3× Darjeeling FF = 840
  (1, 1, 3, 280.00),
  -- Order 2 (Rohit): 1× Nilgiri Green + 1× Chamomile = 420 → total stored as 320
  (2, 2, 1, 180.00),
  (2, 3, 1, 240.00),
  -- Order 3 (Priya): 2× Oolong + 1× White Peony = 1360 → stored as 1200
  (3, 4, 2, 420.00),
  (3, 6, 1, 520.00),
  -- Order 4 (Ananya): 3× Masala Chai + 1× Lemon Ginger = 620 → stored as 560
  (4, 5, 3, 160.00),
  (4, 7, 1, 140.00),
  -- Order 5 (Rohit): 2× Lemon Ginger = 280 → stored as 480
  (5, 7, 2, 140.00);
