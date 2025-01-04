/* a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each? */
-- Find the countries with the largest amount decrease in forest_area_sqkm from 1990 to 2016 and the calculated difference
SELECT 
    country_code,
    country_name,
    SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) AS forest_area_1990,
    SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) AS forest_area_2016,
    (SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) - SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END)) AS forest_area_change
FROM forestation
WHERE country_name <> 'World'
GROUP BY 
    country_code, 
    country_name
ORDER BY forest_area_change ASC -- ASC because it starts from negative values
LIMIT 6;

/* b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each? */
-- Find the countries with the largest percent decrease in forest area from 1990 to 2016 and round to 2 decimals
SELECT 
    country_code,
    country_name,
    SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) AS forest_area_1990,
    SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) AS forest_area_2016,
    ROUND(CAST((SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) - SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END)) / SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) * 100 AS NUMERIC), 2) AS percent_change
FROM forestation
GROUP BY 
    country_code, 
    country_name
HAVING SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) > 0 -- Ensure we don't divide by zero
ORDER BY percent_change ASC
LIMIT 6;

/* c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */
-- Create quartiles of perc_land_is_forest and determine which quartile has the highest number of countries
SELECT 
    DISTINCT(quartiles), 
    COUNT(country_name) OVER (PARTITION BY quartiles) AS countries
    FROM (SELECT country_name,
          CASE WHEN perc_land_is_forest <= 25 THEN '0-25%'
              WHEN perc_land_is_forest <= 75 AND perc_land_is_forest > 50 THEN '50-75%'
              WHEN perc_land_is_forest <= 50 AND perc_land_is_forest > 25 THEN '25-50%'
              ELSE '75-100%'
          END AS quartiles 
FROM forestation
WHERE (perc_land_is_forest IS NOT NULL AND year = 2016) 
AND country_name <> 'World') quart; 

/* d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016. */ 
-- List all countries in the 4th quartile (>75%) in 2016
SELECT 
    country_name, 
    region, 
    perc_land_is_forest
FROM forestation
WHERE year = 2016
AND country_name <> 'World'
AND perc_land_is_forest > 75 
ORDER BY 3 DESC;

/* e. How many countries had a percent forestation higher than the United States in 2016? */
-- Find number of countries with higher percent of forest than the United States in 2016
WITH us_forest_percentage AS (
    SELECT perc_land_is_forest
    FROM forestation
    WHERE country_code = 'USA' 
    AND year = 2016
)
SELECT COUNT(*) AS countries_higher_than_us
FROM forestation
WHERE year = 2016 
AND perc_land_is_forest > (SELECT perc_land_is_forest 
                          FROM us_forest_percentage);