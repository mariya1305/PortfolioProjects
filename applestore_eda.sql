-- EXPLORATORY DATA ANALYSIS 

-- Confirm the number of apps in both tables 

SELECT COUNT(DISTINCT id) As UniqueAppIDS
FROM PROJECTS.dbo.AppleStore$

SELECT COUNT(DISTINCT id) As UniqueAddIDS
FROM PROJECTS.dbo.appleStore_description$

-- Check for any missing values in key fields 

SELECT COUNT(*) AS MissingValues
FROM PROJECTS.dbo.AppleStore$
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL


SELECT COUNT(*) AS MissingValues
FROM PROJECTS.dbo.appleStore_description$
WHERE app_desc IS NULL 

-- Find the number of apps per genre

SELECT prime_genre, COUNT(*) as NumberOfApps
FROM PROJECTS.dbo.AppleStore$
GROUP BY prime_genre
ORDER BY 2 DESC

-- Get an overview of app ratings

SELECT min(user_rating) AS MinRating, max(user_rating) AS MaxRating, avg(user_rating) AS AvgRating
FROM PROJECTS.dbo.AppleStore$

-- DATA ANALYSIS

-- Determine whether paid apps have higher ratings than free apps

SELECT CASE WHEN price > 0 THEN 'Paid' ELSE 'Free' END AS AppType, 
	avg(user_rating) AS AvgRating

FROM PROJECTS.dbo.AppleStore$
GROUP BY 
    CASE 
        WHEN price > 0 THEN 'Paid' 
        ELSE 'Free' 
    END;

-- See if apps with more supporting languages have higher ratings

SELECT CASE 
		WHEN lang_num < 10 THEN '<10 languages' 
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		ELSE '>30 languages'
	END AS LanguagesNum,
	avg(user_rating) AS AvgRating

FROM PROJECTS.dbo.AppleStore$
GROUP BY CASE
		WHEN lang_num < 10 THEN '<10 languages' 
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		ELSE '>30 languages'
	END
ORDER BY AvgRating DESC

-- Genres with the lowest average rating

SELECT prime_genre, avg(user_rating) AS AvgRating
FROM PROJECTS.dbo.AppleStore$
GROUP BY prime_genre
ORDER BY AvgRating ASC

-- See if there is a correlation between app ratings and description length

SELECT CASE
		WHEN len(b.app_desc) < 500 THEN 'Short'
		WHEN len(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
	END AS 'DescriptionLength',
	avg(user_rating) AS AvgRating


FROM PROJECTS.dbo.AppleStore$ AS A
	JOIN PROJECTS.dbo.appleStore_description$ B
ON A.id = B.id

GROUP BY  CASE
		WHEN len(b.app_desc) < 500 THEN 'Short'
		WHEN len(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
	END
ORDER BY AvgRating DESC