-- ============================================
-- Database Views for Videogame Database
-- ============================================
-- Views provide convenient access to commonly used data combinations

-- ============================================
-- Game Information Views
-- ============================================

-- Complete Game Information View
CREATE OR REPLACE VIEW v_game_details AS
SELECT 
    g.game_id,
    g.title,
    g.release_date,
    g.esrb_rating,
    g.multiplayer,
    g.online_play,
    g.max_players,
    g.price,
    p.name AS publisher,
    d.name AS developer,
    GROUP_CONCAT(DISTINCT pl.name ORDER BY pl.name SEPARATOR ', ') AS platforms,
    GROUP_CONCAT(DISTINCT gr.name ORDER BY gr.name SEPARATOR ', ') AS genres,
    COUNT(DISTINCT r.review_id) AS review_count,
    ROUND(AVG(r.rating), 1) AS average_rating,
    SUM(CASE WHEN r.recommended = TRUE THEN 1 ELSE 0 END) AS recommendations
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
LEFT JOIN Developers d ON g.developer_id = d.developer_id
LEFT JOIN Game_Platforms gp ON g.game_id = gp.game_id
LEFT JOIN Platforms pl ON gp.platform_id = pl.platform_id
LEFT JOIN Game_Genres gg ON g.game_id = gg.game_id
LEFT JOIN Genres gr ON gg.genre_id = gr.genre_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title, g.release_date, g.esrb_rating, g.multiplayer, 
         g.online_play, g.max_players, g.price, p.name, d.name;

-- Top Rated Games View
CREATE OR REPLACE VIEW v_top_rated_games AS
SELECT 
    g.title,
    g.release_date,
    p.name AS publisher,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 1) AS average_rating,
    ROUND((SUM(CASE WHEN r.recommended = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_id)), 1) AS recommendation_percentage
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title, g.release_date, p.name
HAVING review_count >= 2
ORDER BY average_rating DESC, review_count DESC;

-- ============================================
-- Platform and Genre Views
-- ============================================

-- Platform Statistics View
CREATE OR REPLACE VIEW v_platform_statistics AS
SELECT 
    pl.name AS platform,
    pl.manufacturer,
    pl.platform_type,
    COUNT(DISTINCT gp.game_id) AS total_games,
    COUNT(DISTINCT CASE WHEN gp.exclusive = TRUE THEN gp.game_id END) AS exclusive_games
FROM Platforms pl
LEFT JOIN Game_Platforms gp ON pl.platform_id = gp.platform_id
GROUP BY pl.platform_id, pl.name, pl.manufacturer, pl.platform_type
ORDER BY total_games DESC;

-- Genre Statistics View
CREATE OR REPLACE VIEW v_genre_statistics AS
SELECT 
    gr.name AS genre,
    COUNT(DISTINCT gg.game_id) AS total_games,
    COUNT(DISTINCT CASE WHEN gg.primary_genre = TRUE THEN gg.game_id END) AS primary_genre_games,
    ROUND(AVG(g.price), 2) AS average_price
FROM Genres gr
LEFT JOIN Game_Genres gg ON gr.genre_id = gg.genre_id
LEFT JOIN Games g ON gg.game_id = g.game_id
GROUP BY gr.genre_id, gr.name
ORDER BY total_games DESC;

-- ============================================
-- User Activity Views
-- ============================================

-- User Library View
CREATE OR REPLACE VIEW v_user_library_details AS
SELECT 
    u.username,
    u.display_name,
    g.title AS game_title,
    pl.name AS platform,
    ul.playtime_hours,
    ul.completion_percentage,
    ul.status,
    ul.purchase_date,
    ul.last_played
FROM User_Library ul
JOIN Users u ON ul.user_id = u.user_id
JOIN Games g ON ul.game_id = g.game_id
LEFT JOIN Platforms pl ON ul.platform_id = pl.platform_id
ORDER BY u.username, ul.playtime_hours DESC;

-- User Statistics View
CREATE OR REPLACE VIEW v_user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.display_name,
    COUNT(DISTINCT ul.game_id) AS games_owned,
    ROUND(SUM(ul.playtime_hours), 1) AS total_playtime_hours,
    COUNT(DISTINCT r.review_id) AS reviews_written,
    COUNT(DISTINCT ua.achievement_id) AS achievements_unlocked,
    COUNT(DISTINCT CASE WHEN ul.status = 'Completed' THEN ul.game_id END) AS games_completed,
    COUNT(DISTINCT CASE WHEN ul.status = 'Playing' THEN ul.game_id END) AS games_currently_playing,
    COUNT(DISTINCT CASE WHEN ul.status = 'Backlog' THEN ul.game_id END) AS games_in_backlog
