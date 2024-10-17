# 一，员工数据库表mysql练习

## 1.1创建员工表代码

-- 创建数据库
CREATE DATABASE IF NOT EXISTS employee_management;
USE employee_management;

-- 创建部门表
CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- 创建员工表
CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    hire_date DATE,
    job_title VARCHAR(50),
    salary DECIMAL(10, 2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- 创建项目表
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE
);

-- 创建员工项目关联表
CREATE TABLE employee_projects (
    emp_id INT,
    project_id INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- 插入部门数据
INSERT INTO departments (dept_name, location) VALUES
('HR', 'New York'),
('IT', 'San Francisco'),
('Finance', 'Chicago'),
('Marketing', 'Los Angeles'),
('Operations', 'Houston');

-- 插入员工数据
INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_title, salary, dept_id) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '2020-01-15', 'HR Manager', 75000.00, 1),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901', '2019-05-20', 'Software Engineer', 85000.00, 2),
('Mike', 'Johnson', 'mike.johnson@example.com', '3456789012', '2018-11-10', 'Financial Analyst', 70000.00, 3),
('Emily', 'Brown', 'emily.brown@example.com', '4567890123', '2021-03-01', 'Marketing Specialist', 65000.00, 4),
('David', 'Wilson', 'david.wilson@example.com', '5678901234', '2017-09-15', 'Operations Manager', 80000.00, 5),
('Sarah', 'Lee', 'sarah.lee@example.com', '6789012345', '2020-07-01', 'IT Support', 60000.00, 2),
('Chris', 'Anderson', 'chris.anderson@example.com', '7890123456', '2019-12-01', 'Accountant', 68000.00, 3),
('Lisa', 'Taylor', 'lisa.taylor@example.com', '8901234567', '2022-01-10', 'HR Assistant', 55000.00, 1),
('Tom', 'Martin', 'tom.martin@example.com', '9012345678', '2018-06-15', 'Software Developer', 82000.00, 2),
('Amy', 'White', 'amy.white@example.com', '0123456789', '2021-09-01', 'Marketing Manager', 78000.00, 4);

-- 插入项目数据
INSERT INTO projects (project_name, start_date, end_date) VALUES
('Website Redesign', '2023-01-01', '2024-11-30'),
('ERP Implementation', '2023-03-15', '2025-03-14'),
('Marketing Campaign', '2023-05-01', '2023-08-31'),
('Financial Audit', '2023-07-01', '2025-09-30'),
('New Product Launch', '2023-09-01', '2024-02-29');

-- 插入员工项目关联数据
INSERT INTO employee_projects (emp_id, project_id) VALUES
(2, 1), (6, 1), (9, 1),
(2, 2), (5, 2), (6, 2), (9, 2),
(4, 3), (10, 3),
(3, 4), (7, 4),
(4, 5), (5, 5), (10, 5);

## 1.2对员工表进行mysql语句练习

**-- 1. 查询所有员工的姓名、邮箱和工作岗位。**
SELECT
	first_name,
	last_name,
	job_title 
FROM
	employees;
**-- 2. 查询所有部门的名称和位置。**
SELECT
	dept_name,
	location 
FROM
	departments;
**-- 3. 查询工资超过70000的员工姓名和工资。**
SELECT
	first_name,
	last_name,
	salary 
FROM
	employees 
WHERE
	salary > 70000;
**-- 4. 查询IT部门的所有员工。**
SELECT
	e.first_name,
	e.last_name 
FROM
	employees e
	JOIN departments d ON e.dept_id = d.dept_id 
WHERE
	d.dept_name = 'IT';
**-- 5. 查询入职日期在2020年之后的员工信息。**
SELECT

FROM
employees 
WHERE
hire_date > '2020-01-01';
**-- 6. 计算每个部门的平均工资。**
SELECT
d.dept_name,
AVG( e.salary ) AS average_salary 
FROM
employees e
JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY
d.dept_id;
**-- 7. 查询工资最高的前3名员工信息。**
SELECT

FROM
employees 
ORDER BY
salary DESC 
LIMIT 3;

**-- 8. 查询每个部门员工数量。****
SELECT
d.dept_name,
COUNT( e.emp_id ) AS num_employees 
FROM
employees e
JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY
d.dept_id;
**-- 9. 查询没有分配部门的员工。**
SELECT

