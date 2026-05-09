# ChaiNIEx — System Architecture

## Overview

Three-tier architecture: a React/HTML frontend, a Node.js REST API, and a MySQL 8.x database. All three are containerized and deployable as a single `docker compose up`.

```
┌──────────────────────────────────────────────────────┐
│                    CLIENT LAYER                       │
│   Browser (React SPA or plain HTML/JS)               │
│   Roles: Customer · Supplier · Admin                 │
└────────────────────┬─────────────────────────────────┘
                     │ HTTPS / REST
┌────────────────────▼─────────────────────────────────┐
│                    API LAYER                          │
│   Node.js + Express                                  │
│   Auth: JWT (users/suppliers) + Session (admins)     │
│   Middleware: validation · error handling · logging  │
└────────────────────┬─────────────────────────────────┘
                     │ mysql2 connection pool
┌────────────────────▼─────────────────────────────────┐
│                  DATABASE LAYER                       │
│   MySQL 8.x                                          │
│   Engine: InnoDB (FK enforcement + transactions)     │
└──────────────────────────────────────────────────────┘
```

---

## Database Schema

### Entity-Relationship Summary

```
Users ──(places)──► Orders ──(contains)──► Order_Items ──(includes)──► Products
                                                                            │
Suppliers ──(supplied_by)──────────────────────────────────────────────────┘
                                                                            │
Categories ──(in_category)─────────────────────────────────────────────────┘

Admins ──(manages)──► Categories
```

### Table Definitions (MySQL DDL)

```sql
CREATE TABLE users (
    user_id          INT PRIMARY KEY AUTO_INCREMENT,
    full_name        VARCHAR(100)  NOT NULL,
    email            VARCHAR(100)  NOT NULL UNIQUE,
    password_hash    VARCHAR(255)  NOT NULL,
    shipping_address TEXT,
    created_at       DATETIME      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE suppliers (
    supplier_id    INT PRIMARY KEY AUTO_INCREMENT,
    company_name   VARCHAR(150) NOT NULL,
    contact_email  VARCHAR(100) NOT NULL UNIQUE,
    phone_number   VARCHAR(20),
    bank_details   VARCHAR(255)
);

CREATE TABLE admins (
    admin_id      INT PRIMARY KEY AUTO_INCREMENT,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id     INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id    INT            NOT NULL,
    category_id    INT            NOT NULL,
    product_name   VARCHAR(200)   NOT NULL,
    description    TEXT,
    price          DECIMAL(10,2)  NOT NULL,
    stock_quantity INT            NOT NULL DEFAULT 0,
    FOREIGN KEY (supplier_id)  REFERENCES suppliers(supplier_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id)  REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id     INT PRIMARY KEY AUTO_INCREMENT,
    user_id      INT            NOT NULL,
    order_date   DATETIME       DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2)  NOT NULL,
    status       VARCHAR(50)    NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    order_item_id     INT PRIMARY KEY AUTO_INCREMENT,
    order_id          INT           NOT NULL,
    product_id        INT           NOT NULL,
    quantity          INT           NOT NULL,
    price_at_purchase DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES orders(order_id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);
```

### Indexes

```sql
CREATE INDEX idx_products_supplier  ON products(supplier_id);
CREATE INDEX idx_products_category  ON products(category_id);
CREATE INDEX idx_orders_user        ON orders(user_id);
CREATE INDEX idx_order_items_order  ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
```

### Order Placement Transaction

All order writes happen inside a single transaction to prevent stock inconsistency:

```sql
START TRANSACTION;
  -- 1. Lock the product rows being purchased
  SELECT stock_quantity FROM products WHERE product_id = ? FOR UPDATE;
  -- 2. Verify sufficient stock, else ROLLBACK
  -- 3. Insert into orders
  INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'Pending');
  -- 4. Insert each order_item
  INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES ...;
  -- 5. Decrement stock
  UPDATE products SET stock_quantity = stock_quantity - ? WHERE product_id = ?;
COMMIT;
```

---

## API Layer

**Base URL:** `http://localhost:4000/api`

| Resource | Endpoint | Methods |
|----------|----------|---------|
| Auth | `/auth/register` `/auth/login` `/auth/logout` | POST |
| Users | `/users/:id` | GET PATCH DELETE |
| Suppliers | `/suppliers` `/suppliers/:id` | GET POST PATCH DELETE |
| Categories | `/categories` `/categories/:id` | GET POST PATCH DELETE |
| Products | `/products` `/products/:id` | GET POST PATCH DELETE |
| Orders | `/orders` `/orders/:id` | GET POST PATCH |
| Order Items | `/orders/:id/items` | GET |
| Admin | `/admin/*` | (all above + reports) |

Authentication middleware checks JWT on all protected routes. Admin routes require an `admin` role claim.

---

## Frontend Structure

```
/frontend
  /customer       → product listing, cart, order history
  /supplier       → product management, order visibility
  /admin          → full CRUD on all entities, dashboards
  /shared         → navbar, auth forms, common components
```

---

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Database | MySQL | 8.x |
| ORM / Driver | mysql2 (Node.js) | latest |
| Backend | Node.js + Express | 20 LTS |
| Auth | jsonwebtoken + bcrypt | latest |
| Frontend | React (Vite) or plain HTML+JS | — |
| Containerization | Docker + docker-compose | latest |
| Dev Tools | MySQL Workbench, Postman | — |

---

## Deployment (docker-compose)

```yaml
services:
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: chainex_db
    volumes:
      - ./db/schema.sql:/docker-entrypoint-initdb.d/01_schema.sql
      - ./db/seed.sql:/docker-entrypoint-initdb.d/02_seed.sql
    ports: ["3306:3306"]

  api:
    build: ./api
    environment:
      DB_HOST: db
      DB_USER: root
      DB_PASS: root
      DB_NAME: chainex_db
      JWT_SECRET: changeme
    ports: ["4000:4000"]
    depends_on: [db]

  frontend:
    build: ./frontend
    ports: ["3000:3000"]
    depends_on: [api]
```

---

## Security Considerations

- All passwords stored as bcrypt hashes (cost factor 12)
- JWT expiry: 24h (users), 8h (admins)
- SQL queries use parameterized statements — no string concatenation
- `bank_details` in Suppliers should be encrypted at rest (AES-256) before production
- HTTPS enforced in production via reverse proxy (nginx)
