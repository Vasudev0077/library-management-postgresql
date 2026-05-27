##### **Library Management System using PostgreSQL**



A relational database project developed using PostgreSQL for managing library operations such as users, books, issued books, accounts, roles, and fine calculation.



\---



\## Features



\- User Management

\- Role-based Structure

\- Book Management

\- Book Issue and Return System

\- Automatic Fine Calculation using Trigger and PL/pgSQL Function

\- One-to-One, One-to-Many, and Many-to-Many Relationships

\- Indexing for Faster Queries



\---



\## Technologies Used



\- PostgreSQL

\- SQL

\- PL/pgSQL



\---



\## Database Components



\### Tables

\- users

\- roles

\- books

\- issued\_books

\- fines

\- accounts

\- user\_roles



\### Constraints Used

\- PRIMARY KEY

\- FOREIGN KEY

\- UNIQUE

\- CHECK

\- NOT NULL



\### Advanced Concepts

\- Triggers

\- Functions

\- Indexes



\---



\## Trigger Functionality



The project includes a PostgreSQL trigger that automatically calculates fines when a book is returned after the due date.



Fine Rule:

\- ₹5 per late day



\---



\## Relationships



| Relationship | Type |

|---|---|

| users → accounts | One-to-One |

| users → issued\_books | One-to-Many |

| books → issued\_books | One-to-Many |

| issued\_books → fines | One-to-One |

| users ↔ roles | Many-to-Many |



\---



\## ER Diagram



!\[ER Diagram](ER\_Diagram.png)



\---



\## How to Run



1\. Install PostgreSQL

2\. Create a database

3\. Open pgAdmin or psql

4\. Run the library\_management.sql file in PostgreSQL or pgAdmin.





##### **Project Purpose**



This project was created as a final year BTech CSE database project to demonstrate:



Relational database design

SQL query writing

Database normalization

Trigger automation

PostgreSQL concepts

Author



Vasudev Naik

BTech CSE

