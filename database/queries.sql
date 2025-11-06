-- ============================================
-- Useful Queries for Videogame Database
-- ============================================
-- Common queries for retrieving and analyzing videogame data

-- ============================================
-- Basic Game Queries
-- ============================================

-- Get all games with their publishers and developers
SELECT 
    g.game_id,
    g.title,
    p.name AS publisher,
    d.name AS developer,
    g.release_date,
    g.price,
    g.esrb_rating
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
LEFT JOIN Developers d ON g.developer_id = d.developer_id
ORDER BY g.release_date DESC;

-- Get games by platform
SELECT 
    g.title,
    pl.name AS platform,
    gp.release_date
FROM Games g
JOIN Game_Platforms gp ON g.game_id = gp.game_id
JOIN Platforms pl ON gp.platform_id = pl.platform_id
WHERE pl.name = 'PlayStation 5'
ORDER BY gp.release_date DESC;

-- Get games by genre
SELECT 
    g.title,
    gr.name AS genre,
    gg.primary_genre
FROM Games g
JOIN Game_Genres gg ON g.game_id = gg.game_id
JOIN Genres gr ON gg.genre_id = gr.genre_id
WHERE gr.name = 'RPG'
ORDER BY g.title;

-- ============================================
-- Advanced Game Information
-- ============================================

-- Get complete game information with all platforms and genres
SELECT 
    g.title,
    p.name AS publisher,
    d.name AS developer,
    g.release_date,
    g.price,
    GROUP_CONCAT(DISTINCT pl.name ORDER BY pl.name) AS platforms,
    GROUP_CONCAT(DISTINCT gr.name ORDER BY gr.name) AS genres
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
LEFT JOIN Developers d ON g.developer_id = d.developer_id
LEFT JOIN Game_Platforms gp ON g.game_id = gp.game_id
LEFT JOIN Platforms pl ON gp.platform_id = pl.platform_id
LEFT JOIN Game_Genres gg ON g.game_id = gg.game_id
LEFT JOIN Genres gr ON gg.genre_id = gr.genre_id
GROUP BY g.game_id, g.title, p.name, d.name, g.release_date, g.price
ORDER BY g.title;

-- Get games with average ratings
SELECT 
    g.title,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS average_rating,
    SUM(CASE WHEN r.recommended = TRUE THEN 1 ELSE 0 END) AS recommended_count
FROM Games g
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title
HAVING review_count > 0
ORDER BY average_rating DESC;

-- ============================================
-- User Queries
-- ============================================

-- Get user's game library with playtime
SELECT 
    u.username,
    g.title,
    pl.name AS platform,
    ul.playtime_hours,
    ul.status,
    ul.completion_percentage
FROM User_Library ul
JOIN Users u ON ul.user_id = u.user_id
JOIN Games g ON ul.game_id = g.game_id
LEFT JOIN Platforms pl ON ul.platform_id = pl.platform_id
WHERE u.username = 'gamer123'
ORDER BY ul.playtime_hours DESC;

-- Get user's achievement progress for a game
SELECT 
    u.username,
    g.title,
    COUNT(ua.achievement_id) AS unlocked_achievements,
    (SELECT COUNT(*) FROM Achievements WHERE game_id = g.game_id) AS total_achievements,
    ROUND((COUNT(ua.achievement_id) * 100.0 / 
           (SELECT COUNT(*) FROM Achievements WHERE game_id = g.game_id)), 2) AS completion_percentage
FROM Users u
CROSS JOIN Games g
LEFT JOIN Achievements a ON g.game_id = a.game_id
LEFT JOIN User_Achievements ua ON u.user_id = ua.user_id AND a.achievement_id = ua.achievement_id
WHERE u.username = 'gamer123' AND g.title = 'The Witcher 3: Wild Hunt'
GROUP BY u.username, g.title;

-- ============================================
-- Statistics and Analytics
-- ============================================

-- Most popular platforms (by number of games)
SELECT 
    pl.name,
    COUNT(DISTINCT gp.game_id) AS game_count
FROM Platforms pl
JOIN Game_Platforms gp ON pl.platform_id = gp.platform_id
GROUP BY pl.platform_id, pl.name
ORDER BY game_count DESC;

-- Most popular genres
SELECT 
    gr.name,
    COUNT(DISTINCT gg.game_id) AS game_count
FROM Genres gr
JOIN Game_Genres gg ON gr.genre_id = gg.genre_id
GROUP BY gr.genre_id, gr.name
ORDER BY game_count DESC;

-- Top publishers by number of games
SELECT 
    p.name,
    COUNT(g.game_id) AS game_count,
    AVG(r.rating) AS average_rating
