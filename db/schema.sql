-- ============================================
-- ChaiNIEx Supply Chain Management System
-- Database Schema (PostgreSQL 16.x)
-- ============================================
-- Migration notes:
--   v1.0 — Initial schema creation
--   v1.1 — Migrated from MySQL to PostgreSQL

-- Drop tables in reverse dependency order (for re-runs)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS admins;
DROP TABLE IF EXISTS users;

-- ── USERS ──
CREATE TABLE users (
    user_id          SERIAL PRIMARY KEY,
    full_name        VARCHAR(100)  NOT NULL,
    email            VARCHAR(100)  NOT NULL UNIQUE,
    password_hash    VARCHAR(255)  NOT NULL,
    shipping_address TEXT,
    created_at       TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ── SUPPLIERS ──
CREATE TABLE suppliers (
    supplier_id    SERIAL PRIMARY KEY,
    company_name   VARCHAR(150) NOT NULL,
    contact_email  VARCHAR(100) NOT NULL UNIQUE,
    phone_number   VARCHAR(20),
    bank_details   VARCHAR(255)
);

-- ── ADMINS ──
CREATE TABLE admins (
    admin_id      SERIAL PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- ── CATEGORIES ──
CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

-- ── PRODUCTS ──
CREATE TABLE products (
    product_id     SERIAL PRIMARY KEY,
    supplier_id    INT            NOT NULL,
    category_id    INT            NOT NULL,
    product_name   VARCHAR(200)   NOT NULL,
    description    TEXT,
    price          DECIMAL(10,2)  NOT NULL,
    stock_quantity INT            NOT NULL DEFAULT 0,
    image_url      VARCHAR(500),
    FOREIGN KEY (supplier_id)  REFERENCES suppliers(supplier_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id)  REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- ── ORDERS ──
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    user_id      INT            NOT NULL,
    order_date   TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2)  NOT NULL,
    status       VARCHAR(50)    NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ── ORDER ITEMS ──
CREATE TABLE order_items (
    order_item_id     SERIAL PRIMARY KEY,
    order_id          INT           NOT NULL,
    product_id        INT           NOT NULL,
    quantity          INT           NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- ── INDEXES ──
CREATE INDEX idx_products_supplier   ON products(supplier_id);
CREATE INDEX idx_products_category   ON products(category_id);
CREATE INDEX idx_orders_user         ON orders(user_id);
CREATE INDEX idx_orders_status       ON orders(status);
CREATE INDEX idx_order_items_order   ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
