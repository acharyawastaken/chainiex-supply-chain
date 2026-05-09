# ChaiNIEx Supply Chain Management System — Project Plan

**Batch:** C1  
**Team:** Sameera Acharya (4NI24IS169) · Samarth L (4NI24IS167)  
**Track:** DBMS / Supply Chain & Logistics  
**Status:** Moving to Production

---

## Goals

1. Ship a working, database-backed web application for ChaiNIEx's supply chain operations.
2. Demonstrate core DBMS concepts (normalization, referential integrity, transactions) in a real product.
3. Deliver a clean frontend that vendors, customers, and admins can actually use.

---

## Phases

### Phase 0 — Foundation (Week 1)
- [ ] Finalize and lock schema (see `ARCHITECTURE.md`)
- [ ] Set up local PostgreSQL instance and run initial migrations
- [ ] Configure version control (Git repo, branching strategy)
- [ ] Agree on coding standards and folder structure (see `CLAUDE.md`)

### Phase 1 — Core Database (Week 1–2)
- [ ] Write and test all DDL scripts (`schema.sql`)
- [ ] Seed database with realistic sample data (`seed.sql`)
- [ ] Validate all foreign key constraints and cascades
- [ ] Write stored procedures for critical operations (place order, update stock)

### Phase 2 — Backend API (Week 2–3)
- [ ] Set up Node.js + Express (or Python + FastAPI) REST API
- [ ] Implement JDBC/ODBC connection pooling
- [ ] Build endpoints for each entity (Users, Suppliers, Products, Orders, Order Items, Categories, Admins)
- [ ] Add authentication (JWT for users, separate admin session)
- [ ] Input validation and error handling middleware

### Phase 3 — Frontend (Week 3–4)
- [ ] Customer portal: browse products, place orders, view order history
- [ ] Supplier portal: manage products, view purchase orders
- [ ] Admin dashboard: manage all entities, view reports
- [ ] Responsive layout (desktop + mobile)

### Phase 4 — Integration & Testing (Week 4–5)
- [ ] End-to-end testing of order placement flow
- [ ] Transaction rollback testing (payment failure scenarios)
- [ ] Concurrent order stress test (stock_quantity race condition)
- [ ] SQL query performance checks (add indexes where needed)

### Phase 5 — Deployment (Week 5–6)
- [ ] Containerize with Docker (PostgreSQL + API + frontend)
- [ ] Deploy on a cloud VM or Railway/Render (free tier acceptable for demo)
- [ ] Set up automated DB backups
- [ ] Final documentation and demo prep

---

## Milestones

| Milestone | Target | Owner |
|-----------|--------|-------|
| Schema locked & migrations passing | End of Week 1 | Both |
| All CRUD endpoints tested via Postman | End of Week 2 | Samarth |
| Customer order flow working end-to-end | End of Week 3 | Sameera |
| Admin dashboard live | End of Week 4 | Both |
| Production deployment live | End of Week 5 | Both |
| Final demo-ready build | End of Week 6 | Both |

---

## Risks & Mitigations

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Stock race conditions on concurrent orders | Medium | Use `SELECT ... FOR UPDATE` transactions |
| Schema changes mid-development | Low | Lock schema in Phase 0; use migration files |
| Scope creep (payments, analytics) | Medium | Defer to post-MVP; see `MVP.md` |
| PostgreSQL version incompatibility | Low | Pin PostgreSQL 16.x in Docker |

---

## Team Split

| Area | Primary | Support |
|------|---------|---------|
| Database design & SQL | Samarth | Sameera |
| Backend API | Sameera | Samarth |
| Frontend (Customer + Supplier) | Sameera | Samarth |
| Admin dashboard | Samarth | Sameera |
| Testing & deployment | Both | — |