FROM
employees 
WHERE
dept_id IS NULL;
**-- 10. 查询参与项目数量最多的员工。**
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
**-- 11. 计算所有员工的工资总和。**
SELECT
SUM( salary ) AS total_salary 
FROM
employees;
**-- 12. 查询姓"Smith"的员工信息。**
SELECT

FROM
employees 
WHERE
last_name = 'Smith';
**-- 13. 查询即将在半年内到期的项目。**
SELECT

FROM
projects 
WHERE
end_date BETWEEN CURDATE() 
AND DATE_ADD( CURDATE(), INTERVAL 6 MONTH );
**-- 14. 查询至少参与了两个项目的员工。**
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
**-- 15. 查询没有参与任何项目的员工。**
SELECT

FROM
employees e 
WHERE
NOT EXISTS ( SELECT 1 FROM employee_projects ep WHERE e.emp_id = ep.emp_id );
**-- 16. 计算每个项目参与的员工数量。**
SELECT
p.project_name,
COUNT( ep.emp_id ) AS num_employees 
FROM
projects p
JOIN employee_projects ep ON p.project_id = ep.project_id 
GROUP BY
p.project_id;
**-- 17. 查询工资第二高的员工信息。**
SELECT

FROM
employees 
ORDER BY
salary DESC 
LIMIT 1 OFFSET 1;
**-- 18. 查询每个部门工资最高的员工。**
WITH ranked_employees AS (
SELECT
e.*,
d.dept_name,
RANK() OVER ( PARTITION BY e.dept_id ORDER BY e.salary DESC ) AS salary_rank 
FROM
employees e
JOIN departments d ON e.dept_id = d.dept_id 
) SELECT

FROM
ranked_employees 
WHERE
salary_rank <= 1;
**-- 19. 计算每个部门的工资总和,并按照工资总和降序排列。**
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
**-- 20. 查询员工姓名、部门名称和工资。**
SELECT
e.first_name,
e.last_name,
d.dept_name,
e.salary 
FROM
employees e
JOIN departments d ON e.dept_id = d.dept_id;
**-- 21. 查询每个员工的上级主管(假设emp_id小的是上级)。**
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
**-- 22. 查询所有员工的工作岗位,不要重复。**
SELECT DISTINCT
job_title 
FROM
employees;
**-- 23. 查询平均工资最高的部门。**
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
**-- 24. 查询工资高于其所在部门平均工资的员工。**
SELECT
e.* 
FROM
employees e
JOIN ( SELECT dept_id, AVG( salary ) AS avg_salary FROM employees GROUP BY dept_id ) AS dept_avg_salaries ON e.dept_id = dept_avg_salaries.dept_id 
WHERE
e.salary > dept_avg_salaries.avg_salary;
**-- 25. 查询每个部门工资前两名的员工。**
WITH ranked_employees AS (
SELECT
e.*,
d.dept_name,
RANK() OVER ( PARTITION BY e.dept_id ORDER BY e.salary DESC ) AS salary_rank 
FROM
employees e
JOIN departments d ON e.dept_id = d.dept_id 
) SELECT

FROM
ranked_employees 
WHERE
salary_rank <= 2;
**-- 26. 查询跨部门的项目(参与员工来自不同部门)。**
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
**-- 27. 查询每个员工的工作年限,并按工作年限降序排序。**
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
**-- 28. 查询本月过生日的员工(假设hire_date是生日)。**
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
**-- 29. 查询即将在90天内到期的项目和负责该项目的员工。**
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
**-- 30. 计算每个项目的持续时间(天数)。**
SELECT
project_name,
DATEDIFF( end_date, start_date ) AS duration 
FROM
projects;

# 二，学生选课表mysql练习

## 2.1创建学生表相关代码

