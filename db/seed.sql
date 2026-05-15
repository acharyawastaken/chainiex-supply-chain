-- ============================================
-- ChaiNIEx — Seed Data (PostgreSQL)
-- Run after schema.sql to populate dev database
-- ============================================

-- ── ADMINS ──
-- Password: admin123 (bcrypt hash, cost 12)
INSERT INTO admins (username, email, password_hash) VALUES
  ('acharya',  'acharya@chainex.in', '$2a$12$Bng3GOllevQeW.cKACYvQOCMx8M4XKWv0laNhKl4Y1NL4oqyV4L0.'),
  ('samarth',  'samarth@chainex.in', '$2a$12$Bng3GOllevQeW.cKACYvQOCMx8M4XKWv0laNhKl4Y1NL4oqyV4L0.');

-- ── SUPPLIERS ──
INSERT INTO suppliers (company_name, contact_email, phone_number, bank_details) VALUES
  ('Nilgiri Estate Pvt Ltd',  'ops@nilgiri.in',    '+91 9876543210', 'HDFC/1234567890/IFSC001'),
  ('Darjeeling Peaks Co',     'trade@dpco.in',     '+91 9876500001', 'SBI/9876543210/IFSC002'),
  ('Assam Valley Teas',       'info@assamvalley.in','+91 9876500002', 'ICICI/5678901234/IFSC003'),
  ('Kerala Spice Gardens',    'hello@keralaspice.in','+91 9876500003', 'AXIS/1122334455/IFSC004'),
  ('Himalayan Herbals',       'contact@himherb.in', '+91 9876500004', 'BOB/6677889900/IFSC005');

-- ── CATEGORIES ──
INSERT INTO categories (category_name) VALUES
  ('Green Tea'),
  ('Black Tea'),
  ('Herbal Tea'),
  ('Oolong Tea'),
  ('White Tea'),
  ('Chai Blends'),
  ('Dairy Products');

