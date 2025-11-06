-- ============================================
-- Videogame Repository Database Schema
-- ============================================
-- This schema provides a comprehensive structure for managing
-- videogame data including games, platforms, developers, and more.

-- ============================================
-- Core Entity Tables
-- ============================================

-- Publishers Table
CREATE TABLE Publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    founded_year INT,
    website VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Developers Table
CREATE TABLE Developers (
    developer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(100),
    founded_year INT,
    website VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Platforms Table
CREATE TABLE Platforms (
    platform_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    manufacturer VARCHAR(100),
    release_year INT,
    platform_type ENUM('Console', 'PC', 'Mobile', 'Handheld', 'VR', 'Cloud') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Genres Table
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Games Table
CREATE TABLE Games (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    developer_id INT,
    release_date DATE,
    description TEXT,
    esrb_rating ENUM('E', 'E10+', 'T', 'M', 'AO', 'RP') DEFAULT 'RP',
    multiplayer BOOLEAN DEFAULT FALSE,
    online_play BOOLEAN DEFAULT FALSE,
    max_players INT DEFAULT 1,
    file_size_mb DECIMAL(10, 2),
    price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL,
    FOREIGN KEY (developer_id) REFERENCES Developers(developer_id) ON DELETE SET NULL,
    INDEX idx_title (title),
    INDEX idx_release_date (release_date)
);

-- ============================================
-- Relationship Tables (Many-to-Many)
-- ============================================

-- Game-Platform Relationship
CREATE TABLE Game_Platforms (
    game_platform_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    platform_id INT NOT NULL,
    release_date DATE,
    exclusive BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platforms(platform_id) ON DELETE CASCADE,
    UNIQUE KEY unique_game_platform (game_id, platform_id)
);

-- Game-Genre Relationship
CREATE TABLE Game_Genres (
    game_genre_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    genre_id INT NOT NULL,
    primary_genre BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id) ON DELETE CASCADE,
    UNIQUE KEY unique_game_genre (game_id, genre_id)
);

-- ============================================
-- Game Detail Tables
-- ============================================

-- Characters Table
CREATE TABLE Characters (
    character_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    character_type ENUM('Protagonist', 'Antagonist', 'Supporting', 'NPC') DEFAULT 'Supporting',
    description TEXT,
    playable BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    INDEX idx_game_id (game_id)
);

-- Achievements Table
CREATE TABLE Achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    points INT DEFAULT 0,
    rarity ENUM('Common', 'Uncommon', 'Rare', 'Epic', 'Legendary') DEFAULT 'Common',
    hidden BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    INDEX idx_game_id (game_id)
);

-- ============================================
-- User-Generated Content Tables
-- ============================================

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100),
    country VARCHAR(100),
    date_of_birth DATE,
    account_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_email (email)
);

-- Reviews Table
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    user_id INT NOT NULL,
    rating DECIMAL(3, 1) CHECK (rating >= 0 AND rating <= 10),
    title VARCHAR(255),
    review_text TEXT,
    playtime_hours DECIMAL(10, 1),
    recommended BOOLEAN,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_game_review (user_id, game_id),
    INDEX idx_game_id (game_id),
    INDEX idx_rating (rating)
);

-- User Game Library
CREATE TABLE User_Library (
    library_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    platform_id INT,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    playtime_hours DECIMAL(10, 1) DEFAULT 0,
    last_played TIMESTAMP,
    completion_percentage DECIMAL(5, 2) DEFAULT 0,
    status ENUM('Playing', 'Completed', 'Backlog', 'Wishlist', 'Abandoned') DEFAULT 'Backlog',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platforms(platform_id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_game (user_id, game_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- User Achievements
CREATE TABLE User_Achievements (
    user_achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    achievement_id INT NOT NULL,
    unlocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES Achievements(achievement_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_achievement (user_id, achievement_id),
    INDEX idx_user_id (user_id)
);

-- ============================================
-- Additional Features Tables
-- ============================================

-- DLC (Downloadable Content) Table
CREATE TABLE DLC (
    dlc_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    release_date DATE,
    price DECIMAL(10, 2),
    file_size_mb DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    INDEX idx_game_id (game_id)
);

-- Game Updates/Patches
CREATE TABLE Game_Updates (
    update_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    version VARCHAR(50) NOT NULL,
    release_date DATE,
    size_mb DECIMAL(10, 2),
    patch_notes TEXT,
    update_type ENUM('Patch', 'Hotfix', 'Major Update', 'Season') DEFAULT 'Patch',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    INDEX idx_game_id (game_id),
    INDEX idx_version (version)
);

-- System Requirements
CREATE TABLE System_Requirements (
    requirement_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT NOT NULL,
    platform_id INT NOT NULL,
    requirement_type ENUM('Minimum', 'Recommended') NOT NULL,
    os VARCHAR(255),
    processor VARCHAR(255),
    memory_gb INT,
    graphics VARCHAR(255),
    directx VARCHAR(50),
    storage_gb INT,
    additional_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Platforms(platform_id) ON DELETE CASCADE,
    UNIQUE KEY unique_game_platform_type (game_id, platform_id, requirement_type)
);

-- ============================================
-- Indexes for Performance
-- ============================================

CREATE INDEX idx_games_publisher ON Games(publisher_id);
CREATE INDEX idx_games_developer ON Games(developer_id);
CREATE INDEX idx_game_platforms_game ON Game_Platforms(game_id);
CREATE INDEX idx_game_platforms_platform ON Game_Platforms(platform_id);
CREATE INDEX idx_game_genres_game ON Game_Genres(game_id);
CREATE INDEX idx_game_genres_genre ON Game_Genres(genre_id);
