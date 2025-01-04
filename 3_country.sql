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
LIMIT 5;

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
LIMIT 5;

/* c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */
-- Create quartiles of perc_land_is_forest and determine which quartile has the highest number of countries
WITH quartiles AS (
    SELECT 
        country_code,
        country_name,
        perc_land_is_forest,
        NTILE(4) OVER (ORDER BY perc_land_is_forest) AS quartile
    FROM forestation
    WHERE year = 2016
)
SELECT 
    quartile,
    COUNT(*) AS country_count
FROM quartiles
GROUP BY quartile
ORDER BY country_count DESC
LIMIT 1;

/* d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016. */ 
-- List all countries in the 4th quartile (>75%) in 2016
WITH quartiles AS (
    SELECT 
        country_code,
        country_name,
        perc_land_is_forest,
        NTILE(4) OVER (ORDER BY perc_land_is_forest) AS quartile
    FROM forestation
    WHERE year = 2016
)
SELECT 
    country_code,
    country_name,
    perc_land_is_forest
FROM quartiles
WHERE quartile = 4;

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
WHERE 
    year = 2016 
    AND perc_land_is_forest > (SELECT perc_land_is_forest 
                               FROM us_forest_percentage);