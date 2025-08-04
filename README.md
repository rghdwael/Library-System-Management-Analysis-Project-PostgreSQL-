# 📚 Library Analysis Project (PostgreSQL)

This is a SQL-based data analysis project built on a fictional library management system. The project focuses on data exploration and analytical querying to gain insights into book usage, employee performance, member behavior, and operational efficiency across library branches.

> 🎥 **Original inspiration**: This project is based on the tutorial by Zero Analyst  
> Watch it here: [https://youtu.be/h-s_kQIqndg?si=Jg1qOgHcZXUSs9LA](https://youtu.be/h-s_kQIqndg?si=Jg1qOgHcZXUSs9LA)  
> 🧠 I extended the original project with **additional custom analysis queries** to simulate real-world operations.

---

## 🗂️ Project Overview

- **Topic**: Library Data Analysis  
- **Database**: PostgreSQL  
- **Tools Used**: SQL, pgAdmin  
- **Focus Areas**: Book activity, member behavior, employee performance, overdue tracking, and branch-level KPIs

---

## 🛠️ Skills Applied

- SQL Joins (INNER, LEFT JOIN)  
- Aggregation (COUNT, SUM, GROUP BY, HAVING)  
- Window Functions (`RANK()`)  
- Date functions (`DATE_TRUNC`, `INTERVAL`)  
- Subqueries & CTEs  
- Stored Procedure using PL/pgSQL

---

## 🧱 Database Schema

The database includes the following main tables:

| Table Name      | Description                             |
|-----------------|-----------------------------------------|
| `branch`        | Library branches                        |
| `employees`     | Employees and their branch assignments  |
| `members`       | Registered library members              |
| `books`         | Book catalog                            |
| `issued_status` | Issued book records                     |
| `return_status` | Book returns                            |

> An ERD picture is included to explore the Tables.

---

## 🔍 Key Questions Answered

### 📖 Book Insights
- Which books are issued the most?
- What is the most common book category?
- Total rental price per category?
- Which books were never returned?

### 👤 Member Insights
- Who issued more than one book?
- Who didn't return books after 30+ days?
- Who are the most frequent borrowers each month?

### 🧑‍💼 Employee & Branch Insights
- Branch performance (books issued, returned, revenue)
- Employees with the most books issued

### 🔄 My Additions
- Top 5 frequent borrowers each month using `RANK()`
- Authors with the highest number of book issues
- Peak months for issues and returns
- Stored Procedure `issue_book` that:
  - Checks if the book is available
  - Inserts issue record
  - Updates book status

---


### 👩‍💻 By : Raghad Khudair

This project is part of my learning portfolio as a beginner in SQL and data analysis. I'm looking forward to building more projects, gaining new skills, and growing in the data field.
> 🌱 Thanks for reading! More projects coming soon — stay tuned.
