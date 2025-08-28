---
date: '2025-08-28T12:23:01+05:30'
draft: false
title: 'SQL: Basic Queries'
summary: "Quick guide on how to execute basic queries on SQL databases."
tags: 
- sql
- postgresql
author: "Yashwanth Rathakrishnan"
TocOpen: true
ShowToc: true
ShowReadingTime: true
ShowCodeCopyButtons: true
---

# CREATE TABLE
```sql
CREATE TABLE employee (
	emp_id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	department VARCHAR(20),
	salary NUMERIC(10, 2)
);
```
> In `NUMERIC(10,2)`, the **`10` is the precision**, and **`2` is the scale**. Example: `1234567890.12` (_always store extra two digits after the decimal_)

# SELECT QUERY
- Displays all the table data:
	```sql
	SELECT * FROM employee;
	```
- Displays specific table data:
	```sql
	SELECT name, salary FROM employee;
	```
# FILTERING with WHERE
1. **`SELECT` employee with salary > 80000:**
```sql
SELECT * FROM employee
WHERE salary > 80000;
```
Replace `>` with other operators such as
- `=` (equal)
- `<>` (not equal)
- `<` (less than) | `>` (greater than)
- `<=` (less than or equal) | `>=` (greater than or equal)

2. **`SELECT` employee with salary < 80000 and in "HR" department:**
```sql
SELECT * FROM employee
WHERE salary > 80000 AND department = 'HR';
```
Other conditions are:
- `AND`
- `NOT`
- `OR`

3. **`SELECT` using `BETWEEN` & `AND`:**
```sql
SELECT * FROM employee
WHERE salary BETWEEN 50000 AND 80000;
```

4. **`SELECT` employees in certain departments:**
```sql
SELECT * FROM employee
WHERE depart IN ('HR', 'Finance');
```

# SORTING
```sql
SELECT * FROM employee
ORDER BY salary; #ascending
```
```sql
SELECT * FROM employee
ORDER BY salary DESC; #descending
```

# AGGREGATE FUNCTIONS
1. COUNT()
```sql
SELECT COUNT(*) AS emp_count FROM employee;
```
2. AVG()
```sql
SELECT AVG(salary) AS average_salary FROM employee;
```
3. SUM()
```sql
SELECT SUM(salary) AS sum_of_salary FROM employee;
```
4. MIN() & MAX()
```sql
SELECT MIN(salary) AS min_sal_emp FROM employee;
SELECT MAX(salary) AS min_sal_emp FROM employee;
```

# GROUP BY
`SELECT` all department, sum their salary and group them by department:
```sql
SELECT department, SUM(salary) AS tot_salary
FROM employee
GROUP BY department;
```

# UPDATE & DELETE
**`UPDATE`**:
```sql
UPDATE employee
SET salary = 88000
WHERE employee_id = 2;
```
**`DELETE`**:
```sql
DELETE FROM employee
WHERE employee_id = 3
```