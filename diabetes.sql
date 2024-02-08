-- Crate database
create database diabetes;
use diabetes;

select * from diabetes_prediction;

/*1. Retrieve the Patient_id and ages of all patients. */
select Patient_id, age from diabetes_prediction;

/* 2. Select all female patients who are older than 40. */
select Patient_id, gender, age from diabetes_prediction
where gender = 'Female' and age > 40;

/* 3. Calculate the average BMI of patients. */
select avg(bmi) as 'AVerage bmi' from diabetes_prediction;

/* 4. List patients in descending order of blood glucose levels. */
select Patient_id, blood_glucose_level from diabetes_prediction
order by blood_glucose_level desc;

/* 5. Find patients who have hypertension and diabetes. */
select Patient_id, hypertension, diabetes from diabetes_prediction
where hypertension = 1 and diabetes = 1;

/* 6. Determine the number of patients with heart disease. */
select count(heart_disease) as 'No. of heart_disease' from diabetes_prediction
where heart_disease = 1;

/* 7. Group patients by smoking history and count how many smokers and non-smokers there are. */
select 
	case 
		when smoking_history in ('current', 'former','ever', 'not-current') then 'Smoker'
		when smoking_history in ('never') then 'Non-smoker'
        else 'No info'
	end as smoking_status,
	count(Patient_id) as 'Total Patients'
from diabetes_prediction
group by smoking_status;

/* 8.  Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.*/
select patient_id, bmi from diabetes_prediction
where bmi > 
	(select avg(bmi) as 'average bmi' from diabetes_prediction);

/* 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel. */
(select Patient_id, HbA1c_level from diabetes_prediction
order by HbA1c_level limit 1)
union all
(select Patient_id, HbA1c_level from diabetes_prediction
order by HbA1c_level desc limit 1);

/* 10. Calculate the age of patients in years (assuming the current date as of now). */
/* Note:
		Date of birth is not given) */
select patient_id, age from diabetes_prediction;

/* 11. Rank patients by blood glucose level within each gender group. */
select rank() over (partition by gender order by blood_glucose_level) as patient_rank, patient_id, Gender, blood_glucose_level 
from diabetes_prediction
order by patient_rank;

/* 12. Update the smoking history of patients who are older than 50 to "Ex-smoker." */
update diabetes_prediction set smoking_history =  'Ex-smoker' 
where age > 50;

select Patient_id, age, smoking_history
from diabetes_prediction
where smoking_history = 'Ex-smoker' and age > 50;

/* 13. Insert a new patient into the database with sample data. */
insert into diabetes_prediction values ('Dhivesh', 'PT100101', 'Male', 40, 0, 0, 'never', 16.25, 7.1, 88, 0);

select * from diabetes_prediction where patient_id = 'PT100101';

/* 14. Delete all patients with heart disease from the database. */
delete from diabetes_prediction where heart_disease = 1;

select * from diabetes_prediction;

/* 15. Find patients who have hypertension but not diabetes using the EXCEPT operator. */
select patient_id, hypertension, diabetes
from diabetes_prediction
where hypertension = 1 and diabetes = 0;

/* 16. Define a unique constraint on the "patient_id" column to ensure its values are unique. */
alter table diabetes_prediction 
add constraint patient_id unique (patient_id(255));

/* 17. Create a view that displays the Patient_ids, ages, and BMI of patients. */
create view test as (select Patient_id, age, bmi from diabetes_prediction);
select * from test;

/* 18. Suggest improvements in the database schema to reduce data redundancy and improve data integrity
Normalization:
	Break down large tables into smaller, related tables to eliminate redundant data.
Use primary keys and foreign keys to establish relationships between tables.
Avoiding Redundant Data:
	Eliminate duplicate information by breaking data into separate tables.
For example, create a separate table for customer details and link it to orders using customer IDs. */

/* 19. Explain how you can optimize the performance of SQL queries on this dataset.
	To optimize SQL queries on a dataset, focus on indexing, query structure, 
and avoiding functions in the WHERE clause. */ 

