/*

Queries used for Tableau Project

*/

-- 1. 


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Protfolioproject..Covid_Deaths$
where continent is not null 




--2

select continent,sum(cast(total_deaths as int)) as TotalDeathCount
from Protfolioproject..Covid_Deaths$
where continent is  not null and 
location not in ('High income','Low income','Upper middle income','Lower middle income''World','International','European Union')
group by continent
order by TotalDeathCount desc




--3


select location,population,max(total_cases) as HighestInfectionCont,max(total_cases)/population *100 as PercentPopulationInfected
from Protfolioproject..Covid_Deaths$
group by location,population
order by PercentPopulationInfected desc


--4


select location,population,date,max(total_cases) as HighestInfectionCont,max(total_cases)/population *100 as PercentPopulationInfected
from Protfolioproject..Covid_Deaths$
group by location,population,date
order by PercentPopulationInfected desc

















