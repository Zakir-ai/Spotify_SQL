-- SQL Project -- Spotify Datasets--

-- create table --

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

-- EDA --

SELECT COUNT(*) FROM spotify;

-- Count of Artist --

SELECT COUNT(DISTINCT artist) FROM spotify;

-- Top 5 most viewed tracks --

SELECT track, artist, views
FROM spotify
ORDER BY views DESC
LIMIT 5;


-- Songs with high energy and loudness --

SELECT track, energy, loudness
FROM spotify
WHERE energy > 0.8 AND loudness > -5;

-- Group: Average views per album type --

SELECT album_type, AVG(views) AS avg_views
FROM spotify
GROUP BY album_type
ORDER BY avg_views DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create a mock artists_info table --

CREATE TABLE artists_info (
    artist VARCHAR(255),
    country VARCHAR(100)
);

INSERT INTO artists_info (artist, country) VALUES
('Gorillaz', 'UK'),
('Tame Impala', 'Australia'),
('Bootie Brown', 'USA'),
('Dua Lipa', 'UK'),
('Bad Bunny', 'Puerto Rico');


-- INNER JOIN --

SELECT s.track, s.artist, a.country
FROM spotify s
INNER JOIN artists_info a ON s.artist = a.artist;

-- LEFT JOIN --

SELECT s.track, s.artist, a.country
FROM spotify s
LEFT JOIN artists_info a ON s.artist = a.artist;

-- RIGHT JOIN --

SELECT s.track, s.artist, a.country
FROM spotify s
RIGHT JOIN artists_info a ON s.artist = a.artist;

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Subquery --

-- Tracks with above-average views --

SELECT track, views
FROM spotify
WHERE views > (SELECT AVG(views) FROM spotify);


-- longest track by 'Dua Lipa' --

SELECT track, duration_min
FROM spotify
WHERE duration_min > (
    SELECT MAX(duration_min)
    FROM spotify
    WHERE artist = 'Dua Lipa'
);

--  more likes than Gorillaz --

SELECT track, likes
FROM spotify
WHERE likes > ALL (
    SELECT likes
    FROM spotify
    WHERE artist = 'Gorillaz'
);

-- More than 1 track --

SELECT track, artist
FROM spotify s1
WHERE (
    SELECT COUNT(*) 
    FROM spotify s2 
    WHERE s2.artist = s1.artist
) > 1;


-- Most-viewed track for each artist --

SELECT track, artist, views
FROM spotify s1
WHERE views = (
    SELECT MAX(views)
    FROM spotify s2
    WHERE s2.artist = s1.artist
);

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Use aggregate functions (SUM, AVG) --

-- AVG --

SELECT artist, 
       AVG(views) AS avg_views, 
       AVG(likes) AS avg_likes
FROM spotify
GROUP BY artist
ORDER BY avg_views DESC
LIMIT 10;


-- Total views and likes per artist --

SELECT artist, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
GROUP BY artist
ORDER BY total_views DESC;

--  Total and Average Stats Using SUM and AVG --

SELECT
    SUM(views) AS total_views,
    SUM(likes) AS total_likes,
    SUM(comments) AS total_comments,
    SUM(stream) AS total_streams,
    
    AVG(views) AS average_views,
    AVG(likes) AS average_likes,
    AVG(comments) AS average_comments,
    AVG(stream) AS average_streams,
    AVG(duration_min) AS average_duration_min
FROM spotify;
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- views for analysis --

-- Engaged Tracks (Based on Likes & Comments) --

CREATE VIEW most_engaged_tracks AS
SELECT track, artist, likes, comments
FROM spotify
WHERE likes IS NOT NULL AND comments IS NOT NULL
ORDER BY likes + comments DESC
LIMIT 100;

--Views for Analysis --

CREATE VIEW top_streamed_tracks AS
SELECT track, artist, stream
FROM spotify
ORDER BY stream DESC
LIMIT 100;

-- Basic Track Info --

CREATE VIEW basic_track_info AS
SELECT track, artist, album, duration_min
FROM spotify;

-- Top_tracks --

CREATE VIEW top_tracks AS
SELECT track, artist, views, stream
FROM spotify
ORDER BY stream DESC
LIMIT 100;

SELECT * FROM top_tracks;


--Basic Track info --

CREATE VIEW basic_track_info AS
SELECT track, artist, album, duration_min
FROM spotify;

SELECT * FROM basic_track_info;

------------------------------------------------------------------------------------------------------------------------------------------------------------
--Optimize queries with indexes --

-- Speeds up queries --

CREATE INDEX idx_artist ON spotify(artist);

SELECT * FROM spotify WHERE artist = 'Ed Sheeran';


--Useful for sorting/filtering --

CREATE INDEX idx_views ON spotify(views);

SELECT track FROM spotify ORDER BY views DESC LIMIT 10;


--  Helps with filtering/grouping by channel --

CREATE INDEX idx_channel ON spotify(channel);

SELECT channel, AVG(likes) FROM spotify GROUP BY channel;



