SELECT location, `date`, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY location, `date`;

-- explore total cases vs total deaths

#increase no. of decimals division
SET div_precision_increment = 8;

#Shows likelihood of dying if you contract covid
SELECT location, `date`, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 5) AS lethality_rate_in_perc
FROM covid_deaths
WHERE location = 'United States'
ORDER BY location, `date`;

-- explore total cases vs population
# what perc of population got covid
SELECT location, `date`, total_cases, population, ROUND((total_cases/population)*100, 5) AS infection_rate_in_perc
FROM covid_deaths
WHERE location = 'United States'
ORDER BY location, `date`;


# check what percent of population got infected for latest entry for each location
WITH day_rank AS
(
SELECT *, RANK() OVER(PARTITION BY location ORDER BY location, `date` DESC) AS day_num
FROM covid_deaths
)
SELECT location, `date`, total_cases, population, ROUND((total_cases/population)*100, 5) AS infection_rate_in_perc
FROM day_rank
WHERE day_num = 1
ORDER BY infection_rate_in_perc DESC;

# check highest infection rate per country
SELECT location, MAX(total_cases) AS highest_infection_count, population, MAX(ROUND((total_cases/population)*100, 5)) AS infection_rate_in_perc
FROM covid_deaths
GROUP BY location, population
ORDER BY infection_rate_in_perc DESC;

-- explore highest death count per pop.
SELECT location, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY location
ORDER BY total_death_count DESC;

SELECT *
FROM covid_deaths;

-- Breaking things by continent
#incorrect way
SELECT continent, MAX(total_deaths) AS total_death_count
FROM covid_deaths
WHERE continent != ''
GROUP BY continent
ORDER BY total_death_count DESC;

# Summing total deaths per country
WITH max_deaths AS
(
SELECT continent, location, MAX(total_deaths) AS max_death_per_country
FROM covid_deaths
WHERE continent != ''
GROUP BY continent, location
)
SELECT continent, SUM(max_death_per_country) AS death_sum_per_country
FROM max_deaths
GROUP BY continent
ORDER BY 2 DESC;

# crosschecking with OWID entries
SELECT location, MAX(total_deaths) AS owid_death_sum_per_country
FROM covid_deaths
WHERE continent = ''
GROUP BY location
ORDER BY 2 DESC;

# Comparing via join
SELECT *
FROM 
(# Table1 as query
	WITH max_deaths AS
	(
	SELECT continent, location, MAX(total_deaths) AS max_death_per_country
	FROM covid_deaths
	WHERE continent != ''
	GROUP BY continent, location
	)
	SELECT continent, SUM(max_death_per_country) AS death_sum_per_country
	FROM max_deaths
	GROUP BY continent
	ORDER BY 2 DESC
) AS table1
RIGHT JOIN
(# Table2 as query
	SELECT location, MAX(total_deaths) AS owid_death_sum_per_country
	FROM covid_deaths
	WHERE continent = ''
	GROUP BY location
	ORDER BY 2 DESC
) AS table2
	ON table1.death_sum_per_country = table2.owid_death_sum_per_country
ORDER BY table2.owid_death_sum_per_country DESC
;
# confirms that table1 (manual sum of total deaths based on records) match with owid entries

-- GLOBAL NUMBERS
WITH global_stats_table AS
(
	SELECT `date`, SUM(new_cases) AS new_cases_global, SUM(total_cases) AS total_cases_global, SUM(new_deaths) AS new_deaths_global, SUM(total_deaths) AS total_deaths_global
	FROM covid_deaths
	WHERE continent != ''
	GROUP BY `date`
	ORDER BY `date`
)
SELECT *, ROUND(((total_deaths_global/total_cases_global)*100), 6) AS lethality_rate_global, ROUND(((new_deaths_global/new_cases_global)*100), 6) AS new_rate_global
FROM global_stats_table
;

--

SELECT *
FROM covid_vaccinations;


WITH PopVsVac (continent, location, `date`, population, new_vaccinations, total_vax_rolling) 
AS
(
SELECT death.continent, death.location, death.`date`, death.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER(PARTITION BY death.location ORDER BY death.location, death.`date`) AS total_vax_rolling
FROM covid_deaths AS death
JOIN covid_vaccinations AS vax
	ON death.location = vax.location
    AND death.`date` = vax.`date`
WHERE death.continent != ''
ORDER BY death.location, death.`date`
)
SELECT PopVsVac.continent, PopVsVac.location, PopVsVac.`date`, PopVsVac.population, PopVsVac.new_vaccinations, PopVsVac.total_vax_rolling, covid_vaccinations.total_vaccinations
FROM PopVsVac
JOIN covid_vaccinations
	ON PopVsVac.location = covid_vaccinations.location
    AND PopVsVac.`date` = covid_vaccinations.`date`
;

-- create view for visualization
# CREATE VIEW view_name AS ( insert query );