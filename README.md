# Online Polling System (MySQL Only)

### 📘 Description
This is a database-only project for an **Online Polling/Voting System**, built using **pure MySQL (DDL + DML)**. No frontend or backend code is included.

---

### 🏗️ Features Implemented
- User registration and identification
- Poll creation with title, description, and expiry
- Multiple poll options per poll
- Single vote per user per poll
- Anonymous voting (optional)
- Vote audit log with timestamps
- Soft deletion support
- Indexing for performance

---

### 📁 Files
- `online_polling_system.sql`: Main SQL file containing:
  - Schema creation
  - Sample data (3 users, 3 polls, 3 options per poll)
  - SQL queries for analytics and bonus features

---

### 📊 Queries Included
- Active/Expired polls
- Total votes per poll & option
- User participation
- Trending polls (last 24 hours)
- Most active users

---

### 🧪 How to Run

#### 🖥️ Option 1: Command Line
```bash
mysql -u root -p < online_polling_system.sql
