USE hr_analytics;
RENAME TABLE cleaned_data TO hr_data;
SELECT COUNT(*) AS total_records
FROM hr_data;
SELECT *
FROM hr_data
LIMIT 10;

# 1 - Overall Attrition Rate?

SELECT 
ROUND(AVG(attrition)*100,2) AS attrition_rate
FROM hr_data;

# 2 - Which departments lose the most employees?

SELECT 
department,
COUNT(*) total_employees,
SUM(attrition) total_attrition,
ROUND(AVG(attrition)*100,2) attrition_rate
FROM hr_data
GROUP BY department
ORDER BY attrition_rate DESC;

# 3 - Department Ranking by Attrition

SELECT 
department,
ROUND(AVG(attrition)*100,2)  AS attrition_rate,

RANK() OVER(
ORDER BY AVG(attrition) DESC
)  AS department_rank

FROM hr_data
GROUP BY department;

# 4 -  Average Satisfaction by Department

SELECT
department,
ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM hr_data
GROUP BY department
ORDER BY avg_satisfaction;

# 5 -  Which office location has highest turnover?

SELECT
location,
COUNT(*)  AS employees,
SUM(attrition)  AS attrition_count,
ROUND(AVG(attrition)*100,2)  AS attrition_rate
FROM hr_data
GROUP BY location
ORDER BY attrition_rate DESC;

# 6 - Which departments have lowest satisfaction?

SELECT
department,
ROUND(AVG(satisfaction_score),2)  AS avg_satisfaction
FROM hr_data
GROUP BY department
ORDER BY avg_satisfaction ASC;

# 7 - Top Overtime Employees?

SELECT
employee_id,
department,
overtime_hours,
RANK() OVER(ORDER BY overtime_hours DESC) AS overtime_rank
FROM hr_data
LIMIT 20;

# 8 - Cumulative Attrition per Department

SELECT
department,
employee_id,
SUM(attrition) OVER(PARTITION BY department) AS dept_attrition_total
FROM hr_data;

# 9 - Attrition by Experience

SELECT
experience_years,
COUNT(*) AS employees,
SUM(attrition) AS attrition_count,
ROUND(AVG(attrition)*100,2) AS attrition_rate
FROM hr_data
GROUP BY experience_years
ORDER BY experience_years;

# 10 - Department Performance vs Attrition

SELECT
department,
ROUND(AVG(performance_score),2) AS avg_performance,
ROUND(AVG(attrition)*100,2) AS attrition_rate
FROM hr_data
GROUP BY department;

# 11 - Work-Life Balance Impact

SELECT
work_life_balance,
ROUND(AVG(attrition)*100,2) AS attrition_rate
FROM hr_data
GROUP BY work_life_balance
ORDER BY work_life_balance;

# 12 - Attrition by Department and Role?

SELECT
department,
role,
ROUND(AVG(attrition)*100,2) AS attrition_rate
FROM hr_data
GROUP BY department, role
ORDER BY attrition_rate DESC;

# KPI Summary

SELECT
COUNT(*) AS total_employees,
SUM(attrition) AS employees_left,
ROUND(AVG(satisfaction_score),2) AS avg_satisfaction,
ROUND(AVG(work_life_balance),2) AS avg_work_life_balance
FROM hr_data;



