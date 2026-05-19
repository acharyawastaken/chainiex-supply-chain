-- ============================================
-- ChaiNIEx â€” Seed Data (PostgreSQL)
-- Run after schema.sql to populate dev database
-- ============================================

-- â”€â”€ ADMINS â”€â”€
-- Password: admin123 (bcrypt hash, cost 12)
INSERT INTO admins (username, email, password_hash) VALUES
  ('acharya',  'acharya@chainex.com', '$2a$12$Bng3GOllevQeW.cKACYvQOCMx8M4XKWv0laNhKl4Y1NL4oqyV4L0.'),
  ('samarth',  'samarth@chainex.com', '$2a$12$Bng3GOllevQeW.cKACYvQOCMx8M4XKWv0laNhKl4Y1NL4oqyV4L0.');

-- â”€â”€ SUPPLIERS (FMCG / Grocery Brands) â”€â”€
INSERT INTO suppliers (company_name, contact_email, phone_number, bank_details) VALUES
  ('Amul India Pvt Ltd',       'supply@amul.coop',        '+91 9876543210', 'HDFC/1234567890/IFSC001'),
  ('ITC Foods Ltd',            'trade@itcfoods.in',       '+91 9876500001', 'SBI/9876543210/IFSC002'),
  ('Hindustan Unilever Ltd',   'vendor@hul.co.in',        '+91 9876500002', 'ICICI/5678901234/IFSC003'),
  ('Nestle India Pvt Ltd',     'ops@nestle.in',           '+91 9876500003', 'AXIS/1122334455/IFSC004'),
  ('P&G India Ltd',            'supply@pg-india.com',     '+91 9876500004', 'BOB/6677889900/IFSC005');

-- â”€â”€ CATEGORIES (Grocery / Quick-Commerce Aisles) â”€â”€
INSERT INTO categories (category_name) VALUES
  ('Fruits & Vegetables'),
  ('Dairy & Breakfast'),
  ('Snacks & Beverages'),
  ('Staples & Cooking Essentials'),
  ('Personal Care'),
  ('Household & Cleaning'),
  ('Baby & Pet Care');

