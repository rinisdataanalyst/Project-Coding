select *
from CovidDeaths$
where continent is not null
order by 3, 4

--Select *
--from CovidVaccinations$
--order by 3, 4

-- Select Data that we are going to be use

Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

-- Looking at total cases vs total deaths
Select distinct location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from CovidDeaths$
where location like '%malaysia%'
order by 1,2

-- Looking at total cases vs population
Select distinct location, date, total_cases, population, (total_cases/population)*100 as population_percentage
from CovidDeaths$
-- where location like '%malaysia%'
order by 1,2
-- Looking at country with highest infection rate compared to population

Select distinct location, population, MAX(total_cases) as HighestInfectionRate,  MAX((total_cases/population))*100 as populationinfected_percentage
from CovidDeaths$
group by location, population
order by populationinfected_percentage desc

-- beak things by continent

-- Showing Countries with highest death count per population

Select distinct location,MAX(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths$
where continent is not null
group by location, population
order by Totaldeathcount desc

Select continent,MAX(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths$
where continent is not null
group by continent
order by Totaldeathcount desc

--global number
Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast (new_deaths as int))/ sum(new_cases)*100 as death_percentage
from CovidDeaths$
--where location like '%malaysia%'
where continent is not null
--group by date


--- total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date ) as vaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- cte

WITH CTE AS (Select distinct dea.continent,dea.location,  dea.date,  dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location) as vaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
 )

 select location, population, max(vaccinated/population)*100  as percentage_vaccinated
 from CTE
 group by location, population, vaccinated

 order by population, percentage_vaccinated desc



Select distinct location,MAX(cast(total_deaths as int)) as Totaldeathcount
from CovidDeaths$
where continent is not null
group by location, population
order by Totaldeathcount desc