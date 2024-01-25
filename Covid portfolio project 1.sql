SELECT*
FROM CovidDeaths
ORDER BY 3,4

SELECT*
FROM CovidVaccinations
ORDER BY 3,4

--Select data we are going to be using
SELECT Location,date, total_cases, new_cases, total_deaths,population
FROM CovidDeaths
WHERE Continent is not null
ORDER BY 1,2

--Looking at total cases vs total deaths
--shows likelihood of dying in the country 'Nigeria'
SELECT Location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as deathspercentage
FROM CovidDeaths
WHERE Location like'%Nigeria%'
ORDER BY 1,2

--Looking at the total cases vs population
--Shows what percentage of x got covid
SELECT Location,date, population, total_cases,(Total_cases/x)*100 as percentofpopulationinfected
FROM CovidDeaths
--WHERE Location like'%Nigeria%'
WHERE Continent is not null
ORDER BY 1,2

--Looking at countries with Highest Infection Rate compared to population
SELECT continent, x, MAX(total_cases)as highestInfectioncount,MAX((Total_cases/x))*100 as percentofpopulationinfected
FROM CovidDeaths
--WHERE Location like'%Nigeria%
WHERE Continent is not null
GROUP BY  continent, x
ORDER BY Percentofpopulationinfected DESC


--showing the countries with the highest death count compared per population
SELECT Location,x, MAX(CAST(Total_deaths as int))as Totaldeathcount
FROM CovidDeaths
--WHERE Location like'%Nigeria%
WHERE Continent is not null
GROUP BY Location,x
ORDER BY Totaldeathcount DESC


--showing the continent with the highest death count compared per population
SELECT continent, MAX(CAST(Total_deaths as int))as Totaldeathcount
FROM CovidDeaths
--WHERE Location like'%Nigeria%
WHERE Continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC

--let's beak things down by continent
SELECT continent, SUM(CAST(new_deaths as int))as Totaldeathcount
FROM CovidDeaths
--WHERE Location like'%Nigeria%
WHERE Continent is not null
GROUP BY continent


-- GLOBAL NUMBERS
SELECT  SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as totaldeath, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as deathspercentage
FROM CovidDeaths
--WHERE Location like'%Nigeria%'
WHERE continent is not null
ORDER BY 1,2


--showings join of the 2 tables  covidvaccinations and coviddeaths

SELECT*
FROM CovidDeaths
join CovidVaccinations
   ON CovidDeaths.location=covidVaccinations.location
   and CovidDeaths.date=covidVaccinations.date

--Looking at Total Population vs Vaccinations
SELECT dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations
FROM CovidDeaths dea
join CovidVaccinations Vac
   ON dea.location=Vac.location
   and dea.date=Vac.date
   WHERE dea.continent is not null
 ORDER BY 2,3

-- showing Rolling count of new vaccinations using the partition by, windows function
SELECT dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations,SUM(CONVERT( int, vac.new_vaccinations ))
OVER (PARTITION BY dea.location order by dea.location,dea.Date) as RollingpeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations Vac
   ON dea.location=Vac.location
   and dea.date=Vac.date
   WHERE dea.continent is not null
 ORDER BY 2,3

 --using CTEs
 --using Rollingpeoplevaccinated and population to show the rollingpeoplevaccinated percent
WITH popvsvac(continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated) 
 as
 (
SELECT dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations,SUM(CONVERT( int, vac.new_vaccinations ))
OVER (PARTITION BY dea.location order by dea.location,dea.Date) as RollingpeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations Vac
   ON dea.location=Vac.location
   and dea.date=Vac.date
   WHERE dea.continent is not null
 --ORDER BY 2,3
)
SELECT*, (Rollingpeoplevaccinated/population)*100
FROM popvsvac

--Temp Table
DROP TABLE if Exists #percentpopulationvaccinated 
CREATE TABLE #percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)
INSERT INTO #percentpopulationvaccinated
SELECT dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations,SUM(CONVERT( int, vac.new_vaccinations ))
OVER (PARTITION BY dea.location order by dea.location,dea.Date) as RollingpeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations Vac
   ON dea.location=Vac.location
   and dea.date=Vac.date
   WHERE dea.continent is not null
 --ORDER BY 2,3
SELECT*, (Rollingpeoplevaccinated/population)*100
FROM #percentpopulationvaccinated

--view set aside
--creating view for percentpopulationVaccinated
CREATE VIEW percentpopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.Population, vac.new_vaccinations,SUM(CONVERT( int, vac.new_vaccinations ))
OVER (PARTITION BY dea.location order by dea.location,dea.Date) as RollingpeopleVaccinated
FROM CovidDeaths dea
join CovidVaccinations Vac
   ON dea.location=Vac.location
   and dea.date=Vac.date
   WHERE dea.continent is not null
--order by 2,3

--creating view for global number

CREATE VIEW GlobalNumber as
SELECT  SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as totaldeath, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 as deathspercentage
FROM CovidDeaths
--WHERE Location like'%Nigeria%'
WHERE continent is not null
--ORDER BY 1,2

SELECT*
FROM GlobalNumber

CREATE VIEW joinsofcoviddeathandcovidvaccinations as
SELECT dea.continent,dea.date, dea.location, vac.new_tests
FROM CovidDeaths dea
join CovidVaccinations vac
   ON dea.location=vac.location
   and Dea.date=Vac.date

CREATE VIEW Totaldeathcount as
SELECT continent, SUM(CAST(new_deaths as int))as Totaldeathcount
FROM CovidDeaths
--WHERE Location like'%Nigeria%
WHERE Continent is not null
GROUP BY continent





























 



 
 








































