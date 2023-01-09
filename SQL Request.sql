-- Let's look at our tables. I use 'rownum <= 1' to not to load DB too much
Select * From EMPLOYEES 
Where rownum <= 1;
Select * From COUNTRIES
Where rownum <= 1;
Select * From DEPARTMENTS 
Where rownum <= 1;
Select * From LOCATIONS
Where rownum <= 1;

-- Uniting necessary data from 4 tables and then create our table
Create table AZ_PORTF as
Select a.First_name || ' ' || a.Last_name as Full_name, a.Hire_Date, d.Country_name, c.City, c.Street_address,
b.Department_name, a.Salary,
Round(a.Salary/Sum(a.Salary) Over(Partition by b.Department_name)*100, 1) as Percent_Salary_by_Department,
a.Employee_id, a.Manager_id, b.Department_id, b.Location_id, c.Country_id
From EMPLOYEES a
Left Outer Join DEPARTMENTS b on a.Department_id = b.Department_id
Left Outer Join LOCATIONS c on b.Location_id = c.Location_id
Left Outer Join COUNTRIES d on c.Country_id = d.Country_id

-- Looking for nulls what we'd replace by relevant values for the following calculations
Select * From AZ_PORTF
Where Department_name is null

-- Kimberely Grant has missing data in several columns but the main column for us's 'Department_name'. He has Manager_id = 149
Select * From AZ_PORTF
Where Manager_id = 149

-- Other employees with Manager_id = 149 have Department_name = Sales and Department_id = 80. Let's fill our nulls
Update AZ_PORTF
set Department_name = 'Sales',
Department_id = 80
Where Manager_id = 149;
Commit

Select * From AZ_PORTF
-- Export into Excel file