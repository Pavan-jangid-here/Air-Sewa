SELECT * FROM air_sewa_grievances;
SELECT * FROM flight_schedule;
SELECT * FROM air_sewa_airport_services;
SELECT * FROM air_sewa_faqs;

ALTER TABLE flight_schedule
CHANGE COLUMN `ï»¿"airline"` AIRLINE VARCHAR(255);

ALTER TABLE air_sewa_grievances
CHANGE COLUMN `ï»¿"category"` CATEGORY VARCHAR(255);

ALTER TABLE air_sewa_grievances
CHANGE COLUMN subcategory AIRLINE VARCHAR(255);

ALTER TABLE air_sewa_airport_services
CHANGE COLUMN ï»¿airport AIRPORT VARCHAR(255);

ALTER TABLE air_sewa_faqs
CHANGE COLUMN ï»¿category CATEGORY VARCHAR(255);

ALTER TABLE flight_schedule MODIFY validFrom DATE;
ALTER TABLE flight_schedule MODIFY validTo DATE;
ALTER TABLE flight_schedule MODIFY lastUpdated DATE;

UPDATE flight_schedule
SET scheduledArrivalTime = NULLIF(scheduledArrivalTime, 'NA');

UPDATE flight_schedule
SET scheduledDepartureTime = NULLIF(scheduledDepartureTime, 'NA');

UPDATE flight_schedule
SET AIRLINE = NULLIF(AIRLINE, 'NA');



-- Q1. Retrieve the airline and the category with the highest percentage of grievances with very good ratings, 
--     including the rank.

with Grievances as (SELECT airline, category, (SUM(grievancesWithVeryGoodRating) / SUM(CAST(totalReceived AS DECIMAL))) * 100 
					AS percentageVeryGoodRating
					FROM air_sewa_grievances
					GROUP BY airline, category)
		SELECT airline, category, percentageVeryGoodRating
        FROM Grievances
        WHERE percentageVeryGoodRating = (SELECT MAX(percentageVeryGoodRating)
										  FROM Grievances);
		

-- Q.2 Calculate the average number of grievances with feedback for each airline and category over time.

WITH Subquery AS (
    SELECT gs.airline, g.category, gs.validFrom,
           ROUND(AVG(g.grievancesWithFeedback), 2) AS avgFeedback
    FROM flight_schedule gs
    JOIN air_sewa_grievances g ON gs.airline = g.airline
    GROUP BY gs.airline, g.category, gs.validFrom 
           ORDER BY gs.validFrom DESC
)
SELECT airline, category, validFrom, avgFeedback
FROM Subquery
GROUP BY airline, category, validFrom, avgFeedback;

-- Q.3 Find the total number of active grievances without escalation for each airline and flight number combination, 
--     where the scheduled departure time is between 8:00 AM and 12:00 PM.

SELECT F.airline, flightNumber, COUNT(activeGrievancesWithoutEscalation) AS TotalActiveGrievancesWithoutEscalation
FROM air_sewa_grievances G
JOIN flight_schedule F ON G.airline = F.airline
WHERE HOUR(scheduledDepartureTime) BETWEEN 8 AND 12
GROUP BY airline, flightNumber;


-- Q.4 List the airlines that have the highest number of successful transfers out and 
--     the highest number of grievances with very bad ratings.

WITH RankedTransfers AS (
    SELECT airline, RANK() OVER (ORDER BY successfulTransferOut DESC) AS TransferRank,
           RANK() OVER (ORDER BY grievancesWithVeryBadRating DESC) AS BadRatingRank
    FROM air_sewa_grievances
)
SELECT airline, COUNT(airline) as Count_Airline
FROM RankedTransfers
WHERE airline <> 'NA'
GROUP BY airline
ORDER BY Count_Airline DESC;




-- Q.5 Find the top 5 airlines with the highest number of grievances on Sundays for flights originating 
--     from 'Delhi' to 'Hyderabad'

SELECT F.airline, SUM(G.totalReceived) AS TotalGrievancesOnSundays
FROM air_sewa_grievances G
JOIN flight_schedule F ON G.airline = F.airline
WHERE daysOfWeek LIKE '%Sunday%' AND origin = 'Delhi' AND destination = 'Hyderabad'
GROUP BY airline
ORDER BY TotalGrievancesOnSundays DESC
LIMIT 5;



-- Q.6 Calculate the average number of grievances with feedback for each airline, but only consider records 
--     that are valid within the date range '2023-01-01' to '2023-12-31.'

SELECT F.airline, ROUND(AVG(grievancesWithFeedback),2) AS AverageFeedbackGrievances
FROM air_sewa_grievances G
JOIN flight_schedule F ON G.airline = F.airline
WHERE validFrom >= '2023-01-01' AND validTo <= '2023-12-31'
GROUP BY airline
ORDER BY AverageFeedbackGrievances DESC;



-- Q.7 Find the airlines with the highest percentage of successful transfers out of the total number of 
--     grievances (with or without ratings).

WITH TransferRatios AS (
    SELECT
        a.airline,
        CAST(SUM(successfulTransferOut) AS FLOAT) / NULLIF(SUM((grievancesWithoutRatings + grievancesWithRatings)), 0) 
        AS TransferRatio
    FROM air_sewa_grievances a
    GROUP BY airline
)
SELECT airline, ROUND(TransferRatio * 100, 2) as PercentOfTransfer
FROM TransferRatios
WHERE TransferRatio <> 0
ORDER BY TransferRatio DESC;




