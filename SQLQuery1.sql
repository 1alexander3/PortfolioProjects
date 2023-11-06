/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



SELECT * 
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
order by 3,4


--Basic Data to be used
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectCovid..CovidDeaths
order by 1,2


--Looing at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectCovid..CovidDeaths
Where location like '%states%'
order by 1,2


--Looking at the Total Cases vs the Population
--Shows what percentage of Population got Covid
SELECT Location, date, population, total_cases, (total_cases/population)*100 as InfectionPercentagePopulation
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
order by 1,2


--Looking at Countries with highest Infection Rate compared to Population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentagePopulation
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by Location, population
order by InfectionPercentagePopulation DESC



--Showing Countries with the highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by Location, population
order by TotalDeathCount DESC




--CONTENT SECTIONS




--Showing Continents with highest Death Count per Population
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjectCovid..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount DESC




--GLOBAL NUMBERS



--Global Deaths and Death Percentage per Day
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by date
order by 1,2

--Total Global Deaths and Death Percentage
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjectCovid..CovidDeaths
Where continent is not null
order by 1,2



--Total Population vs Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE
--Creating Temp Table
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
--Inserting Data from CovidDeaths and CovidVaccinations tables into PercentPopulationVaccinated
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

--Create new column to calculate percentage of population vaccinated
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating View to store data later for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


--Select all from PercentPopulationVaccinated
Select *
From PercentPopulationVaccinated
