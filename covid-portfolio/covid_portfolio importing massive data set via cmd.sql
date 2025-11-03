-- importing massive data set

# Guide here https://www.youtube.com/watch?v=Lp4oYETR9v4&t=890s

# 1. Creating table
CREATE TABLE covid_deaths
(iso_code VARCHAR(10), #A
continent VARCHAR(20), #B
location VARCHAR(50), #C
`date` DATE NULL, #D
population BIGINT NULL, #E
total_cases BIGINT NULL, #F
new_cases INT NULL, #G
new_cases_smoothed DOUBLE NULL, #H
total_deaths INT NULL, #I
new_deaths INT NULL, #J
new_deaths_smoothed DOUBLE NULL, #K
total_cases_per_million DOUBLE NULL, #L
new_cases_per_million DOUBLE NULL, #M
new_cases_smoothed_per_million DOUBLE NULL, #N
total_deaths_per_million DOUBLE NULL, #O
new_deaths_per_million DOUBLE NULL, #P
new_deaths_smoothed_per_million DOUBLE NULL, #Q
reproduction_rate DOUBLE NULL, #R
icu_patients INT NULL, #S
icu_patients_per_million DOUBLE NULL, #T
hosp_patients INT NULL, #U
hosp_patients_per_million DOUBLE NULL, #V
weekly_icu_admissions DOUBLE NULL, #W
weekly_icu_admissions_per_million DOUBLE NULL, #X
weekly_hosp_admissions DOUBLE NULL, #Y
weekly_hosp_admissions_per_million DOUBLE NULL #Z
);

CREATE TABLE covid_deaths_txt
(iso_code VARCHAR(10), #A
continent VARCHAR(20), #B
location VARCHAR(50), #C
`date` DATE NULL, #D
population VARCHAR(50) NULL, #E
total_cases VARCHAR(50) NULL, #F
new_cases VARCHAR(50) NULL, #G
new_cases_smoothed VARCHAR(50) NULL, #H
total_deaths VARCHAR(50) NULL, #I
new_deaths VARCHAR(50) NULL, #J
new_deaths_smoothed VARCHAR(50) NULL, #K
total_cases_per_million VARCHAR(50) NULL, #L
new_cases_per_million VARCHAR(50) NULL, #M
new_cases_smoothed_per_million VARCHAR(50) NULL, #N
total_deaths_per_million VARCHAR(50) NULL, #O
new_deaths_per_million VARCHAR(50) NULL, #P
new_deaths_smoothed_per_million VARCHAR(50) NULL, #Q
reproduction_rate VARCHAR(50) NULL, #R
icu_patients VARCHAR(50) NULL, #S
icu_patients_per_million VARCHAR(50) NULL, #T
hosp_patients VARCHAR(50) NULL, #U
hosp_patients_per_million VARCHAR(50) NULL, #V
weekly_icu_admissions VARCHAR(50) NULL, #W
weekly_icu_admissions_per_million VARCHAR(50) NULL, #X
weekly_hosp_admissions VARCHAR(50) NULL, #Y
weekly_hosp_admissions_per_million VARCHAR(50) NULL #Z
);

#2. Find MySql bin file path, for this PC we have
# C:\Program Files\MySQL\MySQL Server 8.0\bin
#3. Open cmd (non-admin), type cd C:\Program Files\MySQL\MySQL Server 8.0\bin (cd 'filepath')
#4. type mysql -u root -p (root is your username) and enter password
#5. type SET GLOBAL local_infile=1;
#6. type quit;
#7. type mysql --local-infile=1 -u root -p
#8. type show databases;
#9. choose database and type USE chosen_database;
#10. type SHOW TABLES;
#11. type the ff.
# LOAD DATA LOCAL INFILE 'fullpath\\file.csv'
# INTO TABLE tablename
# FIELDS TERMINATED BY ','
# ENCLOSED BY '"'
# LINES TERMINATED BY '\r\n\' IGNORE 1 ROWS;
# note: replace single backslashes in file path with double backslashes

### copy-pasteable command
LOAD DATA LOCAL INFILE 'C:\\Users\\andre\\OneDrive\\Documents\\MySQL Space\\Data Folder\\CovidDeaths.csv'
INTO TABLE covid_deaths_txt
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SELECT *
FROM covid_deaths_txt;

