-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * FROM spotify;

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT artist, track,duration_min FROM spotify WHERE duration_min = 
		(SELECT MAX(duration_min) FROM spotify);
		
SELECT artist, track,duration_min FROM spotify WHERE duration_min = 
		(SELECT MIN(duration_min) FROM spotify);
		
DELETE FROM spotify WHERE duration_min = 0;

SELECT DISTINCT channel from spotify;


--------------------------------------------------
-- EASY CATEGORY
-------------------------------------
SELECT * FROM spotify;

--1. Retrieve the names of all tracks that have more than 1 billion streams. 
SELECT track, title FROM spotify WHERE views>1000000000;

--2.List all albums along with their respective artists.
SELECT DISTINCT(album),artist FROM spotify;

--3.Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) as total_sum_comments FROM spotify WHERE licensed = 'True';

--4.Find all tracks that belong to the album type single. 
SELECT track from spotify WHERE album_type = 'single';

--5.Count the total number of tracks by each artist.
SELECT artist,count(track) FROM spotify GROUP BY artist ORDER BY count(track) DESC;


--------------------------------------------------
-- MEDIUM CATEGORY
-------------------------------------
SELECT * FROM spotify;

--6.Calculate the average danceability of tracks in each album.
SELECT album, AVG(danceability) AS avg_danceability FROM spotify 
GROUP BY album ORDER BY AVG(danceability) DESC;

--7.Find the top 5 tracks with the highest energy values.
SELECT track, energy from spotify ORDER BY energy DESC LIMIT 5;

--8. List top 5 tracks along with their views and likes where official_video= TRUE.
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes from spotify
WHERE official_video= 'TRUE' GROUP BY track ORDER BY SUM(views) DESC LIMIT 5;

--9. For each album, calculate the total views of all associated tracks.
select album, track, SUM(views) as total_views FROM spotify
GROUP BY album, track ORDER BY SUM(views) DESC LIMIT 5;

--10. Retrieve the track names that have been streamed on Spotify more than YouTube. 
SELECT * FROM
(SELECT track,
COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) 
as streamed_on_youtube, COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' 
THEN stream END),0) as streamed_on_spotify FROM spotify GROUP BY track) AS t1 WHERE
streamed_on_spotify > streamed_on_youtube AND streamed_on_youtube <> 0;


--------------------------------------------------
-- HARD CATEGORY
-------------------------------------
select * from spotify;

--11.Find the top 3 most-viewed tracks for each artist using window functions.
WITH cte as (
SELECT artist,track,SUM(views) as total_views,
DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) as rank
from spotify 
GROUP BY artist,track ORDER BY artist,SUM(views) DESC
) SELECT * from cte where rank<=3;


--12.Write a query to find tracks where the liveness score is above the average.
SELECT track,artist,liveness FROM spotify 
WHERE liveness> (SELECT AVG(liveness) FROM spotify);

--13.Use a WITH clause to calculate the difference between the 
-- highest and lowest energy values for tracks in each album.

WITH cte as (SELECT album, 
MAX(energy) as highest_energy, 
MIN(energy) as lowest_energy FROM spotify GROUP BY album)
SELECT album, highest_energy - lowest_energy AS Energy_Diff 
FROM cte ORDER BY Energy_Diff DESC;


