# 🍃 ChaiNIEx Supply Chain Management System

[![Database](https://img.shields.io/badge/Database-PostgreSQL%2016-blue?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Backend](https://img.shields.io/badge/Backend-Node.js%20%7C%20Express-green?logo=node.js&logoColor=white)](https://nodejs.org/)
[![Frontend](https://img.shields.io/badge/Frontend-HTML%20%7C%20CSS%20%7C%20JS-orange?logo=javascript&logoColor=white)](https://developer.mozilla.org/en-US/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

**ChaiNIEx** is a comprehensive, production-ready full-stack Supply Chain Management system designed specifically for a tea product business. This project demonstrates advanced database management system (DBMS) design patterns, robust relational normalization, and bulletproof transactional integrity using PostgreSQL 16 and a Node.js + Express backend.

---

## 🚀 Key Features

*   **👥 Three Distinct Portals**:
    *   **Customer Portal**: Browse the scalable catalog of tea products, manage shopping carts, and place/view transaction-secured orders.
    *   **Supplier Portal**: Manage supplied products, monitor inventory stock levels, and coordinate delivery parameters.
    *   **Admin Dashboard**: Fully-featured management console featuring secure bcrypt-authenticated controls, real-time aggregate statistics, and complete CRUD interfaces across all schema relations.
*   **🔒 Bulletproof Transactions**: Critical operations like order processing are secured with strict row-locking (`SELECT ... FOR UPDATE`) and ACID transaction blocks (`BEGIN` / `COMMIT` / `ROLLBACK`).
*   **🏎️ Optimized Performance**: Extensive custom B-Tree indexes on crucial foreign keys and high-frequency queries.
*   **🛡️ Secure Architecture**: BCrypt password hashing, JWT-based authentication, and parameterized SQL queries to prevent SQL injections.

---

## 🛠️ Technology Stack

| Layer | Technology | Description |
| :--- | :--- | :--- |
| **Database** | PostgreSQL 16.x | Relational Database Management System |
| **Backend API** | Node.js + Express | RESTful API server with connection pooling |
| **Database Driver** | `pg` (node-postgres) | Native PostgreSQL client for Node.js |
| **Authentication** | JSON Web Tokens (JWT) + Bcrypt | Secure token auth and password hashing |
| **Frontend** | Vanilla HTML5 / Modern CSS3 / JS | Clean, premium, componentized UI portals |

---

## 📊 Database Architecture

### Entity-Relationship Diagram (ERD)

```
  ┌────────┐ places  ┌────────┐ contains  ┌─────────────┐ includes  ┌──────────┐
  │ Users  ├────────►│ Orders ├──────────►│ Order_Items ├──────────►│ Products │
  └────────┘         └────────┘           └─────────────┘           └────┬─────┘
                                                                         │ supplied
                                                                         │ by
                                                                     ┌───▼───────┐
                                                                     │ Suppliers │
                                                                     └───────────┘
```

### Core Schema & Data Structures
The database design incorporates third normal form (3NF) principles across 7 primary tables:
*   `users`: Customer user profiles and addresses.
*   `suppliers`: Detailed metadata including contact and billing info.
*   `admins`: Administrative accounts with specialized access privileges.
*   `categories`: Scalable product category taxonomy.
*   `products`: Detailed stock records linked with suppliers and categories.
*   `orders`: Order master records tracking purchase timestamps and status.
*   `order_items`: Order line-item details mapping historical purchase prices.

---

## 💻 Setup & Local Development

### Prerequisites
*   [Node.js (v20+)](https://nodejs.org/) installed
*   [PostgreSQL (v16+)](https://www.postgresql.org/) database server running locally

### Step-by-Step Installation

1.  **Initialize Database**
    Launch your PostgreSQL terminal (`psql`) and run:
    ```sql
    CREATE DATABASE chainex_db;
    ```

2.  **Run Schema and Seed Data**
    Import the system DDL schema and seed files:
    ```bash
    psql -U postgres -d chainex_db -f db/schema.sql
    psql -U postgres -d chainex_db -f db/seed.sql
    ```

3.  **Configure Environment Variables**
    Configure your local environment variables by copying `.env.example`:
    ```bash
    cp .env.example .env
    ```
    Verify database port, username, password, and standard configurations inside your new `.env` file.

4.  **Install Dependencies & Start Backend API**
    Navigate to the api folder, install NPM packages, and run the developer daemon:
    ```bash
    cd api
    npm install
    npm run dev
    ```

5.  **Access the Portals**
    With the API running on `http://localhost:4000`, open any of the following HTML files in your browser:
    *   **Customer Shop**: `frontend/customer/index.html`
    *   **Supplier Portal**: `frontend/supplier/index.html`
    *   **Admin Dashboard**: `frontend/admin/index.html`

*For login details and passwords of pre-configured accounts, refer to [login_details.md](file:///c:/Users/samee/OneDrive/Desktop/DBMS/login_details.md).*

---

## 🔒 Security & Best Practices

1.  **Strict SQL Parameters**: To prevent SQL Injection vulnerabilities, all relational queries exclusively utilize parameterized arguments (e.g., `db.query('SELECT * FROM users WHERE email = $1', [email])`).
2.  **ACID Transactions**: Orders execute within a single isolation block, locking target product stock values before final commit to ensure stock counts never drift below zero.
3.  **Cascading Deletes**: Relationships enforce strict referential integrity rules (e.g., `ON DELETE CASCADE` for order items, `ON DELETE RESTRICT` for products with historical orders).

---

## 📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
