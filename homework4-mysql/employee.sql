-- 1. 查询所有员工的姓名、邮箱和工作岗位。
SELECT
	first_name,
	last_name,
	job_title 
FROM
	employees;
-- 2. 查询所有部门的名称和位置。
SELECT
	dept_name,
	location 
FROM
	departments;
-- 3. 查询工资超过70000的员工姓名和工资。
SELECT
	first_name,
	last_name,
	salary 
FROM
	employees 
WHERE
	salary > 70000;
-- 4. 查询IT部门的所有员工。
SELECT
	e.first_name,
	e.last_name 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id 
WHERE
	d.dept_name = 'IT';
-- 5. 查询入职日期在2020年之后的员工信息。
SELECT
	* 
FROM
	employees 
WHERE
	hire_date > '2020-01-01';
-- 6. 计算每个部门的平均工资。
SELECT
	d.dept_name,
	AVG( e.salary ) AS average_salary 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY
	d.dept_id;
-- 7. 查询工资最高的前3名员工信息。
SELECT
	* 
FROM
	employees 
ORDER BY
	salary DESC 
	LIMIT 3;
-- 8. 查询每个部门员工数量。
SELECT
	d.dept_name,
	COUNT( e.emp_id ) AS num_employees 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY
	d.dept_id;
-- 9. 查询没有分配部门的员工。
SELECT
	* 
FROM
	employees 
WHERE
	dept_id IS NULL;
-- 10. 查询参与项目数量最多的员工。
SELECT
	e.first_name,
	e.last_name,
	COUNT( ep.project_id ) AS num_projects 
FROM
	employees e
	JOIN employee_projects ep ON e.emp_id = ep.emp_id 
GROUP BY
	e.emp_id 
ORDER BY
	num_projects DESC 
	LIMIT 1;
-- 11. 计算所有员工的工资总和。
SELECT
	SUM( salary ) AS total_salary 
FROM
	employees;
-- 12. 查询姓"Smith"的员工信息。
SELECT
	* 
FROM
	employees 
WHERE
	last_name = 'Smith';
-- 13. 查询即将在半年内到期的项目。
SELECT
	* 
FROM
	projects 
WHERE
	end_date BETWEEN CURDATE() 
	AND DATE_ADD( CURDATE(), INTERVAL 6 MONTH );
-- 14. 查询至少参与了两个项目的员工。
SELECT
	e.first_name,
	e.last_name 
FROM
	employees e
	JOIN employee_projects ep ON e.emp_id = ep.emp_id 
GROUP BY
	e.emp_id 
HAVING
	COUNT( ep.project_id ) >= 2;
-- 15. 查询没有参与任何项目的员工。
SELECT
	* 
FROM
	employees e 
WHERE
	NOT EXISTS ( SELECT 1 FROM employee_projects ep WHERE e.emp_id = ep.emp_id );
-- 16. 计算每个项目参与的员工数量。
SELECT
	p.project_name,
	COUNT( ep.emp_id ) AS num_employees 
FROM
	projects p
	JOIN employee_projects ep ON p.project_id = ep.project_id 
GROUP BY
	p.project_id;
-- 17. 查询工资第二高的员工信息。
SELECT
	* 
FROM
	employees 
ORDER BY
	salary DESC 
	LIMIT 1 OFFSET 1;
-- 18. 查询每个部门工资最高的员工。
WITH ranked_employees AS (
	SELECT
		e.*,
		d.dept_name,
		RANK() OVER ( PARTITION BY e.dept_id ORDER BY e.salary DESC ) AS salary_rank 
	FROM
		employees e
		JOIN departments d ON e.dept_id = d.dept_id 
	) SELECT
	* 
FROM
	ranked_employees 
WHERE
	salary_rank <= 1;
-- 19. 计算每个部门的工资总和,并按照工资总和降序排列。
SELECT
	d.dept_name,
	SUM( e.salary ) AS total_salary 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY
	d.dept_id 
ORDER BY
	total_salary DESC;
-- 20. 查询员工姓名、部门名称和工资。
SELECT
	e.first_name,
	e.last_name,
	d.dept_name,
	e.salary 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id;
-- 21. 查询每个员工的上级主管(假设emp_id小的是上级)。
SELECT
	e1.first_name,
	e1.last_name,
	e2.first_name AS manager_first_name,
	e2.last_name AS manager_last_name 
FROM
	employees e1
	JOIN employees e2 ON e1.dept_id = e2.dept_id 
	AND e1.emp_id > e2.emp_id 
ORDER BY
	e1.emp_id;
-- 22. 查询所有员工的工作岗位,不要重复。
SELECT DISTINCT
	job_title 
FROM
	employees;
-- 23. 查询平均工资最高的部门。
SELECT
	dept_name 
FROM
	departments d
	JOIN employees e ON d.dept_id = e.dept_id 
GROUP BY
	d.dept_id 
ORDER BY
	AVG( e.salary ) DESC 
	LIMIT 1;
-- 24. 查询工资高于其所在部门平均工资的员工。
SELECT
	e.* 
FROM
	employees e
	JOIN ( SELECT dept_id, AVG( salary ) AS avg_salary FROM employees GROUP BY dept_id ) AS dept_avg_salaries ON e.dept_id = dept_avg_salaries.dept_id 
WHERE
	e.salary > dept_avg_salaries.avg_salary;
-- 25. 查询每个部门工资前两名的员工。
WITH ranked_employees AS (
	SELECT
		e.*,
		d.dept_name,
		RANK() OVER ( PARTITION BY e.dept_id ORDER BY e.salary DESC ) AS salary_rank 
	FROM
		employees e
		JOIN departments d ON e.dept_id = d.dept_id 
	) SELECT
	* 
FROM
	ranked_employees 
WHERE
	salary_rank <= 2;
-- 26. 查询跨部门的项目(参与员工来自不同部门)。
SELECT
	p.project_name 
FROM
	projects p
	JOIN employee_projects ep ON p.project_id = ep.project_id
	JOIN employees e ON ep.emp_id = e.emp_id 
GROUP BY
	p.project_id 
HAVING
	COUNT( DISTINCT e.dept_id ) > 1;
-- 27. 查询每个员工的工作年限,并按工作年限降序排序。
SELECT
	first_name,
	last_name,
	TIMESTAMPDIFF(
		YEAR,
		hire_date,
	CURDATE()) AS years_of_service 
FROM
	employees 
ORDER BY
	years_of_service DESC;
-- 28. 查询本月过生日的员工(假设hire_date是生日)。
SELECT
	first_name,
	last_name 
FROM
	employees 
WHERE
	MONTH ( hire_date ) = MONTH (
	CURDATE()) 
	AND YEAR ( hire_date ) = YEAR (
	CURDATE());
-- 29. 查询即将在90天内到期的项目和负责该项目的员工。
SELECT
	p.project_name,
	p.end_date,
	e.first_name,
	e.last_name 
FROM
	projects p
	JOIN employee_projects ep ON p.project_id = ep.project_id
	JOIN employees e ON ep.emp_id = e.emp_id 
WHERE
	p.end_date BETWEEN CURDATE() 
	AND DATE_ADD( CURDATE(), INTERVAL 90 DAY );
-- 30. 计算每个项目的持续时间(天数)。
SELECT
	project_name,
	DATEDIFF( end_date, start_date ) AS duration 
FROM
	projects;