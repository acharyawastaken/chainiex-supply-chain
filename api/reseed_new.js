// Reseed script — adds image_url column and reseeds with 75 products
const db = require('./db');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

async function reseed() {
  const client = await db.connect();
  try {
    console.log('=== ChaiNIEx Full Reseed ===\n');

    // 1. Add image_url column if it doesn't exist
    console.log('1. Adding image_url column...');
    await client.query(`ALTER TABLE products ADD COLUMN IF NOT EXISTS image_url VARCHAR(500)`);
    console.log('   ✅ Column ready');

    // 2. Drop all data in dependency order
    console.log('2. Clearing data...');
    await client.query('DELETE FROM order_items');
    await client.query('DELETE FROM orders');
    await client.query('DELETE FROM products');
    await client.query('DELETE FROM categories');
    await client.query('DELETE FROM suppliers');
    await client.query('DELETE FROM users');
    await client.query('DELETE FROM admins');
    console.log('   ✅ All tables cleared');

    // 3. Reset sequences
    console.log('3. Resetting sequences...');
    await client.query(`ALTER SEQUENCE admins_admin_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE suppliers_supplier_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE categories_category_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE users_user_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE products_product_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE orders_order_id_seq RESTART WITH 1`);
    await client.query(`ALTER SEQUENCE order_items_order_item_id_seq RESTART WITH 1`);
    console.log('   ✅ Sequences reset');

    // 4. Run seed.sql as a single transaction
    console.log('4. Running seed.sql...');
    const seedSql = fs.readFileSync(path.join(__dirname, '..', 'db', 'seed.sql'), 'utf8');
    await client.query(seedSql);
    console.log('   ✅ Seed data inserted');

    // 5. Verify
    const admins = await client.query('SELECT count(*) FROM admins');
    const users = await client.query('SELECT count(*) FROM users');
    const products = await client.query('SELECT count(*) FROM products');
    const categories = await client.query('SELECT count(*) FROM categories');
    const suppliers = await client.query('SELECT count(*) FROM suppliers');
    const withImages = await client.query('SELECT count(*) FROM products WHERE image_url IS NOT NULL');

    console.log(`\n=== Verification ===`);
    console.log(`   Admins:     ${admins.rows[0].count}`);
    console.log(`   Users:      ${users.rows[0].count}`);
    console.log(`   Suppliers:  ${suppliers.rows[0].count}`);
    console.log(`   Categories: ${categories.rows[0].count}`);
    console.log(`   Products:   ${products.rows[0].count}`);
    console.log(`   With Images: ${withImages.rows[0].count}`);

    // 6. Test login
    const adminHash = await client.query('SELECT password_hash FROM admins WHERE username=$1', ['acharya']);
    const adminOk = await bcrypt.compare('admin123', adminHash.rows[0].password_hash);
    const userHash = await client.query('SELECT password_hash FROM users WHERE email=$1', ['samarth_user@example.com']);
    const userOk = await bcrypt.compare('user123', userHash.rows[0].password_hash);

    console.log(`\n=== Login Tests ===`);
    console.log(`   Admin (acharya/admin123): ${adminOk ? '✅' : '❌'}`);
    console.log(`   User (samarth_user/user123): ${userOk ? '✅' : '❌'}`);

    // 7. Insert sample orders
    console.log('\n5. Inserting sample orders...');
    const orderRes = await client.query(
      `INSERT INTO orders (user_id, order_date, total_amount, status) VALUES
      (1, '2025-05-08 10:30:00', 840.00, 'Pending'),
      (2, '2025-05-08 09:15:00', 320.00, 'Shipped'),
      (3, '2025-05-07 14:00:00', 1200.00, 'Delivered'),
      (1, '2025-05-07 11:00:00', 560.00, 'Processing'),
      (2, '2025-05-06 16:20:00', 480.00, 'Cancelled')
      RETURNING order_id`
    );
    const oids = orderRes.rows.map(r => r.order_id);
    await client.query(
      `INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES
      ($1, 1, 3, 220.00),
      ($2, 2, 1, 180.00),
      ($2, 25, 1, 240.00),
      ($3, 37, 2, 420.00),
      ($3, 47, 1, 520.00),
      ($4, 56, 3, 160.00),
      ($4, 26, 1, 140.00),
      ($5, 26, 2, 140.00)`,
      [oids[0], oids[1], oids[2], oids[3], oids[4]]
    );
    console.log('   ✅ Sample orders created');

    console.log('\n🎉 Full reseed complete!\n');
    client.release();
    process.exit(0);
  } catch (err) {
    client.release();
    console.error('❌ Reseed failed:', err.message);
    process.exit(1);
  }
}

reseed();
