# CLAUDE.md — ChaiNIEx Project Context for AI Assistants

This file tells Claude (or any AI coding assistant) everything it needs to know to help work on this codebase effectively. Read this before generating any code.

---

## What This Project Is

**ChaiNIEx Supply Chain Management System** — a full-stack web app for managing the supply chain of a tea product business. Vendors supply products, customers place orders, admins manage everything. It is a student DBMS project being taken to production.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | PostgreSQL 16.x |
| Backend | Node.js 20 LTS + Express |
| DB Driver | `pg` (node-postgres) with connection pooling |
| Auth | `jsonwebtoken` + `bcryptjs` |
| Frontend | Plain HTML/JS/CSS (3 self-contained portals) |
| DB Management | pgAdmin 4 |
| Containerization | Docker + docker-compose (planned) |

---

## Project Structure (Current)

```
DBMS/                           ← project root (git repo)
├── db/
│   ├── schema.sql              ✅ All DDL — 7 tables, FKs, indexes (PostgreSQL)
│   └── seed.sql                ✅ Sample data (3 users, 3 suppliers, 10 products, 5 orders)
├── api/
│   ├── package.json            ✅ Node.js dependencies (pg driver)
│   ├── server.js               ✅ Express entry point (port 4000)
│   ├── db.js                   ✅ pg Pool setup
│   ├── middleware/
│   │   ├── auth.js             ✅ JWT verification middleware
│   │   └── validate.js         ✅ Request body validation
│   └── routes/
│       ├── auth.js             ✅ Register + login (bcrypt + JWT)
│       ├── users.js            ✅ Users CRUD
│       ├── suppliers.js        ✅ Suppliers CRUD
│       ├── categories.js       ✅ Categories CRUD
│       ├── products.js         ✅ Products CRUD (with joins)
│       ├── orders.js           ✅ Orders CRUD (transactional placement)
│       └── admin.js            ✅ Admin login + stats
├── frontend/
│   ├── customer/index.html     ✅ Customer shop (browse, cart, orders)
│   ├── supplier/index.html     ✅ Delivery/supplier portal
│   └── admin/index.html        ✅ Admin dashboard (full CRUD)
├── .env                        ✅ Local environment config
├── .env.example                ✅ Template (no secrets)
├── .gitignore                  ✅ node_modules, .env excluded
├── requirements.txt            ✅ Dependency list
├── PLAN.md                     Project phases & milestones
├── ARCHITECTURE.md             System architecture & schema
├── PRD.md                      Product requirements
├── MVP.md                      MVP scope & acceptance criteria
└── CLAUDE.md                   ← you are here
```

---

## Database Rules — Always Follow These

1. **Use parameterized queries everywhere.** Never concatenate user input into SQL strings. PostgreSQL uses `$1, $2, $3` numbered placeholders.
   ```js
   // ✅ correct (PostgreSQL)
   db.query('SELECT * FROM users WHERE email = $1', [email]);
   // ❌ never do this
   db.query(`SELECT * FROM users WHERE email = '${email}'`);
   ```

2. **Wrap order placement in a transaction** using `BEGIN` / `COMMIT` / `ROLLBACK` via a dedicated client from the pool. Use `SELECT ... FOR UPDATE` to lock product rows before decrementing stock.
   ```js
   const client = await db.connect();
   await client.query('BEGIN');
   // ... queries ...
   await client.query('COMMIT');
   client.release();
   ```

3. **Never return `password_hash`** in any API response. Explicitly exclude it in SELECT statements or strip it before responding.

4. **All FK relationships must exist in the schema.** Do not work around them — let PostgreSQL enforce integrity.

5. **Order status values are an implicit enum:** `Pending`, `Processing`, `Shipped`, `Delivered`, `Cancelled`. Validate against this list in the API.

6. **Use `RETURNING` clause** for INSERT statements to get the generated ID back without a separate query.

---

## API Conventions

- Base path: `/api`
- Auth header: `Authorization: Bearer <token>`
- All responses use:
  ```json
  { "success": true, "data": { ... } }
  { "success": false, "error": "message" }
  ```
