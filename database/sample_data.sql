-- ============================================
-- Sample Data for Videogame Database
-- ============================================

-- Insert Publishers
INSERT INTO Publishers (name, country, founded_year, website, description) VALUES
('Electronic Arts', 'USA', 1982, 'https://www.ea.com', 'One of the largest video game publishers in the world'),
('Ubisoft', 'France', 1986, 'https://www.ubisoft.com', 'French video game company known for franchises like Assassins Creed'),
('Nintendo', 'Japan', 1889, 'https://www.nintendo.com', 'Japanese multinational video game company'),
('Sony Interactive Entertainment', 'Japan', 1993, 'https://www.playstation.com', 'Video game and entertainment company'),
('Microsoft Studios', 'USA', 2002, 'https://www.xbox.com', 'Video game publisher and development division of Microsoft'),
('Activision Blizzard', 'USA', 2008, 'https://www.activisionblizzard.com', 'American video game holding company'),
('CD Projekt', 'Poland', 1994, 'https://www.cdprojekt.com', 'Polish video game developer and publisher'),
('Rockstar Games', 'USA', 1998, 'https://www.rockstargames.com', 'American video game publisher');

-- Insert Developers
INSERT INTO Developers (name, country, founded_year, website, description) VALUES
('BioWare', 'Canada', 1995, 'https://www.bioware.com', 'Known for role-playing games'),
('Naughty Dog', 'USA', 1984, 'https://www.naughtydog.com', 'Developer of acclaimed action-adventure games'),
('CD Projekt Red', 'Poland', 2002, 'https://www.cdprojektred.com', 'Creator of The Witcher series'),
('FromSoftware', 'Japan', 1986, 'https://www.fromsoftware.jp', 'Known for challenging action RPGs'),
('Rockstar North', 'UK', 1988, 'https://www.rockstarnorth.com', 'Developer of Grand Theft Auto series'),
('Nintendo EPD', 'Japan', 2015, 'https://www.nintendo.com', 'Internal Nintendo development division'),
('Insomniac Games', 'USA', 1994, 'https://www.insomniacgames.com', 'Developer of Ratchet & Clank and Spider-Man games'),
('Bethesda Game Studios', 'USA', 2001, 'https://www.bethesdagamestudios.com', 'Creator of The Elder Scrolls and Fallout series');

-- Insert Platforms
INSERT INTO Platforms (name, manufacturer, release_year, platform_type, description) VALUES
('PlayStation 5', 'Sony', 2020, 'Console', 'Latest Sony gaming console'),
('Xbox Series X', 'Microsoft', 2020, 'Console', 'Latest Microsoft gaming console'),
('Nintendo Switch', 'Nintendo', 2017, 'Handheld', 'Hybrid console/handheld system'),
('PC', 'Various', 1981, 'PC', 'Personal computer gaming platform'),
('PlayStation 4', 'Sony', 2013, 'Console', 'Previous generation Sony console'),
('Xbox One', 'Microsoft', 2013, 'Console', 'Previous generation Microsoft console'),
('PlayStation VR2', 'Sony', 2023, 'VR', 'Virtual reality headset for PlayStation 5'),
('Steam Deck', 'Valve', 2022, 'Handheld', 'Portable gaming PC'),
('iOS', 'Apple', 2007, 'Mobile', 'Mobile gaming on Apple devices'),
('Android', 'Google', 2008, 'Mobile', 'Mobile gaming on Android devices');

-- Insert Genres
INSERT INTO Genres (name, description) VALUES
('Action', 'Fast-paced games requiring hand-eye coordination'),
('Adventure', 'Exploration and story-driven games'),
('RPG', 'Role-playing games with character progression'),
('Strategy', 'Games requiring tactical thinking and planning'),
('Simulation', 'Games that simulate real-world activities'),
('Sports', 'Games based on sports and athletic competitions'),
('Racing', 'Vehicular racing games'),
('Puzzle', 'Games that require problem-solving'),
('Fighting', 'One-on-one combat games'),
('FPS', 'First-person shooter games'),
('Platformer', 'Games involving jumping between platforms'),
('Horror', 'Games designed to frighten and scare players'),
('Stealth', 'Games emphasizing sneaking and avoiding detection'),
('MMORPG', 'Massively multiplayer online role-playing games'),
('Battle Royale', 'Last-player-standing multiplayer games');

-- Insert Games
INSERT INTO Games (title, publisher_id, developer_id, release_date, description, esrb_rating, multiplayer, online_play, max_players, price) VALUES
('The Witcher 3: Wild Hunt', 7, 3, '2015-05-19', 'Open-world RPG set in a fantasy universe', 'M', TRUE, TRUE, 1, 39.99),
('Elden Ring', 1, 4, '2022-02-25', 'Action RPG from the creators of Dark Souls', 'M', TRUE, TRUE, 4, 59.99),
('The Last of Us Part II', 4, 2, '2020-06-19', 'Post-apocalyptic action-adventure game', 'M', TRUE, TRUE, 2, 59.99),
('Grand Theft Auto V', 8, 5, '2013-09-17', 'Open-world action-adventure game', 'M', TRUE, TRUE, 30, 29.99),
('The Legend of Zelda: Breath of the Wild', 3, 6, '2017-03-03', 'Open-world action-adventure game', 'E10+', FALSE, FALSE, 1, 59.99),
('Spider-Man: Miles Morales', 4, 7, '2020-11-12', 'Superhero action-adventure game', 'T', FALSE, FALSE, 1, 49.99),
('Skyrim', 5, 8, '2011-11-11', 'Open-world fantasy RPG', 'M', FALSE, FALSE, 1, 39.99),
('Red Dead Redemption 2', 8, 5, '2018-10-26', 'Western-themed action-adventure game', 'M', TRUE, TRUE, 32, 59.99);

