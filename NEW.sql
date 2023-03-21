create database india_census;
use india_census;
select * from data1;
select * from data2;
-- no of rows in our dataset--
select count(*) from data1;
-- 640 rows --
select count(*) from data2;
-- 640 rows--

-- data for only Himachal Pradesh and Uttarakhand--
select * from data1 where State='Himachal Pradesh' or State='Uttarakhand';
select * from data2 where State='Himachal Pradesh' or State='Uttarakhand';

-- Total Population of India--
select sum(Population) from data2;
-- 1210854977--

-- avg growth--
select avg(growth)*100 as avg_growth from data1;
-- 19.26 --

-- avg growth by state and district--
select State,district, round(avg(Growth)*100,2)  as avg_growth from data1 group by 
State,district order by avg_growth desc;

-- avg sex ratio by state and district--
select State,district, round(avg(sex_ratio),0) as avg_sex_ratio from data1 group by 
State,district order by avg_sex_ratio desc;
-- top 3--
select State,district, round(avg(sex_ratio),0) as avg_sex_ratio from data1 group by 
State,district order by avg_sex_ratio desc limit 3;


-- top and bottom districts with highest and lowest avg literacy rate--
with cte as(select State,district, avg(literacy) as avg_literacy
from data1 group by state,district order by avg_literacy desc),cte2 as
(select state, district , avg_literacy, dense_rank() over (order by avg_literacy desc )as top_rnk,
dense_rank() over (order by avg_literacy asc )as bottom_rnk 
from cte)
select state, district , avg_literacy from cte2 where top_rnk=1 or bottom_rnk=1;
-- Madhya Pradesh -- AlirajPur-- 36.1--
-- Mizoram -- Sercchip-- 97.91--


-- States starting with letter A--
select * from data1 where state like "A%";

select * from data1;
select * from data2;
select * from data3;

-- joining data1 and data2 tables--
select data1.*, data2.population from data1 join data2 on data1.district=data2.district;

-- we will derive number of males and females using sex ratio and population--
-- females/males= sex ratio ---1
-- females+males = population---2
-- from equation 2 ----females= population-males (put this in equation 1)
-- population- males = sex ratio * males
-- population = males(sex ratio +1)
-- males = population/(sex ratio +1)----------MALES
-- females = population - population/(sex ratio +1)
--         = population (1-(1/(sex ratio +1))
--         = population * (sex ratio/sex ratio +1)---------FEMALES
with cte as(select data1.district
,data1.state,data1.growth,data1.sex_ratio/1000 as sex_ratio1,  data2.population from data1 join data2 
on data1.district=data2.district)
select district, state ,population, round(population/(sex_ratio1 +1),0) as males , 
round((population * sex_ratio1)/(sex_ratio1 +1),0) as females from cte order by state, district;



-- state level male and female population--
with cte as(select data1.district
,data1.state,data1.growth,data1.sex_ratio/1000 as sex_ratio1,  data2.population from data1 join data2 
on data1.district=data2.district), cte2 as
(select district, state ,population, round(population/(sex_ratio1 +1),0) as males , 
round((population * sex_ratio1)/(sex_ratio1 +1),0) as females from cte order by state, district)
select state, sum(males) as population_male, sum(females) as population_females from cte2 group by state
order by state;

-- highest population in which state and district?--
select district, state, population from  data2 order by population desc;

-- state with respective growth rates--
select State, round(avg(Growth)*100,2)  as avg_growth from data1 group by 
State order by avg_growth desc;

-- state with respective sex ratio--
select State, round(avg(sex_ratio),0) as avg_sex_ratio from data1 group by 
State order by avg_sex_ratio desc;

-- state with respective literacy rates--
select State, round(avg(literacy),2) as avg_literacy
from data1 group by state order by avg_literacy desc;


-- To find number of literate and illeterate people--
-- number of literates/population = literacy rate
-- number of literates= literacy rate * population
select data1.district
,data1.state, round(data1.literacy/100,2) as literacy_,  data2.population, 
round(round(data1.literacy/100,2)*data2.population,0) as number_of_literates,
data2.population-(round(round(data1.literacy/100,2)*data2.population,0)) as number_of_illiterates
 from data1 join data2 
on data1.district=data2.district order by state;



-- TO FIND POPULATION BEFORE CENSUS 2011--
-- (pop after-pop before)/pop before = growth rate
-- pop after/pop before = growth rate +1
-- pop before = pop after/(growth rate+1)

with cte as(select data1.*,  data2.population from data1 join data2 
on data1.district=data2.district)
select district, state, growth , population as population_after,  round(population/(growth+1),0) as 
population_before
from cte order by state;

with cte as(select data1.*,  data2.population from data1 join data2 
on data1.district=data2.district),cte2 as
(select district, state, growth , population as population_after,  round(population/(growth+1),0) as 
population_before
from cte order by state)
select state, sum(population_before) as population_before, sum(population_after) as population_after
from cte2 group by state order by state;



-- Top 3 districts from each state having highest literacy rate--
with cte as(select state, district, literacy, dense_rank() over (partition by state order by literacy desc)
 as rnk from data1 order by state)
 select state, district, literacy from cte where rnk in(1,2,3);