- HTTP status codes must be meaningful: 200, 201, 400, 401, 403, 404, 409, 500.
- Admin routes live under `/api/admin/*` and require role `admin` in the JWT payload.

---

## PostgreSQL Error Codes (Common)

| Code | Meaning | Where |
|------|---------|-------|
| `23505` | Unique violation (duplicate key) | Registration, supplier email |
| `23503` | Foreign key violation | Deleting supplier/product with references |
| `23502` | NOT NULL violation | Missing required fields |

---

## Auth Flow

- **Users and suppliers:** POST `/api/auth/register` → POST `/api/auth/login` → JWT stored in `localStorage` on frontend.
- **Admins:** Separate POST `/api/admin/login` endpoint. Do not mix admin auth with user auth.
- JWT payload shape:
  ```json
  { "id": 1, "role": "user" | "supplier" | "admin", "iat": ..., "exp": ... }
  ```

---

## pg (node-postgres) Patterns

```js
// Simple query — uses pool directly
const result = await db.query('SELECT * FROM users WHERE user_id = $1', [id]);
const user = result.rows[0];     // single row
const users = result.rows;       // all rows
const count = result.rowCount;   // affected rows (UPDATE/DELETE)

// Transaction — get a dedicated client
const client = await db.connect();
try {
  await client.query('BEGIN');
  // ... multiple queries on same client ...
  await client.query('COMMIT');
} catch (e) {
  await client.query('ROLLBACK');
  throw e;
} finally {
  client.release();
}

// INSERT with RETURNING
const result = await db.query(
  'INSERT INTO products (name, price) VALUES ($1, $2) RETURNING product_id',
  ['Tea', 100]
);
const newId = result.rows[0].product_id;
```

---

## What's In Scope for MVP

See `MVP.md`. Do not add payment processing, email notifications, image uploads, or analytics unless explicitly asked.

---

## Common Tasks & How to Handle Them

### Adding a new API route
1. Create a file in `api/routes/`
2. Register it in `server.js` under `/api/<resource>`
3. Use `auth.js` middleware on protected routes
4. Use `$1, $2` parameterized queries — NOT `?` placeholders

### Changing the schema
1. Edit `db/schema.sql`
2. Write a migration snippet (ALTER TABLE) and note it in a comment at the top of `schema.sql`
3. Re-seed if column types change

### Adding a frontend page
1. Keep it in the correct portal folder (`/customer`, `/supplier`, `/admin`)
2. Use `fetch()` to call the API — no direct DB access from the frontend
3. Handle loading, error, and empty states for every data fetch

---

## Things to Avoid

- Do not use an ORM (Sequelize, Prisma) unless asked — raw `pg` queries are preferred for this DBMS project so SQL is explicit and assessable.
- Do not store JWTs in cookies without `httpOnly` flag — use `localStorage` for now (acceptable for demo scope).
- Do not skip error handling on DB queries. Every `db.query()` call must have a try/catch.
- Do not create endpoints that return all rows of a table without a `LIMIT` clause.
- Do not use `?` placeholders — PostgreSQL uses `$1, $2, $3` numbered params.

---

## Environment Variables (`.env`)

```
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=chainex_db
JWT_SECRET=replace_this_before_production
PORT=4000
```

---

## Key Business Logic Reminders

- **Stock consistency:** `stock_quantity` can never go below 0. Check before decrementing.
- **Price lock:** `order_items.price_at_purchase` is set at order time from `products.price` and must never change after insertion.
- **Cascade deletes:** Deleting a user cascades to their orders and order items. Deleting a supplier or product is blocked (RESTRICT) if orders reference them.

---

## Quick Start (after PostgreSQL is running)

```bash
# 1. Create database (via psql)
psql -U postgres -c "CREATE DATABASE chainex_db;"

# 2. Run schema + seed
psql -U postgres -d chainex_db -f db/schema.sql
psql -U postgres -d chainex_db -f db/seed.sql

# 3. Install API dependencies
cd api && npm install

# 4. Start API server
npm run dev     # or: npm start

# 5. Open frontend in browser
# → frontend/customer/index.html  (Shop)
# → frontend/admin/index.html     (Admin)
# → frontend/supplier/index.html  (Delivery)
```
