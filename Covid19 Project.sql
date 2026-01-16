select * from CovidDeaths
select * from CovidVaccinations 

 
-- we will clean the data 
--When analyzing the dataset we usually remove aggregate rows like World, Asia, and Europe to avoid skewing results.

SELECT * 
FROM CovidDeaths 
WHERE continent IS NULL;

DELETE FROM CovidDeaths 
WHERE continent IS NULL;


-- FORMULATING IMPORTANT KPI's

-- 1)-What is the death rate % in each of the country i.e how deadly is COVID 19

SELECT location,
    MAX(total_cases) AS TotalCases,
    MAX(total_deaths) AS TotalDeaths,
    (MAX(total_deaths) * 100.0 / MAX(total_cases)) AS Deathratepct
FROM CovidDeaths
GROUP BY location
ORDER BY Deathratepct DESC;

-- shows us countries with underdeveloped healthcare systems tend to struggle with resource allocation,
--patient care, and crisis response. 

--2)-Top 10 Countries by Deaths
 select top 10 location,
    max(total_deaths) as totaldeaths
    from covidDeaths 
    GROUP BY location 
    ORDER BY totaldeaths DESC;

-- The data reveals that the United States ranks highest in terms of total COVID?19 deaths
--followed closely by Brazil and India.
--This highlights the immense toll the pandemic has taken on large
--densely populated nations with diverse healthcare challenges


--3)-Infection Rate Relative to Population( finding out the spread of covid )
SELECT 
    location,
    population,
    MAX(total_cases) AS TotalCases,
    (MAX(total_cases) * 100.0 / population) AS InfectionRatePercent
FROM CovidDeaths
GROUP BY location, population
ORDER BY InfectionRatePercent DESC;

--Most of the entries are European (Cyprus, San Marino, Austria). This suggests Europe had widespread testing/reporting and high case penetration
--- Many of these are small nations or territories (San Marino, Gibraltar, Faeroe Islands, Brunei). In smaller populations, even moderate case numbers translate into very high percentages


--4)-Daily Growth Trends
SELECT location,date,new_cases,SUM(new_cases) OVER (PARTITION BY location ORDER BY date) AS Runningtotalcases
FROM CovidDeaths
ORDER BY location, date;


--5)-Vaccination Coverage
SELECT
    d.location,
    d.population,
    MAX(v.people_vaccinated) AS Peoplevaccinated,
    (MAX(v.people_vaccinated) * 100.0 / d.population) AS VaccinationPCT
FROM CovidDeaths d
JOIN CovidVaccinations v
    ON d.location = v.location 
GROUP BY d.location, d.population
ORDER BY VaccinationPCT DESC;

--6)-Fully Vaccinated %
SELECT
    d.location,
    d.population,
    MAX(v.people_fully_vaccinated) AS FullyVaccinated,
    ROUND((MAX(v.people_fully_vaccinated) * 100.0 / d.population),2) AS FullyVaccinatedPercent
FROM CovidDeaths d
JOIN CovidVaccinations v
    ON d.location = v.location 
GROUP BY d.location, d.population 
ORDER BY FullyVaccinatedPercent DESC;

--7)-Countries Ordered by Mortality Rate
SELECT location,
    MAX(total_deaths) AS Totaldeaths,
    RANK() OVER (ORDER BY MAX(total_deaths) DESC) AS ranking
FROM CovidDeaths
GROUP BY location;

--8)- avg cases 
SELECT DISTINCT(location),date,new_cases,
    AVG(new_cases) OVER (
            PARTITION BY location 
            ORDER BY date 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ) AS weelyuDayAvg
FROM CovidDeaths;


--9)-- High Case but Low Immunization
WITH InfectionData AS (
    SELECT location,
           population,
           MAX(total_cases) AS TotalCases,
           MAX(total_cases) * 100.0 / population AS InfectionRatePCT
    FROM CovidDeaths
    GROUP BY location, population),

VaccinationData AS (
    SELECT location,
           MAX(people_vaccinated) AS Peoplevaccinated
    FROM CovidVaccinations
    GROUP BY location)

SELECT i.location,i.InfectionRatePCT,v.Peoplevaccinated
FROM InfectionData i
JOIN VaccinationData v ON i.location = v.location
WHERE v.Peoplevaccinated < i.population * 0.5
ORDER BY i.InfectionRatePCT DESC;




-- INDIA SPECIFIC KPI's
--1)-Death Rate % 
SELECT MAX(total_cases) AS TotalCases,MAX(total_deaths) AS TotalDeaths,
(MAX(total_deaths) * 100.0 / MAX(total_cases)) AS Deathratepct
FROM CovidDeaths
WHERE location = 'India';


--2)-Total COVID Deaths
SELECT MAX(total_deaths) AS TotalDeaths_India
FROM CovidDeaths
WHERE location = 'India';

--3)-Total COVID Cases
SELECT MAX(total_cases) AS TotalCases_India
FROM CovidDeaths
WHERE location = 'India';

--4)-Peak Daily COVID?19 Case Counts
SELECT TOP 1 date,new_cases
FROM CovidDeaths
WHERE location = 'India'
ORDER BY new_cases DESC;




select * from CovidDeaths