-- â”€â”€ USERS â”€â”€
-- Password: user123 (bcrypt hash, cost 12)
INSERT INTO users (full_name, email, password_hash, shipping_address) VALUES
  ('Samarth Rao',         'samarth_user@chainex.com',  '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '42 MG Road, Mysuru 570001'),
  ('Rohit Kumar',        'rohit@chainex.com',         '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '15 Jayanagar, Bengaluru 560041'),
  ('Tanishq Sharma',     'tanishq@chainex.com',       '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '8 Kuvempunagar, Mysuru 570023'),
  ('Samarth L',          'samarth_l@chainex.com',     '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '12 Hebbal, Mysuru 570017'),
  ('Sameera Acharya',    'sameera@chainex.com',       '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '25 Gokulam, Mysuru 570002'),
  ('Tanishq Jain',       'tanishq_jain@chainex.com',  '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '33 Vijayanagar, Mysuru 570030'),
  ('Shankarshan Thakur', 'shankarshan@chainex.com',   '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '55 Saraswathipuram, Mysuru 570009'),
  ('Sammy',              'sammy@chainex.com',         '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '77 Kuvempunagar, Mysuru 570023'),
  ('Acharya',            'acharya_user@chainex.com',  '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '10 NIE Campus, Mysuru 570008'),
  ('Raj',                'raj@chainex.com',           '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '90 MG Road, Bengaluru 560001'),
  ('Ramu',               'ramu@chainex.com',          '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '123 JP Nagar, Bengaluru 560078'),
  ('Sohan',              'sohan@chainex.com',         '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '45 Whitefield, Bengaluru 560066'),
  ('Adithya',            'adithya@chainex.com',       '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '56 Jayanagar, Bengaluru 560041'),
  ('Aditi',              'aditi@chainex.com',         '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '18 Indiranagar, Bengaluru 560038'),
  ('Spoorthi',           'spoorthi@chainex.com',      '$2a$12$Ux5.3mNVAqUiHw8rgc/PeOiAq0N1Oog9wB0kdTCpD/HZgFTYVvvdK', '67 Koramangala, Bengaluru 560095');

-- â”€â”€ PRODUCTS (75 items â€” Quick-Commerce Grocery) â”€â”€
INSERT INTO products (supplier_id, category_id, product_name, description, price, stock_quantity, image_url) VALUES
  -- â•â•â• FRUITS & VEGETABLES (1-12) â•â•â•
  (1, 1, 'Fresh Bananas (1 dozen)',       'Ripe yellow bananas, rich in potassium. Perfect for smoothies and snacking.',   45.00, 300, 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop'),
  (2, 1, 'Organic Tomatoes (500g)',       'Farm-fresh organic tomatoes for curries, salads, and sauces.',                  35.00, 250, 'https://images.unsplash.com/photo-1546470427-0d4db154ceb8?w=400&h=400&fit=crop'),
  (1, 1, 'Fresh Spinach Bundle',          'Tender baby spinach leaves, washed and ready to cook. Rich in iron.',           30.00, 200, 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&h=400&fit=crop'),
  (3, 1, 'Onions (1 kg)',                 'Premium quality onions for everyday Indian cooking.',                           40.00, 400, 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400&h=400&fit=crop'),
  (2, 1, 'Potatoes (1 kg)',               'Fresh farm potatoes ideal for frying, boiling, and curries.',                   35.00, 350, 'https://images.unsplash.com/photo-1518977676601-b53f82ber40?w=400&h=400&fit=crop'),
  (1, 1, 'Green Capsicum (250g)',         'Crunchy green bell peppers for stir-fry and salads.',                           25.00, 180, 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400&h=400&fit=crop'),
  (4, 1, 'Fresh Coriander Bunch',         'Aromatic fresh coriander leaves for garnishing and chutneys.',                  15.00, 500, 'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5?w=400&h=400&fit=crop'),
  (3, 1, 'Carrots (500g)',                'Sweet and crunchy orange carrots. Great for juicing and cooking.',              40.00, 220, 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&h=400&fit=crop'),
  (5, 1, 'Shimla Apple (1 kg)',           'Crisp Himachali apples with a perfect sweet-tart balance.',                    180.00, 120, 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop'),
  (2, 1, 'Cucumber (500g)',               'Cool and hydrating cucumbers for salads and raita.',                            25.00, 280, 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=400&h=400&fit=crop'),
  (1, 1, 'Lemon (250g)',                  'Juicy fresh lemons for lemonade, cooking, and garnishing.',                     20.00, 350, 'https://images.unsplash.com/photo-1590502593747-42a996133562?w=400&h=400&fit=crop'),
  (4, 1, 'Green Chillies (100g)',         'Spicy green chillies for tadka and masala preparations.',                       10.00, 600, 'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?w=400&h=400&fit=crop'),

  -- â•â•â• DAIRY & BREAKFAST (13-24) â•â•â•
  (1, 2, 'Amul Toned Milk (1L)',          'Fresh pasteurized toned milk. 3% fat content. Daily essential.',                32.00, 500, 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop'),
  (1, 2, 'Amul Butter (500g)',            'Creamy salted butter made from fresh cream. Perfect for paranthas.',           270.00, 150, 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400&h=400&fit=crop'),
  (4, 2, 'Nestle Milk (1L Tetra Pack)',   'UHT processed full cream milk. Long shelf life, rich taste.',                   72.00, 200, 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop'),
  (1, 2, 'Amul Cheese Slices (10 pack)',  'Processed cheese slices for sandwiches and burgers.',                          155.00, 180, 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop'),
  (2, 2, 'Aashirvaad Atta (5 kg)',        'Whole wheat flour for soft, fluffy rotis. 100% whole wheat.',                  295.00, 100, 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=400&fit=crop'),
  (1, 2, 'Amul Paneer (200g)',            'Fresh cottage cheese block. High protein, soft texture.',                      100.00, 200, 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=400&h=400&fit=crop'),
  (4, 2, 'Nescafe Classic Coffee (100g)', 'Instant coffee powder with rich aroma and bold taste.',                        250.00, 160, 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400&h=400&fit=crop'),
  (1, 2, 'Amul Curd (400g)',              'Thick, creamy set curd made from pasteurized milk.',                            35.00, 300, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop'),
  (2, 2, 'Britannia Bread (400g)',        'Fresh white sandwich bread. Soft and perfect for toast.',                       45.00, 250, 'https://images.unsplash.com/photo-1549931319-a545753467c8?w=400&h=400&fit=crop'),
  (1, 2, 'Amul Fresh Cream (250ml)',      'Rich cooking cream for gravies, desserts, and pasta sauces.',                   75.00, 180, 'https://images.unsplash.com/photo-1615478503562-ec2d8aa0a24d?w=400&h=400&fit=crop'),
  (4, 2, 'Nestle Everyday Dairy (1L)',    'Whitener for tea and coffee. Rich and creamy taste.',                           180.00, 120, 'https://images.unsplash.com/photo-1634141510639-d691d86f47be?w=400&h=400&fit=crop'),
  (2, 2, 'Eggs (12 pack)',                'Farm-fresh brown eggs. High protein, FSSAI certified.',                         85.00, 400, 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400&h=400&fit=crop'),

  -- â•â•â• SNACKS & BEVERAGES (25-36) â•â•â•
  (2, 3, 'Lays Classic Salted (52g)',     'Crunchy potato chips with classic salt flavor. Party snack.',                    20.00, 500, 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&h=400&fit=crop'),
  (2, 3, 'Bingo Mad Angles (66g)',        'Tangy tomato flavored triangle chips. Crunchy and spicy.',                       20.00, 400, 'https://images.unsplash.com/photo-1621447504864-d8686e12698c?w=400&h=400&fit=crop'),
  (4, 3, 'Maggi 2-Minute Noodles (4pk)',  'Instant masala noodles. India''s favorite 2-minute snack.',                      56.00, 600, 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=400&h=400&fit=crop'),
  (3, 3, 'Coca-Cola (750ml)',             'Chilled classic Coca-Cola. Refreshing carbonated beverage.',                     40.00, 350, 'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400&h=400&fit=crop'),
  (4, 3, 'Nescafe Cold Coffee (200ml)',   'Ready-to-drink cold coffee with creamy milk and sugar.',                         45.00, 250, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=400&fit=crop'),
  (2, 3, 'Dark Fantasy Choco (300g)',     'Premium chocolate-filled cookies. Rich and indulgent.',                         120.00, 200, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=400&fit=crop'),
  (2, 3, 'Haldiram Bhujia (400g)',        'Classic Bikaneri bhujia namkeen. Crispy and spicy.',                             95.00, 300, 'https://images.unsplash.com/photo-1601050690117-94f5f6fa8bd7?w=400&h=400&fit=crop'),
  (3, 3, 'Sprite (750ml)',                'Clear lemon-lime carbonated drink. Crisp and refreshing.',                       40.00, 320, 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=400&h=400&fit=crop'),
  (2, 3, 'Oreo Biscuits (300g)',          'Chocolate sandwich cookies with vanilla cream filling.',                         50.00, 350, 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=400&h=400&fit=crop'),
  (4, 3, 'KitKat (37.3g x 6 pack)',      'Crispy wafer fingers covered in smooth milk chocolate.',                        200.00, 180, 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=400&h=400&fit=crop'),
  (2, 3, 'Real Fruit Juice Mango (1L)',   '100% fruit juice from Alphonso mangoes. No added sugar.',                      110.00, 150, 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400&h=400&fit=crop'),
  (1, 3, 'Amul Lassi Mango (200ml)',      'Thick mango-flavored lassi. Chilled and refreshing.',                            25.00, 400, 'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=400&h=400&fit=crop'),

  -- â•â•â• STAPLES & COOKING ESSENTIALS (37-48) â•â•â•
  (2, 4, 'Fortune Sunflower Oil (1L)',    'Refined sunflower cooking oil. Light and heart-healthy.',                       155.00, 200, 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop'),
  (2, 4, 'Tata Salt (1 kg)',              'Vacuum-evaporated iodized salt. India''s trusted brand.',                        28.00, 500, 'https://images.unsplash.com/photo-1518110925495-5fe2c8f2be4a?w=400&h=400&fit=crop'),
  (2, 4, 'Tata Sampann Turmeric (100g)', 'Pure unpolished turmeric powder. Rich in curcumin.',                             42.00, 300, 'https://images.unsplash.com/photo-1615485500704-8e990f9900f7?w=400&h=400&fit=crop'),
  (3, 4, 'Kissan Tomato Ketchup (500g)',  'Thick tomato ketchup made with real tomatoes.',                                 110.00, 250, 'https://images.unsplash.com/photo-1472476443507-c7a5948772fc?w=400&h=400&fit=crop'),
  (1, 4, 'India Gate Basmati Rice (5kg)', 'Premium aged basmati rice. Long grain, aromatic.',                              550.00, 80, 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop'),
  (2, 4, 'Toor Dal (1 kg)',               'Unpolished arhar/toor dal. High protein lentils for dal.',                     140.00, 180, 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=400&fit=crop'),
  (2, 4, 'Sugar (1 kg)',                  'Refined white sugar crystals for cooking and beverages.',                        48.00, 400, 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400&h=400&fit=crop'),
  (2, 4, 'MDH Garam Masala (100g)',       'Aromatic blend of 12 spices for authentic Indian cooking.',                      75.00, 250, 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400&h=400&fit=crop'),
  (2, 4, 'Red Chilli Powder (100g)',      'Pure Kashmiri red chilli powder for vibrant color and mild heat.',               40.00, 300, 'https://images.unsplash.com/photo-1599909533601-1294bb0be01e?w=400&h=400&fit=crop'),
  (3, 4, 'Saffola Gold Oil (1L)',         'Blended edible oil with PUFA and MUFA balance.',                               190.00, 150, 'https://images.unsplash.com/photo-1620574387735-3624d75b2dbc?w=400&h=400&fit=crop'),
  (4, 4, 'Maggi Hot & Sweet Sauce',       'Tomato chilli sauce. Tangy, sweet, and spicy dip.',                              99.00, 220, 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=400&fit=crop'),
  (2, 4, 'Poha (Flattened Rice) 500g',   'Thin flattened rice flakes for quick poha and chivda.',                          45.00, 280, 'https://images.unsplash.com/photo-1567337710282-00832b415979?w=400&h=400&fit=crop'),

  -- â•â•â• PERSONAL CARE (49-60) â•â•â•
  (3, 5, 'Dove Soap Bar (100g)',          'Moisturizing beauty bar with 1/4 moisturizing cream.',                           55.00, 350, 'https://images.unsplash.com/photo-1600857062241-98e5dba7f214?w=400&h=400&fit=crop'),
  (3, 5, 'Surf Excel Liquid (1L)',        'Liquid detergent for tough stain removal on clothes.',                          225.00, 120, 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?w=400&h=400&fit=crop'),
  (5, 5, 'Colgate MaxFresh (150g)',       'Cooling crystals toothpaste for fresh breath all day.',                          95.00, 280, 'https://images.unsplash.com/photo-1628359355624-855775b5c9c4?w=400&h=400&fit=crop'),
  (3, 5, 'Clinic Plus Shampoo (340ml)',   'Strong and long hair shampoo with milk proteins.',                              180.00, 200, 'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?w=400&h=400&fit=crop'),
  (5, 5, 'Gillette Guard Razor (3 pack)','Comfortable close shave with safety guard technology.',                          85.00, 150, 'https://images.unsplash.com/photo-1585751119414-ef2636f8aede?w=400&h=400&fit=crop'),
  (3, 5, 'Vaseline Body Lotion (200ml)', 'Deep moisture body lotion for dry skin. Non-greasy.',                           175.00, 180, 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=400&h=400&fit=crop'),
  (5, 5, 'Whisper Ultra (8 pads)',        'Ultra-thin sanitary pads with wings for comfort.',                              85.00, 300, 'https://images.unsplash.com/photo-1585914924626-15adac1e6402?w=400&h=400&fit=crop'),
  (3, 5, 'Lux Soft Touch Soap (3 pack)', 'French rose and almond oil beauty soap bar.',                                   120.00, 250, 'https://images.unsplash.com/photo-1607006344380-b6775a0824a7?w=400&h=400&fit=crop'),
  (5, 5, 'Head & Shoulders (340ml)',      'Anti-dandruff shampoo for clean and flake-free hair.',                          340.00, 100, 'https://images.unsplash.com/photo-1585232004423-244e0e6904e3?w=400&h=400&fit=crop'),
  (5, 5, 'Old Spice Deodorant (150ml)',  'Long-lasting freshness deo spray for men. Bold fragrance.',                     220.00, 140, 'https://images.unsplash.com/photo-1594035900144-17fc12690e01?w=400&h=400&fit=crop'),
  (3, 5, 'Pears Soap (125g)',             'Gentle glycerin soap with natural oils. Pure and mild.',                         65.00, 320, 'https://images.unsplash.com/photo-1600857062241-98e5dba7f214?w=400&h=400&fit=crop'),
  (3, 5, 'Sunsilk Shampoo (340ml)',      'Smooth and manageable hair shampoo with keratin.',                              190.00, 160, 'https://images.unsplash.com/photo-1631729371254-42c2892f0e6e?w=400&h=400&fit=crop'),

  -- â•â•â• HOUSEHOLD & CLEANING (61-69) â•â•â•
  (3, 6, 'Vim Dishwash Gel (500ml)',      'Lemon-scented dishwash liquid. Cuts through tough grease.',                      99.00, 250, 'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?w=400&h=400&fit=crop'),
  (3, 6, 'Domex Floor Cleaner (1L)',      'Thick disinfectant floor cleaner. Kills 99.9% germs.',                         125.00, 180, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400&h=400&fit=crop'),
  (3, 6, 'Harpic Toilet Cleaner (500ml)','Power plus 10x cleaning. Removes tough stains.',                               105.00, 200, 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&h=400&fit=crop'),
  (5, 6, 'Scotch-Brite Scrub Pad (3pk)', 'Non-scratch scrub pads for utensils and surfaces.',                              40.00, 400, 'https://images.unsplash.com/photo-1528740561666-dc2479dc08ab?w=400&h=400&fit=crop'),
  (3, 6, 'Comfort Fabric Softener (1L)', 'After-wash fabric conditioner for soft, fragrant clothes.',                     165.00, 130, 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?w=400&h=400&fit=crop'),
  (5, 6, 'Garbage Bags (30 pcs)',         'Large size biodegradable garbage bags. Leak-proof.',                              60.00, 350, 'https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?w=400&h=400&fit=crop'),
  (3, 6, 'Lizol Surface Cleaner (500ml)','Multi-surface disinfectant. Pine fragrance.',                                   110.00, 170, 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400&h=400&fit=crop'),
  (5, 6, 'Colin Glass Cleaner (500ml)',   'Streak-free shine for glass, mirrors, and windows.',                             85.00, 200, 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&h=400&fit=crop'),
  (3, 6, 'Surf Excel Bar (250g x 4)',    'Detergent soap bars for hand wash laundry.',                                     80.00, 300, 'https://images.unsplash.com/photo-1610557892470-55d9e80c0bce?w=400&h=400&fit=crop'),

  -- â•â•â• BABY & PET CARE (70-75) â•â•â•
  (4, 7, 'Cerelac Baby Food (300g)',      'Wheat-apple stage 1 baby cereal. Fortified with iron.',                         260.00, 100, 'https://images.unsplash.com/photo-1604069786749-0bbe4869a6f1?w=400&h=400&fit=crop'),
  (5, 7, 'Pampers Diapers (M, 20 pcs)',  'Medium size baby diapers with 12-hour absorption.',                             450.00, 80, 'https://images.unsplash.com/photo-1590244263702-276b6660e7b4?w=400&h=400&fit=crop'),
  (3, 7, 'Johnson Baby Shampoo (200ml)', 'No-more-tears gentle baby shampoo. Tear-free formula.',                         180.00, 120, 'https://images.unsplash.com/photo-1596464716127-f2a82984de30?w=400&h=400&fit=crop'),
  (4, 7, 'Lactogen Stage 1 (400g)',       'Infant formula milk powder for 0-6 months babies.',                             480.00, 60, 'https://images.unsplash.com/photo-1604069786749-0bbe4869a6f1?w=400&h=400&fit=crop'),
  (5, 7, 'Pedigree Dog Food (1.2kg)',     'Complete adult dog food. Chicken and vegetables flavor.',                       320.00, 90, 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=400&h=400&fit=crop'),
  (4, 7, 'Whiskas Cat Food (480g)',       'Tuna-flavored cat food pouches. Balanced nutrition.',                           250.00, 110, 'https://images.unsplash.com/photo-1615497001839-b0a0eac3274c?w=400&h=400&fit=crop');

-- ORDERS (sample)
-- These reference user_id values that must exist

