/** Covid-19 Data Exploration

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views

**/

-- Select the data we are going to be using
-- List by country and date

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `clever-cortex-407523.covid_project.covid_deaths` 
ORDER BY 1, 2 

-- Total cases vs total deaths, percentage of deaths from total cases
-- Shows percentage chance of death if covid contracted 

SELECT location, date, total_cases, (total_deaths/total_cases) * 100 AS percentage_death
FROM `clever-cortex-407523.covid_project.covid_deaths` 
ORDER BY 1, 2

-- Total cases vs total population, shows what percentage of the total population contracted covid in USA

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS percentage_death
FROM `clever-cortex-407523.covid_project.covid_deaths` 
WHERE location LIKE '%States%'
ORDER BY 1, 2


-- Countries with highest infection rate compared to total population

SELECT location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population) * 100 AS percentage_population_infected
FROM `clever-cortex-407523.covid_project.covid_deaths` 
GROUP BY 1, 2
ORDER BY 4 DESC


-- Countries with highest death count 


SELECT location, MAX(total_deaths) AS total_death_count
FROM `clever-cortex-407523.covid_project.covid_deaths` 
WHERE continent is NOT NULL 
GROUP BY 1
ORDER BY 2 DESC


-- Total death count per continent

SELECT continent, MAX(total_deaths) AS total_death_count
FROM `clever-cortex-407523.covid_project.covid_deaths` 
WHERE continent is NOT NULL
GROUP BY 1
ORDER BY 2 DESC


-- Total global cases, deaths and percentage of population deaths by date

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, ROUND(SUM(new_deaths)/SUM(new_cases) * 100, 2) AS percentage_deaths
FROM `clever-cortex-407523.covid_project.covid_deaths` 
WHERE continent is NOT NULL AND new_cases != 0 AND new_deaths != 0
GROUP BY 1
ORDER BY 1, 2


-- Total global cases, deaths and percentage of deaths to date

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases)) * 100 AS percentage_deaths
FROM `clever-cortex-407523.covid_project.covid_deaths` 
WHERE continent is NOT NULL AND new_cases != 0 AND new_deaths != 0
ORDER BY 1, 28



-- Total population vs vaccinations 
-- Using CTE to perform Calculation on Partition By in previous query

WITH popVSvac AS 
(
SELECT  deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, SUM(vaccs.new_vaccinations) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
FROM `clever-cortex-407523.covid_project.covid_deaths` deaths
JOIN `clever-cortex-407523.covid_project.covid_vaccinations` vaccs
ON deaths.location = vaccs.location AND deaths.date = vaccs.date
WHERE deaths.continent is NOT NULL
--ORDER BY 2, 3
)

SELECT *, ROUND((rolling_people_vaccinated/population) * 100, 2) AS percentage_population_vaccinated
FROM popVSvac


-- Creating view to store data for later visualizations 
 
CREATE VIEW `clever-cortex-407523.covid_project.population_vaccinated` AS

WITH popVSvac AS 
(
SELECT  deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, SUM(vaccs.new_vaccinations) OVER (Partition by deaths.location ORDER BY deaths.location, deaths.date) AS rolling_people_vaccinated
FROM `clever-cortex-407523.covid_project.covid_deaths` deaths
JOIN `clever-cortex-407523.covid_project.covid_vaccinations` vaccs
ON deaths.location = vaccs.location AND deaths.date = vaccs.date
WHERE deaths.continent is NOT NULL
--ORDER BY 2, 3
)

SELECT *, ROUND((rolling_people_vaccinated/population) * 100, 2) AS percentage_population_vaccinated
FROM popVSvac




