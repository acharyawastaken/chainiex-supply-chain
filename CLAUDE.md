# CLAUDE.md — ChaiNIEx Project Context for AI Assistants

This file tells Claude (or any AI coding assistant) everything it needs to know to help work on this codebase effectively. Read this before generating any code.

---

## What This Project Is

**ChaiNIEx Supply Chain Management System** — a full-stack web app for managing the supply chain of a tea product business. Vendors supply products, customers place orders, admins manage everything. It is a student DBMS project being taken to production.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Database | MySQL 8.x (InnoDB engine) |
| Backend | Node.js 20 LTS + Express |
| DB Driver | `mysql2` with connection pooling |
| Auth | `jsonwebtoken` + `bcryptjs` |
| Frontend | Plain HTML/JS/CSS (3 self-contained portals) |
| Containerization | Docker + docker-compose (planned) |
| DB Management | pgAdmin 4 / MySQL Workbench |

---

## Project Structure (Current)

```
DBMS/                           ← project root (git repo)
├── db/
│   ├── schema.sql              ✅ All DDL — 7 tables, FKs, indexes
│   └── seed.sql                ✅ Sample data (3 users, 3 suppliers, 10 products, 5 orders)
├── api/
│   ├── package.json            ✅ Node.js dependencies
│   ├── server.js               ✅ Express entry point (port 4000)
│   ├── db.js                   ✅ mysql2 pool setup
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

## Setup Status

| Component | Status | Notes |
|-----------|--------|-------|
| Schema SQL | ✅ Done | `db/schema.sql` — 7 tables with FK constraints |
| Seed SQL | ✅ Done | `db/seed.sql` — realistic sample data |
| API Routes | ✅ Done | All 7 route files implemented |
| Frontend HTML | ✅ Done | 3 portals moved to `frontend/` |
| Git Repo | ✅ Done | Initialized, `.gitignore` in place |
| MySQL DB | 🔲 Pending | Need to install MySQL + run schema/seed |
| npm install | 🔲 Pending | Run `cd api && npm install` |
| Docker | 🔲 Planned | docker-compose.yml not yet created |

---

## Database Rules — Always Follow These

1. **Use parameterized queries everywhere.** Never concatenate user input into SQL strings.
   ```js
   // ✅ correct
   db.query('SELECT * FROM users WHERE email = ?', [email]);
   // ❌ never do this
   db.query(`SELECT * FROM users WHERE email = '${email}'`);
   ```

2. **Wrap order placement in a transaction** using `START TRANSACTION` / `COMMIT` / `ROLLBACK`. Use `SELECT ... FOR UPDATE` to lock product rows before decrementing stock.

3. **Never return `password_hash`** in any API response. Explicitly exclude it in SELECT statements or strip it before responding.

4. **All FK relationships must exist in the schema.** Do not work around them — let MySQL enforce integrity.

5. **Order status values are an implicit enum:** `Pending`, `Processing`, `Shipped`, `Delivered`, `Cancelled`. Validate against this list in the API.

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

## Auth Flow

- **Users and suppliers:** POST `/api/auth/register` → POST `/api/auth/login` → JWT stored in `localStorage` on frontend.
- **Admins:** Separate POST `/api/admin/login` endpoint. Do not mix admin auth with user auth.
- JWT payload shape:
  ```json
  { "id": 1, "role": "user" | "supplier" | "admin", "iat": ..., "exp": ... }
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

- Do not use an ORM (Sequelize, Prisma) unless asked — raw `mysql2` queries are preferred for this DBMS project so SQL is explicit and assessable.
- Do not store JWTs in cookies without `httpOnly` flag — use `localStorage` for now (acceptable for demo scope).
- Do not skip error handling on DB queries. Every `db.query()` call must have a try/catch or `.catch()`.
- Do not create endpoints that return all rows of a table without a `LIMIT` clause.

---

## Environment Variables (`.env`)

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASS=root
DB_NAME=chainex_db
JWT_SECRET=replace_this_before_production
PORT=4000
```

---

## Key Business Logic Reminders

- **Stock consistency:** `stock_quantity` can never go below 0. Check before decrementing.
- **Price lock:** `order_items.price_at_purchase` is set at order time from `products.price` and must never change after insertion.
- **Cascade deletes:** Deleting a user cascades to their orders and order items. Deleting a supplier or product is blocked if orders reference them.

---

## Quick Start (after MySQL is running)

```bash
# 1. Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS chainex_db;"

# 2. Run schema + seed
mysql -u root -p chainex_db < db/schema.sql
mysql -u root -p chainex_db < db/seed.sql

# 3. Install API dependencies
cd api && npm install

# 4. Start API server
npm run dev     # or: npm start

# 5. Open frontend in browser
# → frontend/customer/index.html  (Shop)
# → frontend/admin/index.html     (Admin)
# → frontend/supplier/index.html  (Delivery)
```
