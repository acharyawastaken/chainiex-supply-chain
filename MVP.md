# ChaiNIEx — MVP Definition

**The MVP is complete when a person can sign up, browse products, place an order, and an admin can manage that order — all backed by a live MySQL database.**

---

## MVP Scope

### ✅ In — Must ship

#### Database
- [ ] `schema.sql` with all 7 tables, FKs, and indexes
- [ ] `seed.sql` with at least: 3 categories, 2 suppliers, 10 products, 3 users, 5 sample orders
- [ ] Stored transaction procedure for placing an order

#### Auth
- [ ] Customer register + login (JWT)
- [ ] Admin login (separate endpoint, `role: "admin"` in token)
- [ ] Protected routes reject unauthenticated requests with 401

#### Customer Portal
- [ ] Product listing page (all products, filterable by category)
- [ ] Product detail page
- [ ] Place order (single or multiple items)
- [ ] Order history page showing status per order
- [ ] Cancel order (Pending status only)

#### Supplier Portal
- [ ] Supplier register + login
- [ ] Add a new product (linked to a category)
- [ ] Edit product price and stock quantity
- [ ] View list of own products

#### Admin Dashboard
- [ ] View all users, suppliers, products, categories, orders
- [ ] Update order status (Pending → Processing → Shipped → Delivered)
- [ ] Create and delete product categories
- [ ] View products with low stock (< 10 units)

#### General
- [ ] All mutations use transactions where data consistency is required
- [ ] API returns proper HTTP status codes and JSON error messages
- [ ] No SQL injection vulnerabilities (parameterized queries throughout)
- [ ] Works in a browser without errors in the JS console

---

### ❌ Out — Deferred to v2

| Feature | Reason Deferred |
|---------|----------------|
| Payment gateway (Razorpay, Stripe) | Requires merchant account & extra scope |
| Email / SMS notifications | External service dependency |
| Product image uploads | File storage out of scope |
| Review & rating system | Post-purchase flow, not core chain |
| Advanced reporting / charts | Nice-to-have, not chain-critical |
| Forgot password / reset flow | Auth edge case |
| Mobile app | Frontend-only, separate project |
| Audit log / change history | Nice DBMS feature, Phase 2 |

---

## Acceptance Criteria (Demo Checklist)

Run through this before calling MVP complete:

### Setup
- [ ] `docker compose up` starts DB, API, and frontend with no manual steps
- [ ] DB is seeded automatically on first run

### Customer Flow
- [ ] Register a new customer account
- [ ] Log in and see the product listing
- [ ] Filter products by category
- [ ] Place an order with 2 different products
- [ ] Confirm `stock_quantity` decremented correctly in the DB
- [ ] View the order in order history with status `Pending`
- [ ] Cancel the order; confirm `stock_quantity` restored

### Supplier Flow
- [ ] Register as a new supplier
- [ ] Add a product with price and stock
- [ ] Edit the product's price; confirm existing `price_at_purchase` on old orders is unaffected

### Admin Flow
- [ ] Log in as admin
- [ ] View the order placed above
- [ ] Advance status from `Pending` to `Shipped`
- [ ] Customer sees updated status in their order history
- [ ] Add a new category; confirm it appears in the product form
- [ ] View the low-stock dashboard; confirm products with qty < 10 appear

### Data Integrity
- [ ] Attempt to place an order exceeding available stock → error returned, order NOT created
- [ ] Attempt to delete a category that has products → error returned, category NOT deleted
- [ ] Confirm no `password_hash` appears in any API JSON response

---

## File Deliverables for MVP

```
chainex/
├── db/
│   ├── schema.sql        ✅ required
│   └── seed.sql          ✅ required
├── api/
│   ├── server.js         ✅ required
│   ├── db.js             ✅ required
│   └── routes/           ✅ all 7 route files
├── frontend/             ✅ all 3 portals working
├── docker-compose.yml    ✅ required
├── .env.example          ✅ required (no real secrets)
└── README.md             ✅ setup instructions
```

---

## Definition of Done

A feature is "done" when:
1. The database layer works (query verified in MySQL Workbench)
2. The API endpoint returns correct data (verified in Postman)
3. The frontend displays it correctly (verified in browser)
4. An error case is handled gracefully (bad input → clear error message)
