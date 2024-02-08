-- create database
create database HR;
use HR;

select * from employee_survey_data;
select * from manager_survey_data;
select * from general_data;

/* 1. Retrieve the total number of employees in the dataset. */
select Attrition, count(EmployeeID) as 'Total Employees' 
from general_data
group by attrition;

 /* 2. List all unique job roles in the dataset. */
 select distinct JobRole from general_data;

/* 3. Find the average age of employees. */
select round(avg(age),2) as 'Average age of emplyees' 
from general_data
where Attrition = 'No';

/* 4. Retrieve the names and ages of employees who have worked at the company for more than 5 years. */
select EmployeeID, age from general_data
where YearsAtCompany > 5 and attrition ='No';

/* 5. Get a count of employees grouped by their department. */
select Department, count(EmployeeID) as 'No. of Employee'
from general_data
where attrition = 'No'
group by Department;

/* 6. List employees who have 'High' Job Satisfaction. */
select e.EmployeeID, e.jobsatisfaction
from employee_survey_data as e
join general_data as g
on e.EmployeeID = g.EmployeeID
where g.attrition = 'No' and e.jobsatisfaction = 3;

/* 7. Find the highest Monthly Income in the dataset. */
select max(MonthlyIncome) as 'Highest Monthly Income'
from general_data;

/* 8. List employees who have 'Travel_Rarely' as their BusinessTravel type. */
select EmployeeID from general_data
where BusinessTravel = 'Travel_Rarely' and attrition = 'No';

/* 9. Retrieve the distinct MaritalStatus categories in the dataset. */
select distinct MaritalStatus
from general_data;

/* 10. Get a list of employees with more than 2 years of work experience but less than 4 years in their current role. */
select EmployeeID from general_data	
where TotalWorkingYears > 2 and YearsSinceLastPromotion < 4 and attrition = 'No' and TotalWorkingYears <> 'NA';

/* 11. List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job). */
select EmployeeID, Joblevel, JobRole, YearsAtCompany, YearsSinceLastPromotion
from general_data
where YearsSinceLastPromotion <> YearsAtCompany and YearsSinceLastPromotion<>0;
  
/* 12. Find the average distance from home for employees in each department. */
select department, round(avg(DistanceFromHome),2) as 'Avg distance from Home'
from general_data
where attrition = 'No'
group by department;

/* 13. Retrieve the top 5 employees with the highest MonthlyIncome. */
select EmployeeID, MonthlyIncome
from general_data
order by MonthlyIncome desc
limit 5;

/* 14. Calculate the percentage of employees who have had a promotion in the last year. */
select
round(((select count(employeeID) from general_data where YearsSinceLastPromotion = 1 and attrition = 'No')/
(select count(employeeID) from general_data where attrition = 'No'))*100,2) as 'Percentage of emplyees'
from general_data
limit 1;

/* 15. List the employees with the highest and lowest EnvironmentSatisfaction. */
(select employeeID, EnvironmentSatisfaction from employee_survey_data
where EnvironmentSatisfaction <> 'NA'
order by EnvironmentSatisfaction desc
limit 1)
union all
(select employeeID, EnvironmentSatisfaction from employee_survey_data
where EnvironmentSatisfaction <> 'NA'
order by EnvironmentSatisfaction
limit 1);


/* 16. Find the employees who have the same JobRole and MaritalStatus. */
select EmployeeID, jobrole, maritalstatus
from general_data
where attrition = 'No'
order by jobrole, maritalstatus;

/* 17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4. */
select g.employeeID, g.TotalWorkingYears, m.PerformanceRating
from general_data as g
join manager_survey_data as m
on g.EmployeeID = m.EmployeeID
where m.PerformanceRating = 4 and attrition = 'No' and TotalWorkingYears in (33, 34, 35, 36, 37, 38)
order by g.TotalWorkingYears desc;

/* 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type. */
select g.BusinessTravel, e.JobSatisfaction, round(avg(g.age),2) as 'Average age'
from general_data as g
join employee_survey_data as e
on g.EmployeeID = e.EmployeeID
where attrition = 'No'
group by g.BusinessTravel, e.JobSatisfaction
order by g.BusinessTravel;
	
/* 19. Retrieve the most common EducationField among employees. */
select Educationfield, count(EmployeeID) as 'Total Employee'
from general_data
where attrition = 'No'
group by Educationfield
order by count(EmployeeID) desc limit 1;

/* 20. List the employees who have worked for the company the longest but haven't had a promotion. */
select dense_rank() over (order by YearsAtCompany desc) as 'Rank', 
		EmployeeID, YearsAtCompany, YearsSinceLastPromotion		
from general_data 
where YearsAtCompany = YearsSinceLastPromotion and attrition = 'No'
order by YearsAtCompany desc