-- Q.8 List the top 3 airlines with the most grievances on Mondays between 10:00 AM and 2:00 PM, originating
--     from 'Goa' to 'Hyderabad'

SELECT f.airline, COUNT(*) AS TotalGrievancesOnMondays
FROM air_sewa_grievances AS a
JOIN flight_schedule AS f ON a.airline = f.airline
WHERE LOCATE('Monday', daysOfWeek) > 0
    AND HOUR(scheduledDepartureTime) BETWEEN 10 AND 14
    AND f.origin = 'Goa'
    AND f.destination = 'Hyderabad'
GROUP BY airline
ORDER BY TotalGrievancesOnMondays DESC
LIMIT 3;




-- Q.9 Find the airlines that have never had a grievance with a very bad rating (grievancesWithVeryBadRating = 0) 
--     but have the highest number of grievances with good ratings.

WITH GoodRatingCounts AS (
    SELECT airline, grievancesWithGoodRating
    FROM air_sewa_grievances
    WHERE grievancesWithVeryBadRating = 0
)
SELECT airline, COUNT(*) AS HighestGrievanceswithGoodRating
FROM GoodRatingCounts
WHERE airline <> "NA" AND grievancesWithGoodRating = (SELECT MAX(grievancesWithGoodRating) 
								  FROM GoodRatingCounts)
GROUP BY airline
ORDER BY HighestGrievanceswithGoodRating DESC;




-- Q.10 Calculate the average number of grievances with feedback for flights scheduled on Sundays (across all airlines)
--      between 2023-01-01 and 2023-12-31.

SELECT ROUND(AVG(grievancesWithFeedback), 2) AS AverageFeedbackGrievancesOnSundays
FROM air_sewa_grievances AS a
JOIN flight_schedule AS f ON a.airline = f.airline
WHERE LOCATE('Sunday', daysOfWeek) > 0
    AND f.validFrom >= '2023-01-01'
    AND f.validTo <= '2023-12-31';
    
    
-- Q.11 Find the airlines with the highest percentage of grievances with additional information provided but without feedback, 
--      out of the total number of grievances with feedback.

WITH FeedbackRatios AS (
    SELECT airline,
	CAST(grievancesAdditionalInfoProvided AS FLOAT) / NULLIF(grievancesWithFeedback - grievancesWithFeedbackIssueNotResolved, 0) 
    AS FeedbackRatio
    FROM air_sewa_grievances
)
SELECT airline, FeedbackRatio
FROM FeedbackRatios
WHERE FeedbackRatio = (SELECT MAX(FeedbackRatio) FROM FeedbackRatios);




-- Q.12 For each airline, calculate the percentage of grievances with very good ratings (5) out of the total number of 
--      grievances with ratings. Then, find the airlines with the highest average percentage of very good ratings.

WITH VeryGoodRatingPercentages AS (
    SELECT airline,
        (CAST(grievancesWithVeryGoodRating AS FLOAT) / NULLIF(grievancesWithRatings, 0)) * 100 AS VeryGoodRatingPercentage
    FROM air_sewa_grievances
)
SELECT airline, AVG(VeryGoodRatingPercentage)
FROM VeryGoodRatingPercentages
GROUP BY airline
HAVING AVG(VeryGoodRatingPercentage) = (
    SELECT MAX(avgPercentage)
    FROM (
        SELECT airline, AVG(VeryGoodRatingPercentage) AS avgPercentage
        FROM VeryGoodRatingPercentages
        GROUP BY airline
    ) AS Averages
);



-- Q.13 Calculate the average time duration (in minutes) between scheduled departure and scheduled arrival times for 
--      each airline. Find the airline with the highest average time duration.

WITH TIME_DIFFS AS (
    SELECT
        AIRLINE,
        
            TIME_TO_SEC(scheduledArrivalTime) - TIME_TO_SEC(scheduledDepartureTime)
        AS time_difference
    FROM flight_schedule
)

SELECT AIRLINE, ROUND(AVG(CASE
    WHEN TIME_TO_SEC(time_difference) < 0 THEN
        TIME_TO_SEC(time_difference) + 24 * 3600
    ELSE
        time_difference
    END
)/3600, 2) AS AVG_Time_taken_by_flight
FROM TIME_DIFFS
WHERE AIRLINE IS NOT NULL
GROUP BY AIRLINE
ORDER BY AVG_Time_taken_by_flight DESC
LIMIT 1;



-- Q.14 Types of Services available at Airport of different cities and Quantity of it and list TOP non-reliable service.


SELECT
    AIRPORT,
    CATEGORYENGLISH,
    COUNT(*) AS QUANTITY,
    SUM(CASE
        WHEN phone = 'NA' OR phone = 'Unavailable' THEN 1
        ELSE 0
    END) AS NOT_RELIABLE_COUNT
FROM air_sewa_airport_services
GROUP BY AIRPORT, CATEGORYENGLISH
ORDER BY NOT_RELIABLE_COUNT DESC
LIMIT 1;