FROM Publishers p
LEFT JOIN Games g ON p.publisher_id = g.publisher_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY p.publisher_id, p.name
HAVING game_count > 0
ORDER BY game_count DESC;

-- Most reviewed games
SELECT 
    g.title,
    COUNT(r.review_id) AS review_count,
    AVG(r.rating) AS average_rating,
    AVG(r.playtime_hours) AS average_playtime
FROM Games g
JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title
ORDER BY review_count DESC;

-- ============================================
-- Character and Achievement Queries
-- ============================================

-- Get all characters for a game
SELECT 
    g.title,
    c.name,
    c.character_type,
    c.playable,
    c.description
FROM Characters c
JOIN Games g ON c.game_id = g.game_id
WHERE g.title = 'The Witcher 3: Wild Hunt'
ORDER BY c.playable DESC, c.character_type;

-- Get achievements for a game by rarity
SELECT 
    g.title,
    a.name,
    a.description,
    a.points,
    a.rarity
FROM Achievements a
JOIN Games g ON a.game_id = g.game_id
WHERE g.title = 'Elden Ring'
ORDER BY 
    CASE a.rarity
        WHEN 'Common' THEN 1
        WHEN 'Uncommon' THEN 2
        WHEN 'Rare' THEN 3
        WHEN 'Epic' THEN 4
        WHEN 'Legendary' THEN 5
    END;

-- ============================================
-- DLC and Updates
-- ============================================

-- Get all DLC for games
SELECT 
    g.title,
    d.name AS dlc_name,
    d.release_date,
    d.price,
    d.description
FROM DLC d
JOIN Games g ON d.game_id = g.game_id
ORDER BY g.title, d.release_date;

-- ============================================
-- Search Queries
-- ============================================

-- Search games by title
SELECT 
    g.title,
    p.name AS publisher,
    g.release_date,
    g.price
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
WHERE g.title LIKE '%Witcher%'
ORDER BY g.release_date DESC;

-- Find multiplayer games
SELECT 
    g.title,
    g.max_players,
    g.online_play,
    g.price
FROM Games g
WHERE g.multiplayer = TRUE
ORDER BY g.max_players DESC;

-- Find games by ESRB rating
SELECT 
    g.title,
    g.esrb_rating,
    g.release_date
FROM Games g
WHERE g.esrb_rating IN ('E', 'E10+')
ORDER BY g.release_date DESC;

-- ============================================
-- System Requirements
-- ============================================

-- Get system requirements for a game
SELECT 
    g.title,
    pl.name AS platform,
    sr.requirement_type,
    sr.os,
    sr.processor,
    sr.memory_gb,
    sr.graphics,
    sr.storage_gb
FROM System_Requirements sr
JOIN Games g ON sr.game_id = g.game_id
JOIN Platforms pl ON sr.platform_id = pl.platform_id
WHERE g.title = 'The Witcher 3: Wild Hunt'
ORDER BY sr.requirement_type;

-- ============================================
-- Complex Analysis Queries
-- ============================================

-- Get games released in the last 3 years with high ratings
SELECT 
    g.title,
    g.release_date,
    AVG(r.rating) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM Games g
LEFT JOIN Reviews r ON g.game_id = r.game_id
WHERE g.release_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY g.game_id, g.title, g.release_date
HAVING avg_rating >= 8.0
ORDER BY avg_rating DESC, review_count DESC;

-- Find similar games based on genres
SELECT DISTINCT
    g2.title AS similar_game,
    g2.release_date,
    COUNT(DISTINCT gg2.genre_id) AS matching_genres
FROM Games g1
JOIN Game_Genres gg1 ON g1.game_id = gg1.game_id
JOIN Game_Genres gg2 ON gg1.genre_id = gg2.genre_id
JOIN Games g2 ON gg2.game_id = g2.game_id
WHERE g1.title = 'The Witcher 3: Wild Hunt' 
  AND g2.game_id != g1.game_id
GROUP BY g2.game_id, g2.title, g2.release_date
ORDER BY matching_genres DESC, g2.release_date DESC
LIMIT 5;

-- User engagement statistics
SELECT 
    u.username,
    COUNT(DISTINCT ul.game_id) AS games_owned,
    SUM(ul.playtime_hours) AS total_playtime,
    COUNT(DISTINCT r.review_id) AS reviews_written,
    COUNT(DISTINCT ua.achievement_id) AS achievements_unlocked
FROM Users u
LEFT JOIN User_Library ul ON u.user_id = ul.user_id
LEFT JOIN Reviews r ON u.user_id = r.user_id
LEFT JOIN User_Achievements ua ON u.user_id = ua.user_id
GROUP BY u.user_id, u.username
ORDER BY total_playtime DESC;
