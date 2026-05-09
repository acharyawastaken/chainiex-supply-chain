# ChaiNIEx Supply Chain Management System — PRD

**Version:** 1.0  
**Status:** Draft → In Development  
**Authors:** Sameera Acharya, Samarth L  

---

## 1. Purpose

ChaiNIEx needs a purpose-built system to manage the flow of tea products from vendors to end customers. This PRD defines what the system must do, who uses it, and how success is measured.

---

## 2. Users & Roles

### 2.1 Customer
A registered buyer who browses and purchases tea products.

**Needs:**
- Create an account and log in securely
- Browse products by category
- Add items to a cart and place orders
- View real-time order status (Pending → Shipped → Delivered)
- See their full order history

### 2.2 Supplier / Vendor
A business that provides products to ChaiNIEx's inventory.

**Needs:**
- Register as a supplier
- List new products with pricing and stock quantities
- Update product details (price, stock)
- View which of their products have been ordered

### 2.3 Admin
An internal ChaiNIEx system manager.

**Needs:**
- Full CRUD access to all entities (users, suppliers, products, orders, categories)
- View and update order statuses
- Manage product categories
- Monitor stock levels and flag low-stock items

---

## 3. Functional Requirements

### 3.1 Authentication & Authorization
- **FR-01:** Users can register with full name, email, password, and shipping address.
- **FR-02:** Login returns a JWT valid for 24 hours.
- **FR-03:** Admins have a separate login flow and cannot access the customer/supplier portal endpoints.
- **FR-04:** Passwords are never stored in plain text.

### 3.2 Product Management
- **FR-05:** Suppliers can create products linked to a category, with price and stock quantity.
- **FR-06:** Products can be browsed and filtered by category.
- **FR-07:** Product detail page shows name, description, price, and availability.
- **FR-08:** Stock quantity decrements atomically when an order is placed.
- **FR-09:** Out-of-stock products are visible but cannot be added to cart.

### 3.3 Order Management
- **FR-10:** A customer can place an order containing one or more products (order items).
- **FR-11:** `price_at_purchase` is locked at order time regardless of future price changes.
- **FR-12:** Order placement is wrapped in a database transaction; partial failures roll back entirely.
- **FR-13:** Order statuses: `Pending` → `Processing` → `Shipped` → `Delivered` → `Cancelled`.
- **FR-14:** Only admins can advance order status.
- **FR-15:** Customers can cancel orders in `Pending` status only; stock is restored on cancellation.

### 3.4 Category Management
- **FR-16:** Admins can create, rename, and delete categories.
- **FR-17:** A category cannot be deleted if products are assigned to it.

### 3.5 Supplier Management
- **FR-18:** Admins can view and edit any supplier record.
- **FR-19:** Deleting a supplier is blocked if they have active products in inventory.

### 3.6 Admin Dashboard
- **FR-20:** Dashboard shows: total orders, total revenue, products low on stock (< 10 units), and new users in the last 7 days.
- **FR-21:** Admins can search/filter orders by status, date range, and customer.

---

## 4. Non-Functional Requirements

| ID | Requirement |
|----|------------|
| NFR-01 | API response time < 500ms for standard CRUD operations |
| NFR-02 | Database must enforce referential integrity (PostgreSQL FK constraints) |
| NFR-03 | All data mutations go through parameterized queries (no SQL injection surface) |
| NFR-04 | Frontend is usable on Chrome, Firefox, and mobile Safari |
| NFR-05 | System must handle at least 50 concurrent users in demo environment |
| NFR-06 | All sensitive fields (passwords, bank details) are hashed/encrypted |

---

## 5. Out of Scope (v1.0)

The following are explicitly deferred to post-MVP:

- Payment gateway integration (Stripe, Razorpay)
- Email / SMS notification on order status change
- Product image uploads
- Review and rating system
- Analytics / reporting dashboards beyond admin summary
- Mobile native apps
- Multi-currency / multi-region support

---

## 6. Data Requirements

All tables and columns are defined in `ARCHITECTURE.md`. Key data constraints:

| Field | Constraint |
|-------|-----------|
| `email` (users, suppliers, admins) | UNIQUE, validated format |
| `price` | DECIMAL(10,2), must be > 0 |
| `stock_quantity` | INT, must be ≥ 0 at all times |
| `status` (orders) | Enumerated value only |
| `password_hash` | bcrypt, never returned in API responses |

---

## 7. Success Metrics

| Metric | Target |
|--------|--------|
| All CRUD operations work without errors | 100% |
| Order placement transaction integrity | Zero phantom stock deductions |
| Schema passes 3NF normalization check | Full compliance |
| Zero raw SQL concatenation in codebase | 0 instances |
| Demo walkthrough covers all 3 roles end-to-end | Pass |

---

## 8. Open Questions

- [ ] Should suppliers self-register or be admin-approved?
- [ ] Is shipping address per-order or always pulled from the user profile?
- [ ] What is the stock restore policy on cancellation — immediate or admin-confirmed?
