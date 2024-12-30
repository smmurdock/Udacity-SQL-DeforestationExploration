-- Create a view called "forestation"
-- Joins forest_area, land_area, and regions tables
CREATE VIEW forestation
AS SELECT
  fa.country_code,
  fa.country_name,
  fa.year,
  fa.forest_area_sqkm,
  la.total_area_sq_mi * 2.59 AS total_area_sqkm,
  -- Calculate the percent of total land that is forest area
  (fa.forest_area_sqkm/(la.total_area_sq_mi * 2.59) * 100) AS perc_land_is_forest,
  r.region,
  r.income_group
FROM forest_area fa
JOIN land_area la
ON fa.country_code = la.country_code
AND fa.year = la.year
JOIN regions r
ON la.country_code = r.country_code;