use [Portfolio Project]
select *
from ['covid deaths$']
where continent is not null
order by 3,4

select *
from ['covid vaccinations$']
order by 3,4

--select data that we are going to be using

select Location,date,total_cases, new_cases_per_million, total_deaths, population
From ['covid deaths$']
order by 1,2

-- looking at Total Cases vs Total Deaths
--Show Likelihood of dying if you contract covind in your country
select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From ['covid deaths$']
where location like '%states%'
order by 1,2

--Looking at Total Cases vs Population
--shows what percentage of population get covid
select Location,date,total_cases,population, (total_cases/population)*100 as ContractionPercentage
From ['covid deaths$']
where location like '%states%'
order by 1,2

--Looking at Countries with Higest Infection Rate compared to Population
select Location,population,MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
From ['covid deaths$']
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
From ['covid deaths$']
where continent is not null
group by location
order by TotalDeathCount Desc

--Let's Break things down by Continent
--Showing  Continents with the Highest death counts per population
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From ['covid deaths$']
where continent is not null
group by location
order by TotalDeathCount Desc

--GLOBAL NUMBERS
select sum(new_cases_smoothed) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases_smoothed)*100 as DeathPercentage-- total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From ['covid deaths$']
where continent is not null
--group by date
order by 1,2

--Looking at Total Population vs new_Vaccinations
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER(PARTITION BY dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
from [Portfolio Project]..['covid deaths$'] dea
join [Portfolio Project]..['covid vaccinations$'] vac
	on dea.location =vac.location
	and dea.date= vac.date
	where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER(PARTITION BY dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
from [Portfolio Project]..['covid deaths$'] dea
join [Portfolio Project]..['covid vaccinations$'] vac
	on dea.location =vac.location
	and dea.date= vac.date
	where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100 as PercentageofPopulationVaccinated
from PopvsVac

--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated --to drop already existing table in case you want to make a new view with changes as table exists in database
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255) ,
Location nvarchar(255) ,
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER(PARTITION BY dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
from [Portfolio Project]..['covid deaths$'] dea
join [Portfolio Project]..['covid vaccinations$'] vac
	on dea.location =vac.location
	and dea.date= vac.date
	--where dea.continent is not null
--order by 2,3
select *,(RollingPeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated



--Creating view to store data for later visualizations
drop view if exists PercentPopulationVaccinated
Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER(PARTITION BY dea.location order by dea.location,dea.date) as rollingPeopleVaccinated
from [Portfolio Project]..['covid deaths$'] dea
join [Portfolio Project]..['covid vaccinations$'] vac
	on dea.location =vac.location
	and dea.date= vac.date
where dea.continent is not null
--order by 2,3


select*
from PercentPopulationVaccinated



