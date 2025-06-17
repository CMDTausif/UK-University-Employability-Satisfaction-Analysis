create database UK_Employability;
use UK_Employability;

select * from uk_employability.ukuniversityemployability;

/* 1. Easy queries */

/* 1.1 List of all unique universities */
select distinct University_Name from uk_employability.ukuniversityemployability;

/* 1.2 Count of total entries per academic year  */
select Academic_Year, count(*) as Total_Entries
from uk_employability.ukuniversityemployability
group by Academic_Year;

/* 1.3 Average salaries by subject area */
select Subject_Area, avg(Avg_Salary_GBP) as Avg_salary
from uk_employability.ukuniversityemployability
group by Subject_Area
order by Avg_salary desc;

/* 1.4 List top 5 courses with highest student satisfaction */
select Course_Name, Student_Satisfaction_Score
from uk_employability.ukuniversityemployability
order by Student_Satisfaction_Score desc
limit 5;

/* 1.5 Total students admitted per region */
select Region, sum(Students_Admitted) as Total_Admitted_Students 
from uk_employability.ukuniversityemployability
group by Region;

/* 1.6 Courses with employment rate above 90%   */
select University_Name, Course_Name, Employment_After_6_Months_prcntge
from uk_employability.ukuniversityemployability
where Employment_After_6_Months_prcntge > 90;



/* Medium queries */
/* 2.1 Top 5 universities by average employment rate */
select University_Name, avg(Employment_After_6_Months_prcntge) as Avg_Employment
from uk_employability.ukuniversityemployability
group by University_Name
order by Avg_Employment desc
limit 5;


/* 2.2 Most common job sectors across the dataset  */
select Top_Job_Sector, count(*) as Sector_count
from uk_employability.ukuniversityemployability
group by Top_Job_Sector
order by Sector_count desc
limit 5;

/* 2.3 Average acceptance and enrolment rate per year (Computer Science) */
select Academic_Year, 
avg(Acceptance_Rate) as Avg_Acceptance_Rate,
avg(Enrolment_Rate) as Avg_Enrolment_Rate
from uk_employability.ukuniversityemployability
where Subject_Area = "Computer Science"
group by Academic_Year;

/* 2.4 Courses with >30% international students and salaries > £35,000 */
select University_Name, Course_Name, Avg_Salary_GBP, International_Students_prcntge 
from uk_employability.ukuniversityemployability
where Avg_Salary_GBP > 35000 
and International_Students_prcntge > 30;

/* 2.5 Universities with employment rate greater than national average */
with Nationalaverage as (
select avg(Employment_After_6_Months_prcntge) as National_Avg
from uk_employability.ukuniversityemployability
)
select ed.University_Name, avg(ed.Employment_After_6_Months_prcntge) as Uni_avg
from uk_employability.ukuniversityemployability ed
group by ed.University_Name
having Uni_avg > (
select National_Avg from Nationalaverage);

/* 2.6 Courses with above-average student satisfaction per subject */
with SubjectAvg as (select Subject_Area, Avg(Student_Satisfaction_Score) as Subject_avg
from uk_employability.ukuniversityemployability
group by Subject_Area)

select 
ed.Course_Name,
ed.Subject_Area,
ed.Student_Satisfaction_Score,
ed.Subject_Area
from uk_employability.ukuniversityemployability ed
join SubjectAvg sa on ed.Subject_Area = sa.Subject_Area
where ed.Student_Satisfaction_Score > sa.Subject_avg;


/* 3. Hard queries*/
/*3.1  Top 3 highest-paid courses per university */
with Ranked as (
    select *, rank() over (partition by University_Name order by Avg_Salary_GBP desc) as Rank_Pos 
    FROM uk_employability.ukuniversityemployability
)
select University_Name, Course_Name, Avg_Salary_GBP 
from Ranked 
where Rank_Pos <= 3;

/* 3.2 Courses with decreasing employment rate over 3 years */
select distinct a.Course_Name
from uk_employability.ukuniversityemployability a
join uk_employability.ukuniversityemployability b
on a.Course_Name = b.Course_Name
and b.Academic_Year = a.Academic_Year + 1
join uk_employability.ukuniversityemployability c 
on a.Course_Name = c.Course_Name 
and c.Academic_Year = a.Academic_Year + 2
where a.Employment_After_6_Months_prcntge > b.Employment_After_6_Months_prcntge 
and b.Employment_After_6_Months_prcntge > c.Employment_After_6_Months_prcntge;
;

/* 3.3  Most gender-balanced courses (ratio closest to 1.0) */
with Balance as (
select Course_Name, University_Name, abs(Male_Female_Ratio - 1) as deviation 
from uk_employability.ukuniversityemployability
)
select Course_Name, University_Name, deviation
from Balance
order by deviation asc
limit 20;

/* 3.4 Universities with the most consistent satisfaction scores */
select University_Name, stddev(Student_Satisfaction_Score) as Satisfaction_STD
from uk_employability.ukuniversityemployability
group by University_Name
order by Satisfaction_STD asc
limit 10
;

/* 3.5 Courses with high satisfaction but high unemployment */
select University_Name, Course_Name, Student_Satisfaction_Score, Unemployment_Rate_prcntge 
from uk_employability.ukuniversityemployability
where Student_Satisfaction_Score > 85 
and Unemployment_Rate_prcntge > 15;

/* 3.6 Calculate correlation approximation between satisfaction and employment */
-- select 
-- (avg(Student_Satisfaction_Score * Employment_After_6_Months_prcntge) 
--    - avg(Student_Satisfaction_Score) * avg(Employment_After_6_Months_prcntge)) 
--   / 
--   (stddev(Student_Satisfaction_Score) * stddev(Employment_After_6_Months_prcntge)) 
-- as Correlation_Coefficient 
-- from uk_employability.ukuniversityemployability;


















  
  






























































