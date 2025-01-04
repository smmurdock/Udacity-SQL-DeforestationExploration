/* a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places? */
-- Find the percent forest of the entire world in 2016
SELECT
    ROUND(CAST(SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016;

-- Find the region with the HIGHEST percent forest in 2016
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016
GROUP BY 1
ORDER BY 2 DESC;

-- Find the region with the LOWEST percent forest in 2016
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 2016
GROUP BY 1
ORDER BY 2;


/* b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places? */
-- Find the percent forest of the entire world in 1990
SELECT
    SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100 AS forest_area_world
FROM forestation
WHERE year = 1990;

-- Find the region with the HIGHEST percent forest in 1990
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 1990
GROUP BY 1
ORDER BY 2 DESC;

-- Find the region with the LOWEST percent forest in 1990
SELECT
    region,
    ROUND(CAST(SUM(forest_area_sqkm) / NULLIF(SUM(total_area_sqkm), 0) * 100 AS NUMERIC), 2) AS forest_area_world
FROM forestation
WHERE year = 1990
GROUP BY 1
ORDER BY 2;


/* c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016? */
-- Find the regions of the world that DECREASED in forest area from 1990 to 2016
SELECT 
    region,
    SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END) AS forest_area_1990,
    SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) AS forest_area_2016
FROM forestation
GROUP BY region
HAVING SUM(CASE WHEN year = 2016 THEN forest_area_sqkm ELSE 0 END) < SUM(CASE WHEN year = 1990 THEN forest_area_sqkm ELSE 0 END);