-- ── USERS ──
-- Password: user123 (bcrypt hash, cost 12)
INSERT INTO users (full_name, email, password_hash, shipping_address) VALUES
  ('Samarth Rao',     'samarth_user@example.com',  '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '42 MG Road, Mysuru 570001'),
  ('Rohit Kumar',    'rohit@example.com',   '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '15 Jayanagar, Bengaluru 560041'),
  ('Tanishq Sharma', 'tanishq@example.com', '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '8 Kuvempunagar, Mysuru 570023');

-- ── PRODUCTS (75 items) ──
INSERT INTO products (supplier_id, category_id, product_name, description, price, stock_quantity, image_url) VALUES
  -- ═══ GREEN TEA (1-12) ═══
  (2, 1, 'Darjeeling Green Delight',    'Light, floral green tea from Darjeeling estates with muscatel hints.',        220.00, 120, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),
  (1, 1, 'Nilgiri Green Reserve',       'Hand-rolled green leaves from Nilgiri Hills. Bright, grassy, and refreshing.', 180.00, 85, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (3, 1, 'Assam Sencha Style',          'Japanese-inspired steaming method applied to Assam green leaves.',             260.00, 65, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),
  (1, 1, 'Mint Green Fusion',           'Refreshing blend of Nilgiri green tea with garden-fresh peppermint.',          200.00, 140, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),
  (4, 1, 'Jasmine Pearl Green',         'Hand-rolled pearls scented with night-blooming jasmine.',                      350.00, 40, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (2, 1, 'Himalayan Green Mist',        'High-altitude green tea with a sweet, vegetal character.',                     280.00, 55, 'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),
  (5, 1, 'Lemongrass Green',            'Aromatic lemongrass blended with young green tea shoots.',                     170.00, 160, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (1, 1, 'Gunpowder Green Classic',     'Tightly rolled pellets that unfurl into a smoky, bold cup.',                   190.00, 95, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (3, 1, 'Tulsi Green Wellness',        'Holy basil infused green tea for immunity and calm.',                          210.00, 110, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (2, 1, 'Matcha Ceremonial Grade',     'Stone-ground shade-grown matcha from premium estates.',                        680.00, 25, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop'),
  (4, 1, 'Dragon Well Longjing',        'Pan-fired flat leaves with a chestnut-like sweetness.',                        420.00, 30, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (1, 1, 'Moroccan Mint Green',         'Classic North African blend of gunpowder green and spearmint.',                230.00, 75, 'https://images.unsplash.com/photo-1574914629385-46448b767aec?w=400&h=400&fit=crop'),

  -- ═══ BLACK TEA (13-24) ═══
  (2, 2, 'Darjeeling First Flush',      'Rare spring harvest from high-altitude gardens. Muscatel notes.',              280.00, 150, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (3, 2, 'Assam Estate Bold',           'Full-bodied malty Assam — perfect for strong milk tea.',                       190.00, 100, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=400&h=400&fit=crop'),
  (3, 2, 'Assam Breakfast Strong',      'Robust Assam CTC blend for morning chai lovers.',                             120.00, 250, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (2, 2, 'Darjeeling Second Flush',     'Full-bodied summer harvest with rich muscatel grape character.',               320.00, 70, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (1, 2, 'Nilgiri Frost Tea',           'Winter-frost kissed tea leaves with a unique brisk flavor.',                   340.00, 35, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (3, 2, 'Assam Golden Tips',           'Premium golden-tipped Assam with honey and malt notes.',                       450.00, 20, 'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),
  (2, 2, 'Earl Grey Supreme',           'Darjeeling black tea with Italian bergamot oil and blue cornflower.',          260.00, 90, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (4, 2, 'English Breakfast Blend',     'Full-bodied breakfast blend of Assam, Nilgiri, and Darjeeling.',               180.00, 200, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),
  (1, 2, 'Irish Breakfast Strong',      'Extra strong blend for those who like a robust morning cup.',                  160.00, 180, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),
  (5, 2, 'Smoky Lapsang Souchong',     'Pine-smoked black tea with a bold, campfire character.',                       380.00, 40, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (3, 2, 'Assam Orthodox Premium',      'Whole-leaf orthodox Assam with complex tannins and body.',                     290.00, 60, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),
  (2, 2, 'Darjeeling Autumn Flush',     'Rare autumn harvest with copper liquor and nutty character.',                  360.00, 25, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop'),

  -- ═══ HERBAL TEA (25-36) ═══
  (1, 3, 'Chamomile Calm Blend',        'Soothing chamomile flowers blended with hints of lavender.',                   240.00, 90, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (3, 3, 'Lemon Ginger Zest',           'Zesty herbal infusion with real lemon peel and ginger root.',                 140.00, 120, 'https://images.unsplash.com/photo-1574914629385-46448b767aec?w=400&h=400&fit=crop'),
  (5, 3, 'Peppermint Bliss',            'Pure dried peppermint leaves for a cool, refreshing brew.',                    130.00, 180, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),
  (4, 3, 'Rose Petal Delight',          'Fragrant Damascus rose petals with a subtle sweet finish.',                    280.00, 50, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (5, 3, 'Hibiscus Ruby',               'Deep red hibiscus flowers with tart, cranberry-like flavor.',                  160.00, 130, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=400&h=400&fit=crop'),
  (1, 3, 'Turmeric Golden Milk',        'Warming turmeric blend with black pepper and cinnamon.',                       220.00, 100, 'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),
  (4, 3, 'Lavender Dream',              'French lavender buds for a calming evening ritual.',                           300.00, 45, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (3, 3, 'Cinnamon Spice Infusion',     'Ceylon cinnamon bark steeped for a sweet, warming cup.',                       170.00, 110, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (5, 3, 'Moringa Superfood Blend',     'Nutrient-rich moringa leaves with a mild, earthy taste.',                      250.00, 70, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (1, 3, 'Fennel Digestive Tea',        'Fennel seeds and ajwain for gentle digestive support.',                        120.00, 160, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),
  (4, 3, 'Elderflower Blossom',         'Delicate elderflower with a honey-like sweetness.',                            310.00, 35, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (3, 3, 'Rooibos Vanilla Sunset',      'South African rooibos with Madagascar vanilla.',                              200.00, 85, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),

  -- ═══ OOLONG TEA (37-46) ═══
  (2, 4, 'Oolong Reserve 2024',         'Semi-oxidized oolong with complex floral and nutty character.',                420.00, 45, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop'),
  (2, 4, 'Darjeeling Oolong Classic',   'Light oolong from Darjeeling with apricot and muscatel notes.',                380.00, 30, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (4, 4, 'Milk Oolong Cream',           'Naturally creamy oolong with a buttery, smooth finish.',                       460.00, 25, 'https://images.unsplash.com/photo-1574914629385-46448b767aec?w=400&h=400&fit=crop'),
  (1, 4, 'Nilgiri Oolong Orchid',       'Medium-oxidized Nilgiri oolong with orchid-like fragrance.',                   350.00, 40, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (2, 4, 'Iron Goddess Tieguanyin',     'Classic Chinese-style oolong with toasty, mineral notes.',                     520.00, 15, 'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),
  (5, 4, 'Himalayan Amber Oolong',      'High-mountain oolong with a warm amber liquor and stone fruit.',               440.00, 20, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),
  (4, 4, 'Oriental Beauty',             'Bug-bitten oolong with natural honey sweetness.',                              580.00, 12, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=400&h=400&fit=crop'),
  (1, 4, 'Roasted Oolong Dark',         'Heavily roasted oolong with caramel and chocolate undertones.',                300.00, 55, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (3, 4, 'Phoenix Dan Cong',            'Single-bush oolong with intense peach and lychee aroma.',                      620.00, 10, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (2, 4, 'Four Seasons Spring',         'Light, floral Taiwanese-style oolong with gardenia fragrance.',                390.00, 35, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),

  -- ═══ WHITE TEA (47-55) ═══
  (2, 5, 'White Peony Grade A',         'Delicate white tea buds with sweet melon and honey notes.',                    520.00, 30, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (1, 5, 'Silver Needle Supreme',       'Premium white tea from young tea buds. Sweet and subtle.',                     680.00, 15, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (2, 5, 'Moonlight White Beauty',      'Sun-dried white tea with a honey-apricot sweetness.',                          550.00, 20, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),
  (5, 5, 'Himalayan White Pearl',       'Rare hand-picked white tea buds from Himalayan slopes.',                       720.00, 10, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop'),
  (1, 5, 'Nilgiri White Frost',         'Frost-season white tea with a delicate, ethereal quality.',                    480.00, 25, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (4, 5, 'White Rose Petal',            'White tea blended with fragrant pink rose petals.',                            420.00, 35, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (2, 5, 'Aged White Tribute',          'Aged white tea with deep, complex flavors and smoothness.',                    850.00, 8,  'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),
  (3, 5, 'Snow Bud Special',            'Downy white buds picked at dawn for maximum sweetness.',                       600.00, 18, 'https://images.unsplash.com/photo-1574914629385-46448b767aec?w=400&h=400&fit=crop'),
  (1, 5, 'White Peach Blossom',         'White tea infused with natural peach and spring blossoms.',                    380.00, 45, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),

  -- ═══ CHAI BLENDS (56-66) ═══
  (1, 6, 'Masala Chai Premium',         'Bold CTC black tea with cardamom, ginger, clove, and cinnamon.',               160.00, 200, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (3, 6, 'Cutting Chai Special',        'Mumbai street-style strong chai with ginger and elaichi.',                     100.00, 300, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=400&h=400&fit=crop'),
  (4, 6, 'Kashmiri Kahwa',              'Saffron, almonds, and green tea — the royal Kashmiri brew.',                   340.00, 50, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (1, 6, 'Adrak Chai Blend',            'Ginger-forward chai blend for cold winter mornings.',                          130.00, 220, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),
  (3, 6, 'Bombay Tapri Mix',            'The iconic tapri chai blend — strong, sweet, milky.',                          90.00,  350, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (5, 6, 'Himalayan Spiced Chai',       'High-altitude CTC with Himalayan spice blend.',                               180.00, 130, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),
  (4, 6, 'Chocolate Chai Indulgence',   'Black tea with cocoa nibs and warm spices.',                                   250.00, 60, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (1, 6, 'Vanilla Chai Latte Mix',      'Creamy vanilla chai blend — just add hot milk.',                               200.00, 100, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop'),
  (3, 6, 'Sulaimani Chai Kerala',       'Kerala-style black tea with lemon and spices. No milk.',                       150.00, 90, 'https://images.unsplash.com/photo-1563911892437-1feda0179e1b?w=400&h=400&fit=crop'),
  (2, 6, 'Darjeeling Masala Chai',      'Premium Darjeeling leaves with artisan masala blend.',                         280.00, 40, 'https://images.unsplash.com/photo-1558160074-4d7d8bdf4256?w=400&h=400&fit=crop'),
  (4, 6, 'Irani Chai Blend',            'Hyderabadi Irani chai — creamy, milky, and iconic.',                           140.00, 170, 'https://images.unsplash.com/photo-1587888637308-a5d7d28f6940?w=400&h=400&fit=crop'),

  -- ═══ DAIRY PRODUCTS (67-75) ═══
  (4, 7, 'Chai Latte Concentrate',      'Ready-to-mix chai concentrate — just add milk.',                               320.00, 80, 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=400&h=400&fit=crop'),
  (1, 7, 'Matcha Latte Powder',         'Premium matcha pre-mixed with organic milk powder.',                           450.00, 40, 'https://images.unsplash.com/photo-1594631252845-29fc4cc8cde9?w=400&h=400&fit=crop'),
  (5, 7, 'Golden Turmeric Latte',       'Instant turmeric golden milk with coconut cream.',                             280.00, 65, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400&h=400&fit=crop'),
  (3, 7, 'Rose Chai Latte Mix',         'Rose-infused chai latte powder with cardamom.',                                350.00, 30, 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=400&fit=crop'),
  (4, 7, 'Iced Tea Peach Premix',       'Instant iced tea with real peach flavoring.',                                  180.00, 120, 'https://images.unsplash.com/photo-1556881286-fc6915169721?w=400&h=400&fit=crop'),
  (1, 7, 'Masala Chai Premix',          'Just-add-water masala chai with milk and sugar included.',                     220.00, 150, 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400&h=400&fit=crop'),
  (5, 7, 'Chocolate Matcha Blend',      'Ceremonial matcha blended with Belgian cocoa powder.',                         520.00, 20, 'https://images.unsplash.com/photo-1627435601361-ec25f5b1d0e5?w=400&h=400&fit=crop'),
  (3, 7, 'Iced Chai Concentrate',       'Cold brew chai concentrate for iced chai lattes.',                             260.00, 70, 'https://images.unsplash.com/photo-1597318181409-cf64d0b5d8a2?w=400&h=400&fit=crop'),
  (2, 7, 'Hojicha Latte Powder',        'Roasted Japanese green tea latte mix with subtle caramel.',                    380.00, 35, 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=400&h=400&fit=crop');

-- ── ORDERS (sample) ──
-- These reference user_id values that must exist — will be re-inserted by reseed script
