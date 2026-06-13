CREATE DATABASE IF NOT EXISTS SpotifyDB;
USE SpotifyDB;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    country VARCHAR(50),
    subscription_type VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS tracks (
    track_id INT PRIMARY KEY,
    track_name VARCHAR(100),
    artist_name VARCHAR(100),
    genre VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS listening_history (
    log_id INT PRIMARY KEY,
    user_id INT,
    track_id INT,
    listen_time DATETIME,
    duration_spent INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);

INSERT INTO users VALUES 
(1, 'India', 'Premium'), (2, 'USA', 'Free'), (3, 'India', 'Free'), 
(4, 'USA', 'Premium'), (5, 'UK', 'Premium'), (6, 'Germany', 'Free'),
(7, 'Canada', 'Premium'), (8, 'UAE', 'Free'), (9, 'UK', 'Free'), 
(10, 'Canada', 'Free'), (11, 'Germany', 'Premium'), (12, 'Australia', 'Premium');

INSERT INTO tracks VALUES 
(101, 'Arabic Kuthu', 'Anirudh', 'Kollywood'),
(102, 'Blinding Lights', 'The Weeknd', 'Pop'),
(103, 'Shape of You', 'Ed Sheeran', 'Pop'),
(104, 'Hukum', 'Anirudh', 'Kollywood'),
(105, 'Lose Yourself', 'Eminem', 'Hip-Hop'),
(106, 'Bohemian Rhapsody', 'Queen', 'Rock'),
(107, 'Vatapi Ganapatim', 'M.S. Subbulakshmi', 'Carnatic'),
(108, 'Not Like Us', 'Kendrick Lamar', 'Hip-Hop'),
(109, 'Hotel California', 'Eagles', 'Rock'),
(110, 'Kanda Vara Sollunga', 'Santhosh Narayanan', 'Kollywood'),
(111, 'Stay', 'The Kid LAROI & Justin Bieber', 'Pop');

INSERT INTO listening_history VALUES 
(1, 1, 101, '2026-06-01 09:00:00', 210),
(2, 1, 104, '2026-06-01 09:04:00', 200), 
(3, 2, 102, '2026-06-01 14:20:00', 180),
(4, 3, 101, '2026-06-02 18:30:00', 210),
(5, 4, 103, '2026-06-02 20:15:00', 240),
(6, 4, 105, '2026-06-02 20:20:00', 300),
(7, 5, 102, '2026-06-03 11:00:00', 150),
(8, 1, 102, '2026-06-03 15:00:00', 180),
(9, 6, 105, '2026-06-04 10:00:00', 290),
(10, 7, 106, '2026-06-05 08:30:00', 355), 
(11, 8, 102, '2026-06-05 09:15:00', 200), 
(12, 9, 108, '2026-06-05 11:45:00', 270),
(13, 3, 107, '2026-06-05 16:20:00', 420),
(14, 10, 109, '2026-06-06 07:10:00', 390),
(15, 11, 102, '2026-06-06 13:00:00', 198),
(16, 12, 111, '2026-06-06 18:40:00', 140),
(17, 1, 110, '2026-06-07 06:15:00', 280),
(18, 5, 106, '2026-06-07 10:25:00', 355),
(19, 7, 109, '2026-06-07 14:10:00', 120),
(20, 2, 108, '2026-06-07 21:05:00', 270),
(21, 4, 108, '2026-06-08 03:30:00', 250),
(22, 6, 103, '2026-06-08 09:50:00', 240),
(23, 8, 111, '2026-06-08 15:15:00', 140),
(24, 11, 106, '2026-06-08 23:10:00', 355),
(25, 12, 109, '2026-06-09 11:20:00', 390),
(26, 9, 105, '2026-06-09 16:45:00', 300),
(27, 3, 110, '2026-06-09 19:30:00', 280),
(28, 10, 111, '2026-06-10 08:05:00', 140),
(29, 8, 108, '2026-06-10 12:55:00', 270),
(30, 1, 107, '2026-06-10 17:15:00', 500),
(31, 2, 106, '2026-06-11 14:22:00', 355),
(32, 5, 111, '2026-06-11 20:05:00', 140),
(33, 7, 108, '2026-06-12 01:10:00', 270),
(34, 12, 107, '2026-06-12 10:30:00', 450),
(35, 4, 110, '2026-06-12 15:40:00', 280);

SELECT * FROM listening_history;

SELECT 
    u.country, 
    t.genre, 
    COUNT(lh.log_id) AS total_streams,
    SUM(lh.duration_spent) / 60 AS total_minutes_played
FROM listening_history lh
JOIN users u ON lh.user_id = u.user_id
JOIN tracks t ON lh.track_id = t.track_id
GROUP BY u.country, t.genre
ORDER BY total_streams DESC;

SELECT 
    u.user_id,
    u.country,
    SUM(lh.duration_spent) AS total_seconds,
    DENSE_RANK() OVER(PARTITION BY u.country ORDER BY SUM(lh.duration_spent) DESC) AS user_engagement_rank
FROM listening_history lh
JOIN users u ON lh.user_id = u.user_id
GROUP BY u.user_id, u.country;

SELECT 
    HOUR(listen_time) AS streaming_hour,
    COUNT(log_id) AS total_streams
FROM listening_history
GROUP BY HOUR(listen_time)
ORDER BY total_streams DESC;

SELECT 
    u.subscription_type,
    COUNT(lh.log_id) AS total_streams,
    SUM(lh.duration_spent)/60 AS total_minutes
FROM listening_history lh
JOIN users u ON lh.user_id = u.user_id
GROUP BY u.subscription_type;