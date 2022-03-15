/* INSY 661 individual project
    part I.2 external table
*/
/* With external data imported */
USE indproj;

-- start queries
/* Query 1: to calculate the proportion of sunny days in all days across the four years when there was visitor at La Ronde.  */
SELECT 
	AVG(CASE WHEN w.precip = 0 THEN 1
			 WHEN w.precip > 0 THEN 0 ELSE NULL END ) AS sunny_days_proportion,
	1-AVG(CASE WHEN w.precip = 0 THEN 1
			 WHEN w.precip > 0 THEN 0 ELSE NULL END ) AS rainy_snowy_days_proportion
FROM rides_tickets AS rt
INNER JOIN weather AS w ON w.date = DATE(rt.ride_access_time);


/* Query 2: respectively generate the number of visitors that visited La Ronde on sunny days, 
			rainy or snowy days, or on days that had no weather record.  */
SELECT
	COUNT(CASE WHEN w.precip = 0 THEN 1 ELSE NULL END) AS visit_sunny,
    COUNT(CASE WHEN w.precip > 0 THEN 1 ELSE NULL END) AS visit_snowy_or_rainy,
    COUNT(CASE WHEN w.precip = 0 THEN 1 ELSE NULL END)-COUNT(CASE WHEN w.precip > 0 THEN 1 ELSE NULL END) AS visit_no_record
FROM rides_tickets AS rt
INNER JOIN weather AS w ON w.date = DATE(rt.ride_access_time);


/* Query 3: to find the visiting records of customers who were not afraid of heatwaves and visited La Ronde
			on dates where the daily min temperatures were higher than the average min temperature of July, 2020. */
SELECT CONCAT(c.first_name, " ", c.last_name) AS customer_name, w.date, w.min_temp, w.max_temp
FROM rides_tickets AS rt
INNER JOIN Weather AS w ON w.date = DATE(rt.ride_access_time)
INNER JOIN Ticket AS t ON t.ticket_ID = rt.ticket_ID
INNER JOIN Customer AS c ON c.C_ID = t.customer_ID
WHERE w.min_temp > (SELECT AVG(min_temp)
							FROM Weather
							WHERE year = 2017 AND month = 7
                            )
GROUP BY rt.ticket_ID, DATE(rt.ride_access_time)
ORDER BY w.min_temp DESC;


/* Query 4: find the weather of the days when Berta, who had visited La Ronde for the most times, came to the park*/
-- create the weather_type column (varchar(255))
ALTER TABLE Weather
ADD COLUMN weather_type varchar(255);
SET SQL_SAFE_UPDATES = 0;

UPDATE Weather
SET weather_type = 'sunny' WHERE precip = 0;

UPDATE Weather
SET weather_type = 'rain' WHERE rain > 0 AND snow = 0;

UPDATE Weather
SET weather_type = 'snow' WHERE snow > 0 AND rain = 0;

UPDATE Weather
SET weather_type = 'rain and snow' WHERE snow > 0 AND rain > 0;

SELECT CONCAT(c.first_name, " ", c.last_name) AS customer_name, w.weather_type, DATE(rt.ride_access_time) AS access_date
FROM rides_tickets AS rt
INNER JOIN Weather AS w ON w.date = DATE(rt.ride_access_time)
INNER JOIN Ticket AS t ON t.ticket_ID = rt.ticket_ID
INNER JOIN Customer AS c ON c.C_ID = t.customer_ID
WHERE c.first_name = 'Berta' AND c.last_name = 'Drewery'
GROUP BY rt.ticket_ID, DATE(rt.ride_access_time)
ORDER BY DATE(rt.ride_access_time);


/* Query 5: find the incredible customers who came to the park when daily max temperatur
			e is lower than the average min temperature of Jan 2016 and it was snowy.*/
SELECT CONCAT(c.first_name, " ", c.last_name) AS customer_name, 
		DATE(rt.ride_access_time) AS access_date,
        w.max_temp,
		w.weather_type, 
        w.rain AS rain_precipitation,
        w.snow AS snow_precipitation
FROM rides_tickets AS rt
INNER JOIN Weather AS w ON w.date = DATE(rt.ride_access_time)
INNER JOIN Ticket AS t ON t.ticket_ID = rt.ticket_ID
INNER JOIN Customer AS c ON c.C_ID = t.customer_ID
WHERE w.max_temp < (
					SELECT AVG(max_temp)
					FROM Weather 
					WHERE year = 2016 AND month = 12
                    )
AND (w.weather_type = 'snow' OR w.weather_type = 'rain and snow')
GROUP BY rt.ticket_ID, DATE(rt.ride_access_time)
ORDER BY max_temp;