### getting column names
SELECT *
FROM information_schema.columns
WHERE `TABLE_NAME` = 'covid_deaths_txt'
	AND `ORDINAL_POSITION` >= 5
    AND IS_NULLABLE = 'YES'
ORDER BY `ORDINAL_POSITION`;

# Generating query to update all blanks to null for desired columns
SELECT CONCAT('UPDATE covid_deaths_txt SET ', `COLUMN_NAME`, ' = NULL WHERE ', `COLUMN_NAME`, ' = '''';')
FROM information_schema.columns
WHERE `TABLE_NAME` = 'covid_deaths_txt'
	AND `ORDINAL_POSITION` >= 5
    AND IS_NULLABLE = 'YES'
ORDER BY `ORDINAL_POSITION`;

# running query generated
UPDATE covid_deaths_txt SET population = NULL WHERE population = '';
UPDATE covid_deaths_txt SET total_cases = NULL WHERE total_cases = '';
UPDATE covid_deaths_txt SET new_cases = NULL WHERE new_cases = '';
UPDATE covid_deaths_txt SET new_cases_smoothed = NULL WHERE new_cases_smoothed = '';
UPDATE covid_deaths_txt SET total_deaths = NULL WHERE total_deaths = '';
UPDATE covid_deaths_txt SET new_deaths = NULL WHERE new_deaths = '';
UPDATE covid_deaths_txt SET new_deaths_smoothed = NULL WHERE new_deaths_smoothed = '';
UPDATE covid_deaths_txt SET total_cases_per_million = NULL WHERE total_cases_per_million = '';
UPDATE covid_deaths_txt SET new_cases_per_million = NULL WHERE new_cases_per_million = '';
UPDATE covid_deaths_txt SET new_cases_smoothed_per_million = NULL WHERE new_cases_smoothed_per_million = '';
UPDATE covid_deaths_txt SET total_deaths_per_million = NULL WHERE total_deaths_per_million = '';
UPDATE covid_deaths_txt SET new_deaths_per_million = NULL WHERE new_deaths_per_million = '';
UPDATE covid_deaths_txt SET new_deaths_smoothed_per_million = NULL WHERE new_deaths_smoothed_per_million = '';
UPDATE covid_deaths_txt SET reproduction_rate = NULL WHERE reproduction_rate = '';
UPDATE covid_deaths_txt SET icu_patients = NULL WHERE icu_patients = '';
UPDATE covid_deaths_txt SET icu_patients_per_million = NULL WHERE icu_patients_per_million = '';
UPDATE covid_deaths_txt SET hosp_patients = NULL WHERE hosp_patients = '';
UPDATE covid_deaths_txt SET hosp_patients_per_million = NULL WHERE hosp_patients_per_million = '';
UPDATE covid_deaths_txt SET weekly_icu_admissions = NULL WHERE weekly_icu_admissions = '';
UPDATE covid_deaths_txt SET weekly_icu_admissions_per_million = NULL WHERE weekly_icu_admissions_per_million = '';
UPDATE covid_deaths_txt SET weekly_hosp_admissions = NULL WHERE weekly_hosp_admissions = '';
UPDATE covid_deaths_txt SET weekly_hosp_admissions_per_million = NULL WHERE weekly_hosp_admissions_per_million = '';

# copying into table with desired data type
INSERT INTO covid_deaths
SELECT *
FROM covid_deaths_txt;


SELECT *
FROM covid_deaths;

# deleting txt file
DROP TABLE covid_deaths_txt;

-- repeating above process for another table
CREATE TABLE covid_vaccinations
(
	iso_code VARCHAR(10), #A 
	continent VARCHAR(20), #B
    location VARCHAR(50), #C
    `date` DATE, #D
    new_tests BIGINT, #E
    total_tests BIGINT, #F
    total_tests_per_thousand DOUBLE, #G
    new_tests_per_thousand DOUBLE, #H
    new_tests_smoothed BIGINT, #I
    new_tests_smoothed_per_thousand DOUBLE, #J
    positive_rate DOUBLE, #K
    tests_per_case DOUBLE, #L
    tests_units VARCHAR(50), #M
    total_vaccinations BIGINT, #N
    people_vaccinated BIGINT, #O
    people_fully_vaccinated BIGINT, #P
    new_vaccinations BIGINT, #Q
    new_vaccinations_smoothed BIGINT, #R
    total_vaccinations_per_hundred DOUBLE, #S
    people_vaccinated_per_hundred DOUBLE, #T
    people_fully_vaccinated_per_hundred DOUBLE, #U 
    new_vaccinations_smoothed_per_million BIGINT, #V 
    stringency_index DOUBLE, #W 
    population_density DOUBLE, #X 
    median_age DOUBLE, #Y 
    aged_65_older DOUBLE, #Z 
    aged_70_older DOUBLE, #AA 
    gdp_per_capita DOUBLE, #AB 
    extreme_poverty DOUBLE, #AC 
    cardiovasc_death_rate DOUBLE, #AD 
    diabetes_prevalence DOUBLE, #AE 
    female_smokers DOUBLE, #AF 
    male_smokers DOUBLE, #AG 
    handwashing_facilities DOUBLE, #AH
    hospital_beds_per_thousand DOUBLE, #AI 
    life_expectancy DOUBLE, #AJ
    human_development_index DOUBLE #AK
);

CREATE TABLE covid_vaccinations_txt
LIKE covid_vaccinations;

SELECT *
FROM information_schema.columns
WHERE `TABLE_NAME` = 'covid_vaccinations'
	AND `DATA_TYPE` != 'varchar';

SELECT CONCAT('MODIFY COLUMN ', `COLUMN_NAME`, ' VARCHAR(50),')
FROM information_schema.columns
WHERE `TABLE_NAME` = 'covid_vaccinations'
	AND `DATA_TYPE` != 'varchar'
ORDER BY `ORDINAL_POSITION`;

ALTER TABLE covid_vaccinations_txt
MODIFY COLUMN date VARCHAR(50),
MODIFY COLUMN new_tests VARCHAR(50),
MODIFY COLUMN total_tests VARCHAR(50),
MODIFY COLUMN total_tests_per_thousand VARCHAR(50),
MODIFY COLUMN new_tests_per_thousand VARCHAR(50),
MODIFY COLUMN new_tests_smoothed VARCHAR(50),
MODIFY COLUMN new_tests_smoothed_per_thousand VARCHAR(50),
MODIFY COLUMN positive_rate VARCHAR(50),
MODIFY COLUMN tests_per_case VARCHAR(50),
MODIFY COLUMN total_vaccinations VARCHAR(50),
MODIFY COLUMN people_vaccinated VARCHAR(50),
MODIFY COLUMN people_fully_vaccinated VARCHAR(50),
MODIFY COLUMN new_vaccinations VARCHAR(50),
MODIFY COLUMN new_vaccinations_smoothed VARCHAR(50),
MODIFY COLUMN total_vaccinations_per_hundred VARCHAR(50),
MODIFY COLUMN people_vaccinated_per_hundred VARCHAR(50),
MODIFY COLUMN people_fully_vaccinated_per_hundred VARCHAR(50),
MODIFY COLUMN new_vaccinations_smoothed_per_million VARCHAR(50),
MODIFY COLUMN stringency_index VARCHAR(50),
MODIFY COLUMN population_density VARCHAR(50),
MODIFY COLUMN median_age VARCHAR(50),
MODIFY COLUMN aged_65_older VARCHAR(50),
MODIFY COLUMN aged_70_older VARCHAR(50),
MODIFY COLUMN gdp_per_capita VARCHAR(50),
MODIFY COLUMN extreme_poverty VARCHAR(50),
MODIFY COLUMN cardiovasc_death_rate VARCHAR(50),
MODIFY COLUMN diabetes_prevalence VARCHAR(50),
MODIFY COLUMN female_smokers VARCHAR(50),
MODIFY COLUMN male_smokers VARCHAR(50),
MODIFY COLUMN handwashing_facilities VARCHAR(50),
MODIFY COLUMN hospital_beds_per_thousand VARCHAR(50),
MODIFY COLUMN life_expectancy VARCHAR(50),
MODIFY COLUMN human_development_index VARCHAR(50);

#paste again
LOAD DATA LOCAL INFILE 'C:\\Users\\andre\\OneDrive\\Documents\\MySQL Space\\Data Folder\\CovidVaccinations.csv'
INTO TABLE covid_vaccinations_txt
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SELECT *
FROM covid_vaccinations_txt;

SELECT CONCAT('UPDATE covid_vaccinations_txt SET ', `COLUMN_NAME`, ' = NULL WHERE ', `COLUMN_NAME`, ' = '''';')
FROM information_schema.columns
WHERE `TABLE_NAME` = 'covid_vaccinations'
	AND `DATA_TYPE` != 'varchar'