FROM Users u
LEFT JOIN User_Library ul ON u.user_id = ul.user_id
LEFT JOIN Reviews r ON u.user_id = r.user_id
LEFT JOIN User_Achievements ua ON u.user_id = ua.user_id
GROUP BY u.user_id, u.username, u.display_name;

-- ============================================
-- Achievement Views
-- ============================================

-- Achievement Completion Rates View
CREATE OR REPLACE VIEW v_achievement_statistics AS
SELECT 
    g.title AS game_title,
    a.name AS achievement_name,
    a.points,
    a.rarity,
    COUNT(ua.user_achievement_id) AS times_unlocked,
    COALESCE(ul_count.total_players, 0) AS total_players,
    CASE 
        WHEN COALESCE(ul_count.total_players, 0) > 0 
        THEN ROUND((COUNT(ua.user_achievement_id) * 100.0 / ul_count.total_players), 1)
        ELSE 0
    END AS completion_percentage
FROM Achievements a
JOIN Games g ON a.game_id = g.game_id
LEFT JOIN User_Achievements ua ON a.achievement_id = ua.achievement_id
LEFT JOIN (
    SELECT game_id, COUNT(*) AS total_players
    FROM User_Library
    GROUP BY game_id
) ul_count ON g.game_id = ul_count.game_id
GROUP BY a.achievement_id, g.title, a.name, a.points, a.rarity, g.game_id, ul_count.total_players
ORDER BY g.title, completion_percentage DESC;

-- ============================================
-- Content Views
-- ============================================

-- Game Content Overview (DLC and Updates)
CREATE OR REPLACE VIEW v_game_content AS
SELECT 
    g.title,
    COUNT(DISTINCT d.dlc_id) AS dlc_count,
    COUNT(DISTINCT gu.update_id) AS update_count,
    MAX(gu.release_date) AS latest_update_date,
    MAX(gu.version) AS latest_version
FROM Games g
LEFT JOIN DLC d ON g.game_id = d.game_id
LEFT JOIN Game_Updates gu ON g.game_id = gu.game_id
GROUP BY g.game_id, g.title;

-- ============================================
-- Review Analysis Views
-- ============================================

-- Recent Reviews View
CREATE OR REPLACE VIEW v_recent_reviews AS
SELECT 
    g.title AS game_title,
    u.username,
    r.rating,
    r.title AS review_title,
    r.recommended,
    r.playtime_hours,
    r.created_at,
    r.helpful_count
FROM Reviews r
JOIN Games g ON r.game_id = g.game_id
JOIN Users u ON r.user_id = u.user_id
ORDER BY r.created_at DESC;

-- ============================================
-- Publisher and Developer Views
-- ============================================

-- Publisher Portfolio View
CREATE OR REPLACE VIEW v_publisher_portfolio AS
SELECT 
    p.name AS publisher,
    p.country,
    COUNT(DISTINCT g.game_id) AS total_games,
    MIN(g.release_date) AS first_game_release,
    MAX(g.release_date) AS latest_game_release,
    ROUND(AVG(r.rating), 1) AS average_rating,
    COUNT(DISTINCT r.review_id) AS total_reviews
FROM Publishers p
LEFT JOIN Games g ON p.publisher_id = g.publisher_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY p.publisher_id, p.name, p.country
HAVING total_games > 0
ORDER BY total_games DESC;

-- Developer Portfolio View
CREATE OR REPLACE VIEW v_developer_portfolio AS
SELECT 
    d.name AS developer,
    d.country,
    COUNT(DISTINCT g.game_id) AS total_games,
    MIN(g.release_date) AS first_game_release,
    MAX(g.release_date) AS latest_game_release,
    ROUND(AVG(r.rating), 1) AS average_rating,
    COUNT(DISTINCT r.review_id) AS total_reviews
FROM Developers d
LEFT JOIN Games g ON d.developer_id = g.developer_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY d.developer_id, d.name, d.country
HAVING total_games > 0
ORDER BY total_games DESC;

-- ============================================
-- Usage Instructions
-- ============================================

-- To use these views, simply query them like tables:
-- SELECT * FROM v_game_details;
-- SELECT * FROM v_top_rated_games LIMIT 10;
-- SELECT * FROM v_user_statistics WHERE username = 'gamer123';

-- To drop a view if needed:
-- DROP VIEW IF EXISTS v_game_details;

-- To see all views in the database:
-- SHOW FULL TABLES WHERE Table_type = 'VIEW';