-- Insert Game-Platform relationships
INSERT INTO Game_Platforms (game_id, platform_id, release_date, exclusive) VALUES
-- The Witcher 3
(1, 4, '2015-05-19', FALSE),
(1, 5, '2015-05-19', FALSE),
(1, 6, '2015-05-19', FALSE),
(1, 3, '2019-10-15', FALSE),
-- Elden Ring
(2, 1, '2022-02-25', FALSE),
(2, 2, '2022-02-25', FALSE),
(2, 4, '2022-02-25', FALSE),
(2, 5, '2022-02-25', FALSE),
-- The Last of Us Part II
(3, 5, '2020-06-19', TRUE),
(3, 1, '2022-09-02', TRUE),
-- GTA V
(4, 4, '2013-09-17', FALSE),
(4, 5, '2014-11-18', FALSE),
(4, 6, '2014-11-18', FALSE),
(4, 1, '2022-03-15', FALSE),
-- Zelda BOTW
(5, 3, '2017-03-03', TRUE),
-- Spider-Man
(6, 5, '2020-11-12', TRUE),
(6, 1, '2020-11-12', TRUE),
-- Skyrim
(7, 4, '2011-11-11', FALSE),
(7, 1, '2021-11-11', FALSE),
(7, 3, '2017-11-17', FALSE),
-- Red Dead Redemption 2
(8, 4, '2018-10-26', FALSE),
(8, 5, '2018-10-26', FALSE),
(8, 1, '2019-11-05', FALSE);

-- Insert Game-Genre relationships
INSERT INTO Game_Genres (game_id, genre_id, primary_genre) VALUES
(1, 3, TRUE),   -- Witcher 3: RPG (primary)
(1, 2, FALSE),  -- Witcher 3: Adventure
(1, 1, FALSE),  -- Witcher 3: Action
(2, 3, TRUE),   -- Elden Ring: RPG (primary)
(2, 1, FALSE),  -- Elden Ring: Action
(3, 1, TRUE),   -- TLOU2: Action (primary)
(3, 2, FALSE),  -- TLOU2: Adventure
(3, 12, FALSE), -- TLOU2: Horror
(4, 1, TRUE),   -- GTA V: Action (primary)
(4, 2, FALSE),  -- GTA V: Adventure
(5, 2, TRUE),   -- Zelda: Adventure (primary)
(5, 1, FALSE),  -- Zelda: Action
(6, 1, TRUE),   -- Spider-Man: Action (primary)
(6, 2, FALSE),  -- Spider-Man: Adventure
(7, 3, TRUE),   -- Skyrim: RPG (primary)
(7, 2, FALSE),  -- Skyrim: Adventure
(8, 1, TRUE),   -- RDR2: Action (primary)
(8, 2, FALSE);  -- RDR2: Adventure

-- Insert Characters
INSERT INTO Characters (game_id, name, character_type, description, playable) VALUES
(1, 'Geralt of Rivia', 'Protagonist', 'A professional monster hunter', TRUE),
(1, 'Ciri', 'Protagonist', 'Adopted daughter of Geralt with special powers', TRUE),
(1, 'Yennefer', 'Supporting', 'Powerful sorceress and love interest', FALSE),
(2, 'Tarnished', 'Protagonist', 'Player character seeking to become Elden Lord', TRUE),
(2, 'Melina', 'Supporting', 'Mysterious guide who aids the Tarnished', FALSE),
(3, 'Ellie', 'Protagonist', 'Young woman seeking revenge', TRUE),
(3, 'Abby', 'Protagonist', 'Soldier with her own mission', TRUE),
(4, 'Michael De Santa', 'Protagonist', 'Former bank robber in witness protection', TRUE),
(4, 'Trevor Philips', 'Protagonist', 'Volatile criminal and pilot', TRUE),
(4, 'Franklin Clinton', 'Protagonist', 'Street hustler from Los Santos', TRUE),
(5, 'Link', 'Protagonist', 'Hero chosen to defeat Calamity Ganon', TRUE),
(5, 'Zelda', 'Supporting', 'Princess of Hyrule', FALSE),
(6, 'Miles Morales', 'Protagonist', 'Teenage Spider-Man with unique powers', TRUE),
(7, 'Dragonborn', 'Protagonist', 'Prophesied hero who can absorb dragon souls', TRUE),
(8, 'Arthur Morgan', 'Protagonist', 'Outlaw and member of the Van der Linde gang', TRUE);

