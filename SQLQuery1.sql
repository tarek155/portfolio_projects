-- Exploring covid_deaths dataset

select *
from covid_data_exploration..CovidDeaths_edited$

select location, date, total_cases, new_cases, total_deaths, population
from covid_data_exploration..CovidDeaths_edited$

-- looking at total cases vs total deaths

select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from covid_data_exploration..CovidDeaths_edited$

-- shows likelihood of dying if you get corona virus in your country

select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage 
from covid_data_exploration..CovidDeaths_edited$
where location like '%egypt%'

-- total cases vs population
select  location, date, population, total_cases, (total_cases/population)*100 as infection_percentage_per_population 
from covid_data_exploration..CovidDeaths_edited$
where location like '%egypt%'

-- looking at countries with highest infection rate

select  location, population, max(total_cases) as highest_infection_rate
from covid_data_exploration..CovidDeaths_edited$
group by location, population
order by location

select  location, sum(total_cases) as highest_infection_rate
from covid_data_exploration..CovidDeaths_edited$
group by location
order by highest_infection_rate desc

select  location, date, max(total_cases) as highest_infection_rate
from covid_data_exploration..CovidDeaths_edited$
where location like '%egypt%'
group by location, date
order by highest_infection_rate desc

-- total death count

select location, max(total_deaths) as total_deaths_per_country
from covid_data_exploration..CovidDeaths_edited$
where total_deaths is not null
group by location
order by location



-- Exploring CovidVaccination dataset

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations_smoothed
from covid_data_exploration..CovidDeaths_edited$ as dea
join covid_data_exploration..CovidVaccination$ as vac
on dea.location = vac.location
and dea.date = vac.date


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From covid_data_exploration..CovidDeaths_edited$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From covid_data_exploration..CovidDeaths_edited$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_data_exploration..CovidDeaths_edited$
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covid_data_exploration..CovidDeaths_edited$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