DROP TABLE IF EXISTS `course`;

   CREATE TABLE `course`  (
     `course_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `course_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `teacher_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
     `credits` decimal(2, 1) NULL DEFAULT NULL,
     PRIMARY KEY (`course_id`) USING BTREE,
     INDEX `teacher_id`(`teacher_id`) USING BTREE,
     CONSTRAINT `course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
   ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------

   -- Records of course

-- ----------------------------

   INSERT INTO `course` VALUES ('C001', '高等数学', 'T001', 4.0);
   INSERT INTO `course` VALUES ('C002', '大学物理', 'T002', 3.5);
   INSERT INTO `course` VALUES ('C003', '程序设计', 'T003', 4.0);
   INSERT INTO `course` VALUES ('C004', '数据结构', 'T004', 3.5);
   INSERT INTO `course` VALUES ('C005', '数据库原理', 'T005', 4.0);
   INSERT INTO `course` VALUES ('C006', '操作系统', 'T006', 3.5);

-- ----------------------------

   -- Table structure for score

-- ----------------------------

   DROP TABLE IF EXISTS `score`;
   CREATE TABLE `score`  (
     `student_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `course_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `score` decimal(4, 1) NULL DEFAULT NULL,
     PRIMARY KEY (`student_id`, `course_id`) USING BTREE,
     INDEX `course_id`(`course_id`) USING BTREE,
     CONSTRAINT `score_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
     CONSTRAINT `score_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
   ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------

   -- Records of score

-- ----------------------------

   INSERT INTO `score` VALUES ('2021001', 'C001', 85.5);
   INSERT INTO `score` VALUES ('2021001', 'C002', 78.0);
   INSERT INTO `score` VALUES ('2021001', 'C003', 90.5);
   INSERT INTO `score` VALUES ('2021002', 'C001', 92.0);
   INSERT INTO `score` VALUES ('2021002', 'C002', 83.5);
   INSERT INTO `score` VALUES ('2021002', 'C004', 58.0);
   INSERT INTO `score` VALUES ('2021003', 'C001', 76.5);
   INSERT INTO `score` VALUES ('2021003', 'C003', 85.0);
   INSERT INTO `score` VALUES ('2021003', 'C005', 69.5);
   INSERT INTO `score` VALUES ('2021004', 'C002', 88.5);
   INSERT INTO `score` VALUES ('2021004', 'C004', 92.5);
   INSERT INTO `score` VALUES ('2021004', 'C006', 86.0);
   INSERT INTO `score` VALUES ('2021005', 'C001', 61.0);
   INSERT INTO `score` VALUES ('2021005', 'C003', 87.5);
   INSERT INTO `score` VALUES ('2021005', 'C005', 84.0);
   INSERT INTO `score` VALUES ('2021006', 'C002', 79.5);
   INSERT INTO `score` VALUES ('2021006', 'C004', 83.0);
   INSERT INTO `score` VALUES ('2021006', 'C006', 90.0);
   INSERT INTO `score` VALUES ('2021007', 'C001', 93.5);
   INSERT INTO `score` VALUES ('2021007', 'C003', 89.0);
   INSERT INTO `score` VALUES ('2021007', 'C005', 94.5);
   INSERT INTO `score` VALUES ('2021008', 'C002', 86.5);
   INSERT INTO `score` VALUES ('2021008', 'C004', 91.0);
   INSERT INTO `score` VALUES ('2021008', 'C006', 87.5);
   INSERT INTO `score` VALUES ('2021009', 'C001', 80.0);
   INSERT INTO `score` VALUES ('2021009', 'C003', 62.5);
   INSERT INTO `score` VALUES ('2021009', 'C005', 85.5);
   INSERT INTO `score` VALUES ('2021010', 'C002', 64.5);
   INSERT INTO `score` VALUES ('2021010', 'C004', 89.5);
   INSERT INTO `score` VALUES ('2021010', 'C006', 93.0);

-- ----------------------------

   -- Table structure for student

-- ----------------------------

   DROP TABLE IF EXISTS `student`;
   CREATE TABLE `student`  (
     `student_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `birth_date` date NULL DEFAULT NULL,
     `my_class` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
     PRIMARY KEY (`student_id`) USING BTREE
   ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------

   -- Records of student

-- ----------------------------

   INSERT INTO `student` VALUES ('2021001', '张三', '男', '2003-05-15', '计算机一班');
   INSERT INTO `student` VALUES ('2021002', '李四', '女', '2003-08-22', '计算机一班');
   INSERT INTO `student` VALUES ('2021003', '王五', '男', '2002-11-30', '数学一班');
   INSERT INTO `student` VALUES ('2021004', '赵六', '女', '2003-02-14', '数学一班');
   INSERT INTO `student` VALUES ('2021005', '钱七', '男', '2002-07-08', '物理一班');
   INSERT INTO `student` VALUES ('2021006', '孙八', '女', '2003-09-19', '物理一班');
   INSERT INTO `student` VALUES ('2021007', '周九', '男', '2002-12-01', '化学一班');
   INSERT INTO `student` VALUES ('2021008', '吴十', '女', '2003-03-25', '化学一班');
   INSERT INTO `student` VALUES ('2021009', '郑十一', '男', '2002-06-11', '生物一班');
   INSERT INTO `student` VALUES ('2021010', '王十二', '女', '2003-10-05', '生物一班');

-- ----------------------------

   -- Table structure for teacher

-- ----------------------------

   DROP TABLE IF EXISTS `teacher`;
   CREATE TABLE `teacher`  (
     `teacher_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `gender` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
     `birth_date` date NULL DEFAULT NULL,
     `title` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
     PRIMARY KEY (`teacher_id`) USING BTREE
   ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------

   -- Records of teacher

-- ----------------------------

   INSERT INTO `teacher` VALUES ('T001', '张教授', '男', '1975-03-12', '教授');
   INSERT INTO `teacher` VALUES ('T002', '李副教授', '女', '1980-07-22', '副教授');
   INSERT INTO `teacher` VALUES ('T003', '王讲师', '男', '1985-11-08', '讲师');
   INSERT INTO `teacher` VALUES ('T004', '赵助教', '女', '1990-05-15', '助教');
   INSERT INTO `teacher` VALUES ('T005', '钱教授', '男', '1972-09-30', '教授');
   INSERT INTO `teacher` VALUES ('T006', '孙副教授', '女', '1978-12-18', '副教授');
   INSERT INTO `teacher` VALUES ('T007', '周讲师', '男', '1983-04-25', '讲师');
   INSERT INTO `teacher` VALUES ('T008', '吴助教', '女', '1988-08-07', '助教');
   INSERT INTO `teacher` VALUES ('T009', '郑教授', '男', '1970-01-01', '教授');
   INSERT INTO `teacher` VALUES ('T010', '刘副教授', '女', '1976-06-14', '副教授');

   SET FOREIGN_KEY_CHECKS = 1;

SELECT score.score
FROM score
GROUP BY score.student_id;

## 2.2学生表mysql练习

**-- 1. 查询所有学生的信息。**

SELECT * FROM student;

**-- 2. 查询所有课程的信息。**

SELECT * FROM course;

**-- 3. 查询所有学生的姓名、学号和班级。**

SELECT name, student_id, my_class FROM student;

**-- 4. 查询所有教师的姓名和职称。**

SELECT name, title FROM teacher;

**-- 5. 查询不同课程的平均分数。**

SELECT
	course_id,
	AVG( score )
FROM
	score 
GROUP BY
	course_id;

**-- 6. 查询每个学生的平均分数。**

SELECT
	student_id,
	AVG( score )
FROM
	score 
GROUP BY
	student_id;

**-- 7. 查询分数大于85分的学生学号和课程号。****

SELECT
	student_id,
	course_id 
FROM
	score 
WHERE
	score > 85;

**-- 8. 查询每门课程的选课人数。**

SELECT
	course_id,
	COUNT(*)  
FROM
	score 
GROUP BY
	course_id

**-- 9. 查询选修了"高等数学"课程的学生姓名和分数。**

SELECT
	s.NAME,
	course_name,
	sc.score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id 
WHERE
	c.course_name = '高等数学'

**-- 10. 查询没有选修"大学物理"课程的学生姓名。**

SELECT NAME 
FROM
	student 
WHERE
	student_id NOT IN (
	SELECT
		student_id 
	FROM
		score 
	WHERE
	course_id IN ( SELECT course_id FROM course WHERE course_name = '大学物理' ));

**-- 11. 查询C001比C002课程成绩高的学生信息及课程分数。**

SELECT
	s.student_id,
	s.NAME,
	sc1.score AS score_c001,
	sc2.score AS score_c002 
FROM
	student s
	JOIN score sc1 ON s.student_id = sc1.student_id 
	AND sc1.course_id = 'C001'
	JOIN score sc2 ON s.student_id = sc2.student_id 
	AND sc2.course_id = 'C002' 
WHERE
	sc1.score > sc2.score;

**-- 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比**

SELECT
	c.course_id,
	c.course_name,
	COUNT( CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 END ) AS score_100_85,
	COUNT( CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 END ) AS score_85_70,
	COUNT( CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 END ) AS score_70_60,
	COUNT( CASE WHEN sc.score < 60 THEN 1 END ) AS score_60_0,
	ROUND(( COUNT( CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS percent_100_85,
	ROUND(( COUNT( CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS percent_85_70,
	ROUND(( COUNT( CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS percent_70_60,
	ROUND(( COUNT( CASE WHEN sc.score < 60 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS percent_60_0 
FROM
	score sc
	JOIN course c ON sc.course_id = c.course_id 
GROUP BY
	c.course_id;

**-- 13. 查询选择C002课程但没选择C004课程的成绩情况(不存在时显示为 null )。**

SELECT
	student_id,
	score 
FROM
	score 
WHERE
	course_id = 'C002' 
	AND student_id NOT IN ( SELECT sc2.student_id FROM score sc2 WHERE sc2.course_id = 'C004' )

**-- 14. 查询平均分数最高的学生姓名和平均分数。**

SELECT
	s.NAME,
	AVG( sc.score ) AS average_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	s.student_id 
ORDER BY
	average_score DESC 
	LIMIT 1;

**-- 15. 查询总分最高的前三名学生的姓名和总分。**

SELECT
	s.NAME,
	SUM( sc.score ) AS total_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	s.student_id 
ORDER BY
	total_score DESC 
	LIMIT 3;

**-- 16. 查询各科成绩最高分、最低分和平均分。要求如下：****

课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率****

**及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90****

**要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列****

SELECT
	c.course_id,
	c.course_name,
	MAX( sc.score ) AS highest_score,
	MIN( sc.score ) AS lowest_score,
	AVG( sc.score ) AS average_score,
	ROUND(( COUNT( CASE WHEN sc.score >= 60 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS pass_rate,
	ROUND(( COUNT( CASE WHEN sc.score BETWEEN 70 AND 80 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS average_rate,
	ROUND(( COUNT( CASE WHEN sc.score BETWEEN 80 AND 90 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS good_rate,
	ROUND(( COUNT( CASE WHEN sc.score >= 90 THEN 1 END ) / COUNT(*)) * 100, 2 ) AS excellent_rate 
FROM
	score sc
	JOIN course c ON sc.course_id = c.course_id 
GROUP BY
	c.course_id;

**-- 17. 查询男生和女生的人数。**

SELECT
	gender,
	COUNT(*)
FROM
	student 
GROUP BY
	gender;

**-- 18. 查询年龄最大的学生姓名。**
SELECT NAME 
FROM
	student 
WHERE
	birth_date = ( SELECT MIN( birth_date ) FROM student );

**-- 19. 查询年龄最小的教师姓名。**

SELECT NAME 
FROM
	teacher 
WHERE
	birth_date = ( SELECT MAX( birth_date ) FROM teacher );

**-- 20. 查询学过「张教授」授课的同学的信息。**

SELECT
	s.* 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id
	JOIN teacher t ON c.teacher_id = t.teacher_id 
WHERE
	t.NAME = '张教授';

**-- 21. 查询查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息 。**

SELECT
	s.* 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id
	JOIN teacher t ON c.teacher_id = t.teacher_id 
WHERE
	t.NAME = '张教授';

**-- 22. 查询每门课程的平均分数，并按平均分数降序排列。**

SELECT
	course_id,
	AVG( score ) AS average_score 
FROM
	score 
GROUP BY
	course_id 
ORDER BY
	average_score DESC;

**-- 23. 查询学号为"2021001"的学生所有课程的分数。**

SELECT
	course_id,
	score 
FROM
	score 
WHERE
	student_id = '2021001';-

**-- 24. 查询所有学生的姓名、选修的课程名称和分数。**

SELECT
	s.NAME,
	c.course_name,
	sc.score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id;

**-- 25. 查询每个教师所教授课程的平均分数。**

SELECT
	t.NAME,
	c.course_name,
	AVG( sc.score ) AS average_score 
FROM
	teacher t
	JOIN course c ON t.teacher_id = c.teacher_id
	JOIN score sc ON c.course_id = sc.course_id 
GROUP BY
	t.NAME,
	c.course_name;

**-- 26. 查询分数在80到90之间的学生姓名和课程名称。**

SELECT
	s.NAME,
	c.course_name 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id 
WHERE
	sc.score BETWEEN 80 
	AND 90;

**-- 27. 查询每个班级的平均分数。**

SELECT
	my_class,
	AVG( sc.score ) AS average_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	my_class;

**-- 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。**



SELECT NAME 
FROM
	student 
WHERE
	student_id NOT IN (
	SELECT
		student_id 
	FROM
		score 
	WHERE
		course_id IN (
		SELECT
			course_id 
		FROM
			course 
		WHERE
		teacher_id IN ( SELECT teacher_id FROM teacher WHERE NAME = '王讲师' )))

**-- 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩 。**

SELECT
	s.student_id,
	s.NAME,
	AVG( sc.score ) AS average_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	s.student_id 
HAVING
	COUNT( sc.score ) >= 2 
	AND AVG( sc.score ) < 85;

**-- 30. 查询所有学生的总分并按降序排列。**

SELECT
	student_id,
	SUM( score ) AS total_score 
FROM
	score 
GROUP BY
	student_id 
ORDER BY
	total_score DESC

**-- 31. 查询平均分数超过85分的课程名称。**

SELECT
	c.course_name 
FROM
	course c
	JOIN score sc ON c.course_id = sc.course_id 
GROUP BY
	c.course_id 
HAVING
	AVG( sc.score ) > 85

**-- 32. 查询每个学生的平均成绩排名。**

SELECT score.student_id,student.`name`,AVG(score)
FROM score,student
WHERE score.student_id=student.student_id
GROUP BY score.student_id,student.`name`
ORDER BY AVG(score) DESC



**-- 33. 查询每门课程分数最高的学生姓名和分数。**、、、、

SELECT `name`,score,course_id
FROM student,score
WHERE student.student_id=score.student_id and (score.score,score.course_id) IN(
SELECT MAX(score),score.course_id
FROM  score
GROUP BY score.course_id
)

**-- 34. 查询选修了"高等数学"和"大学物理"的学生姓名。**

SELECT s.name
FROM student s
WHERE s.student_id IN (
    SELECT score.student_id
    FROM score
    JOIN course ON score.course_id = course.course_id
    WHERE course.course_name = '大学物理'
) AND s.student_id IN (
    SELECT score.student_id
    FROM score
    JOIN course ON score.course_id = course.course_id
    WHERE course.course_name = '高等数学'
);

**-- 35. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩（没有选课则为空）。**

SELECT
	s.NAME,
	c.course_name,
	sc.score,
	AVG( sc.score ) OVER ( PARTITION BY s.student_id ) AS average_score 
FROM
	student s
	LEFT JOIN score sc ON s.student_id = sc.student_id
	LEFT JOIN course c ON sc.course_id = c.course_id 
ORDER BY
	average_score DESC

**-- 36. 查询分数最高和最低的学生姓名及其分数。**、、

SELECT s.name, sc.score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
WHERE sc.score = (
    SELECT MAX(score) FROM score
) OR sc.score = (
    SELECT MIN(score) FROM score
);
)

**-- 37. 查询每个班级的最高分和最低分。****

SELECT
	my_class,
	MAX( score ) AS highest_score,
	MIN( score ) AS lowest_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	my_class;

**-- 38. 查询每门课程的优秀率（优秀为90分）。**

SELECT
	c.course_name,
	COUNT( CASE WHEN sc.score >= 90 THEN 1 END ) / COUNT(*) AS excellent_rate 
FROM
	course c
	JOIN score sc ON c.course_id = sc.course_id 
GROUP BY
	c.course_id;

**-- 39. 查询平均分数超过班级平均分数的学生。**

SELECT
	s.NAME,
	s.my_class,
	AVG( sc.score ) AS average_score 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id 
GROUP BY
	s.student_id 
HAVING
	average_score > (
	SELECT
		AVG( sc2.score ) 
	FROM
		score sc2
		JOIN student s2 ON sc2.student_id = s2.student_id 
	WHERE
		s2.my_class = s.my_class 
	);

**-- 40. 查询每个学生的分数及其与课程平均分的差值。**

SELECT
	s.NAME,
	c.course_name,
	sc.score,
	AVG( sc.score ) OVER ( PARTITION BY sc.course_id ) AS course_average,
	sc.score - AVG( sc.score ) OVER ( PARTITION BY sc.course_id ) AS difference 
FROM
	student s
	JOIN score sc ON s.student_id = sc.student_id
	JOIN course c ON sc.course_id = c.course_id;

