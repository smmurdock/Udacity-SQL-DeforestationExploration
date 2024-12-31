/* a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table. */
-- Total area forest (in square km) of the world in 1990
SELECT
    country_name,
    forest_area_sqkm,
    year
FROM forestation
WHERE country_name = 'World'
AND year = 1990;


/* b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.” */
-- Total area forest (in square km) of the world in 2016
SELECT
    country_name,
    forest_area_sqkm,
    year
FROM forestation
WHERE country_name = 'World'
AND year = 2016;


/* c. What was the change (in sq km) in the forest area of the world from 1990 to 2016? */
-- Change (in square km) of forest area of the world as of 2016 since 1990
SELECT (f1.forest_area_sqkm - f2.forest_area_sqkm) AS forest_area_change_sq_km
FROM 
  forestation AS f1, 
  forestation AS f2
WHERE f1.year = '2016' 
AND f1.country_name = 'World'
AND f2.year = '1990' 
AND f2.country_name = 'World';


/* d. What was the percent change in forest area of the world between 1990 and 2016? */
-- Percent change in forest area around the world from 1990 to 2016
SELECT 
  (f1.forest_area_sqkm - f2.forest_area_sqkm) AS forest_area_change_sq_km,
  ((f1.forest_area_sqkm - f2.forest_area_sqkm) / f2.forest_area_sqkm) * 100 AS forest_area_percent_change
FROM forestation AS f1, forestation AS f2
WHERE f1.year = '2016' 
AND f1.country_name = 'World'
AND f2.year = '1990' 
AND f2.country_name = 'World';


/* e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to? */
-- Country with closest total area compared to the amount of forest area lost between 1990 and 2016
SELECT country_name, 
  year, 
  total_area_sqkm
FROM forestation
WHERE year = 2016
AND (total_area_sqkm) < (( -- dynamically calculate difference in total forest area
                          SELECT forest_area_sqkm 
                          FROM forestation
                          WHERE country_name = 'World' 
                          AND year = 1990) -
                          (SELECT forest_area_sqkm FROM forestation
                          WHERE country_name = 'World' 
                          AND year = 2016))
ORDER BY total_area_sqkm DESC 
LIMIT 1;