ORDER BY `ORDINAL_POSITION`;

UPDATE covid_vaccinations_txt SET date = NULL WHERE date = '';
UPDATE covid_vaccinations_txt SET new_tests = NULL WHERE new_tests = '';
UPDATE covid_vaccinations_txt SET total_tests = NULL WHERE total_tests = '';
UPDATE covid_vaccinations_txt SET total_tests_per_thousand = NULL WHERE total_tests_per_thousand = '';
UPDATE covid_vaccinations_txt SET new_tests_per_thousand = NULL WHERE new_tests_per_thousand = '';
UPDATE covid_vaccinations_txt SET new_tests_smoothed = NULL WHERE new_tests_smoothed = '';
UPDATE covid_vaccinations_txt SET new_tests_smoothed_per_thousand = NULL WHERE new_tests_smoothed_per_thousand = '';
UPDATE covid_vaccinations_txt SET positive_rate = NULL WHERE positive_rate = '';
UPDATE covid_vaccinations_txt SET tests_per_case = NULL WHERE tests_per_case = '';
UPDATE covid_vaccinations_txt SET total_vaccinations = NULL WHERE total_vaccinations = '';
UPDATE covid_vaccinations_txt SET people_vaccinated = NULL WHERE people_vaccinated = '';
UPDATE covid_vaccinations_txt SET people_fully_vaccinated = NULL WHERE people_fully_vaccinated = '';
UPDATE covid_vaccinations_txt SET new_vaccinations = NULL WHERE new_vaccinations = '';
UPDATE covid_vaccinations_txt SET new_vaccinations_smoothed = NULL WHERE new_vaccinations_smoothed = '';
UPDATE covid_vaccinations_txt SET total_vaccinations_per_hundred = NULL WHERE total_vaccinations_per_hundred = '';
UPDATE covid_vaccinations_txt SET people_vaccinated_per_hundred = NULL WHERE people_vaccinated_per_hundred = '';
UPDATE covid_vaccinations_txt SET people_fully_vaccinated_per_hundred = NULL WHERE people_fully_vaccinated_per_hundred = '';
UPDATE covid_vaccinations_txt SET new_vaccinations_smoothed_per_million = NULL WHERE new_vaccinations_smoothed_per_million = '';
UPDATE covid_vaccinations_txt SET stringency_index = NULL WHERE stringency_index = '';
UPDATE covid_vaccinations_txt SET population_density = NULL WHERE population_density = '';
UPDATE covid_vaccinations_txt SET median_age = NULL WHERE median_age = '';
UPDATE covid_vaccinations_txt SET aged_65_older = NULL WHERE aged_65_older = '';
UPDATE covid_vaccinations_txt SET aged_70_older = NULL WHERE aged_70_older = '';
UPDATE covid_vaccinations_txt SET gdp_per_capita = NULL WHERE gdp_per_capita = '';
UPDATE covid_vaccinations_txt SET extreme_poverty = NULL WHERE extreme_poverty = '';
UPDATE covid_vaccinations_txt SET cardiovasc_death_rate = NULL WHERE cardiovasc_death_rate = '';
UPDATE covid_vaccinations_txt SET diabetes_prevalence = NULL WHERE diabetes_prevalence = '';
UPDATE covid_vaccinations_txt SET female_smokers = NULL WHERE female_smokers = '';
UPDATE covid_vaccinations_txt SET male_smokers = NULL WHERE male_smokers = '';
UPDATE covid_vaccinations_txt SET handwashing_facilities = NULL WHERE handwashing_facilities = '';
UPDATE covid_vaccinations_txt SET hospital_beds_per_thousand = NULL WHERE hospital_beds_per_thousand = '';
UPDATE covid_vaccinations_txt SET life_expectancy = NULL WHERE life_expectancy = '';
UPDATE covid_vaccinations_txt SET human_development_index = NULL WHERE human_development_index = '';

INSERT INTO covid_vaccinations
SELECT *
FROM covid_vaccinations_txt;

SELECT *
FROM covid_vaccinations
ORDER BY location, `date`;

DROP TABLE covid_vaccinations_txt;