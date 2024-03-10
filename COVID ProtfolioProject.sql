select * from
Portfolioproject..Covid_Deaths$ WHERE continent is not null 
order by 3,4


select location,date,total_cases,new_cases,total_deaths,population from
Portfolioproject..Covid_Deaths$ 
order by 1,2
	

--looking at total cases vs total deaths
--Shows likelihood of dying if you contrcat covid in your country

select location,date,total_cases,total_deaths, 
 case 
     when try_convert(float,total_cases) is not null and try_convert(float,total_deaths) is not null then
		  (convert(float,total_deaths)/convert(float,total_cases))*100 
     else
		 null end as DeathPercentage	
		 from Portfolioproject..Covid_Deaths$ 
		 where location like '%states%'
		 order by 1,2
	

--looking at total cases vs population
--Shows what percentage of population got covid
	
select location,date,population, total_cases,
 case 
     when try_convert(float,total_cases) is not null and try_convert(float, population) is not null then
		  (convert(float,total_cases)/convert(float,population))*100 
     else
		 null end as InfectedPopulationPercentage
		 from Portfolioproject..Covid_Deaths$ 
		 order by 1,2


--looking at countries with highest infection rate compared to population

SELECT location, population,MAX(total_cases) AS HigestInfectionCount,
    CASE 
        WHEN TRY_CONVERT(float, MAX(total_cases)) IS NOT NULL AND TRY_CONVERT(float, population) IS NOT NULL 
        THEN (CONVERT(float, MAX(total_cases)) / CONVERT(float, population)) * 100 
        ELSE NULL 
    END AS InfectedPopulationPercentage
FROM Portfolioproject..Covid_Deaths$
GROUP BY location,population
ORDER BY InfectedPopulationPercentage desc


--Showing countries with highest deaths per population

select location,max(cast(total_deaths as int)) as TotalDeathCount 
	from Portfolioproject..Covid_Deaths$ 
	where continent is not null
	group by location order by TotalDeathCount desc


--SHOWING CONTINENT WITH TOTAL DEATHS PER POPULATION 

select continent,max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolioproject..Covid_Deaths$ 
where continent is not null
group by continent 
order by TotalDeathCount desc


--GLOBAL NUMBERS

SELECT sum(new_cases) as Total_cases,sum(cast(new_deaths as int)) as Total_deaths , 
		case
		     when sum(new_cases)> 0 
			 then sum(cast(new_deaths as int))/sum(new_cases) * 100
		     else null 
		end as DeathPercentage
from Portfolioproject..Covid_Deaths$
--group by date;
  


  --Looking at Total Population vs Vaccinations 
  --USE CTE 

with PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as

     (select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	       sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location 
               order by dea.location,dea.date) as RollingPeopleVaccinated
from Portfolioproject..Covid_Vac$ vac  join Portfolioproject..Covid_Deaths$ dea
on vac.date=dea.date and dea.location=vac.location
where dea.continent is not null)

Select *,(RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated from PopvsVac

create view PercentPopulationVaccinated as
	        select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
		       sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location 
	                order by dea.location,dea.date) as RollingPeopleVaccinated
                from Portfolioproject..Covid_Vac$ vac  join Portfolioproject..Covid_Deaths$ dea
	        on vac.date=dea.date and dea.location=vac.location
		where dea.continent is not null

Select * from PercentPopulationVaccinated