-- Insert Achievements
INSERT INTO Achievements (game_id, name, description, points, rarity) VALUES
(1, 'Lilac and Gooseberries', 'Find Yennefer of Vengerberg', 15, 'Common'),
(1, 'Master Marksman', 'Kill 50 enemies with crossbow bolts', 20, 'Uncommon'),
(1, 'Card Collector', 'Acquire all gwent cards', 75, 'Rare'),
(2, 'Elden Lord', 'Complete the game and become Elden Lord', 100, 'Epic'),
(2, 'Shardbearer', 'Defeat a demigod and obtain a Great Rune', 30, 'Common'),
(3, 'Outbreak', 'Complete the main story', 90, 'Common'),
(3, 'Perfectionist', 'Collect all trophies', 100, 'Legendary'),
(4, 'Welcome to Los Santos', 'Complete the first mission', 10, 'Common'),
(4, 'All''s Fare in Love and War', 'Complete taxi missions', 30, 'Uncommon'),
(5, 'Defeat Ganon', 'Complete the main quest', 100, 'Common'),
(5, 'Divine Beast Master', 'Free all Divine Beasts', 40, 'Common'),
(6, 'Be Yourself', 'Complete the main story', 90, 'Common'),
(7, 'Dragonslayer', 'Complete main quest', 100, 'Common'),
(8, 'Redemption', 'Complete the main story', 100, 'Common');

-- Insert Sample Users
INSERT INTO Users (username, email, password_hash, display_name, country) VALUES
('gamer123', 'gamer123@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123456', 'ProGamer', 'USA'),
('rpg_master', 'rpgmaster@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123456', 'RPG Master', 'Canada'),
('casual_player', 'casual@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123456', 'CasualGamer', 'UK'),
('speedrunner', 'speedrun@example.com', '$2y$10$abcdefghijklmnopqrstuvwxyz123456', 'SpeedDemon', 'Germany');

-- Insert Reviews
INSERT INTO Reviews (game_id, user_id, rating, title, review_text, playtime_hours, recommended) VALUES
(1, 1, 9.5, 'Masterpiece', 'One of the best RPGs ever made. Amazing story, great characters, beautiful world.', 150.5, TRUE),
(1, 2, 10.0, 'Perfect Game', 'Absolutely phenomenal in every way. A must-play for any RPG fan.', 200.0, TRUE),
(2, 1, 9.0, 'Challenging but Rewarding', 'Difficult but fair. Exploration is amazing.', 80.0, TRUE),
(3, 3, 8.5, 'Emotional Journey', 'Great graphics and storytelling, though divisive narrative.', 25.0, TRUE),
(4, 4, 9.0, 'Still Amazing', 'Years later and still one of the best open-world games.', 300.0, TRUE);

-- Insert User Library
INSERT INTO User_Library (user_id, game_id, platform_id, playtime_hours, status, completion_percentage) VALUES
(1, 1, 4, 150.5, 'Completed', 95.0),
(1, 2, 1, 80.0, 'Playing', 60.0),
(1, 4, 4, 300.0, 'Completed', 85.0),
(2, 1, 4, 200.0, 'Completed', 100.0),
(2, 7, 3, 120.0, 'Playing', 70.0),
(3, 3, 5, 25.0, 'Completed', 100.0),
(4, 4, 1, 150.0, 'Playing', 45.0);

-- Insert User Achievements
INSERT INTO User_Achievements (user_id, achievement_id) VALUES
(1, 1), (1, 2), (1, 5), (1, 8), (1, 9),
(2, 1), (2, 2), (2, 3),
(3, 6), (3, 7),
(4, 8);

-- Insert DLC
INSERT INTO DLC (game_id, name, description, release_date, price) VALUES
(1, 'Hearts of Stone', 'First expansion with 10+ hours of new content', '2015-10-13', 9.99),
(1, 'Blood and Wine', 'Second expansion with 20+ hours of new content', '2016-05-31', 19.99),
(7, 'Dawnguard', 'Join the vampire hunters or become a vampire lord', '2012-06-26', 19.99),
(7, 'Dragonborn', 'Travel to the island of Solstheim', '2012-12-04', 19.99);

-- Insert System Requirements
INSERT INTO System_Requirements (game_id, platform_id, requirement_type, os, processor, memory_gb, graphics, directx, storage_gb) VALUES
(1, 4, 'Minimum', 'Windows 7 64-bit', 'Intel Core i5-2500K 3.3GHz', 6, 'Nvidia GTX 660', 'Version 11', 40),
(1, 4, 'Recommended', 'Windows 10 64-bit', 'Intel Core i7-3770 3.4GHz', 8, 'Nvidia GTX 770', 'Version 11', 40),
(2, 4, 'Minimum', 'Windows 10', 'Intel Core i5-8400', 12, 'Nvidia GTX 1060', 'Version 12', 60),
(2, 4, 'Recommended', 'Windows 10/11', 'Intel Core i7-8700K', 16, 'Nvidia GTX 1070', 'Version 12', 60);
