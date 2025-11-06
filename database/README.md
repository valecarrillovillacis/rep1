# Videogame Repository Database

A comprehensive database schema for managing videogame data, including games, platforms, developers, publishers, user reviews, achievements, and more.

## Overview

This database provides a complete solution for storing and managing videogame-related information. It's designed to support applications like game libraries, review platforms, achievement trackers, and game cataloging systems.

## Features

- **Core Game Data**: Store information about games, including titles, descriptions, ratings, and prices
- **Platform Support**: Track games across multiple platforms (consoles, PC, mobile, VR)
- **Genre Classification**: Categorize games by multiple genres
- **Publisher & Developer Tracking**: Maintain relationships between games and their creators
- **User Management**: Support for user accounts and game libraries
- **Review System**: Allow users to rate and review games
- **Achievement Tracking**: Store game achievements and track user progress
- **Character Database**: Catalog game characters with detailed information
- **DLC Management**: Track downloadable content and expansions
- **System Requirements**: Store hardware requirements for PC games
- **Game Updates**: Track patches and updates

## Database Structure

### Core Tables

#### Games
Main table storing videogame information.

**Key Fields:**
- `game_id`: Unique identifier
- `title`: Game name
- `publisher_id`: Foreign key to Publishers
- `developer_id`: Foreign key to Developers
- `release_date`: Official release date
- `esrb_rating`: Content rating (E, E10+, T, M, AO, RP)
- `multiplayer`: Whether the game supports multiplayer
- `price`: Current price

#### Publishers
Companies that publish games.

**Key Fields:**
- `publisher_id`: Unique identifier
- `name`: Publisher name
- `country`: Country of origin
- `founded_year`: Year established

#### Developers
Studios that develop games.

**Key Fields:**
- `developer_id`: Unique identifier
- `name`: Developer name
- `country`: Country of origin
- `founded_year`: Year established

#### Platforms
Gaming platforms (consoles, PC, mobile, etc.).

**Key Fields:**
- `platform_id`: Unique identifier
- `name`: Platform name
- `platform_type`: Type (Console, PC, Mobile, Handheld, VR, Cloud)
- `manufacturer`: Company that created the platform

#### Genres
Game genres for classification.

**Key Fields:**
- `genre_id`: Unique identifier
- `name`: Genre name (Action, RPG, Strategy, etc.)

### Relationship Tables

#### Game_Platforms
Many-to-many relationship between games and platforms.

**Key Fields:**
- `game_id`: Foreign key to Games
- `platform_id`: Foreign key to Platforms
- `release_date`: Platform-specific release date
- `exclusive`: Whether game is exclusive to this platform

#### Game_Genres
Many-to-many relationship between games and genres.

**Key Fields:**
- `game_id`: Foreign key to Games
- `genre_id`: Foreign key to Genres
- `primary_genre`: Indicates the main genre

### User Tables

#### Users
User account information.

**Key Fields:**
- `user_id`: Unique identifier
- `username`: Unique username
- `email`: User email
- `password_hash`: Hashed password

#### User_Library
Games owned by users.

**Key Fields:**
- `user_id`: Foreign key to Users
- `game_id`: Foreign key to Games
- `platform_id`: Platform owned on
- `playtime_hours`: Time spent playing
- `status`: Playing, Completed, Backlog, Wishlist, Abandoned
- `completion_percentage`: Progress percentage

#### Reviews
User reviews and ratings.

**Key Fields:**
- `review_id`: Unique identifier
- `game_id`: Foreign key to Games
- `user_id`: Foreign key to Users
- `rating`: Numerical rating (0-10)
- `recommended`: Boolean recommendation

### Game Detail Tables

#### Characters
Game characters.

**Key Fields:**
- `character_id`: Unique identifier
- `game_id`: Foreign key to Games
- `name`: Character name
- `character_type`: Protagonist, Antagonist, Supporting, NPC
- `playable`: Whether character is playable

#### Achievements
In-game achievements.

**Key Fields:**
- `achievement_id`: Unique identifier
- `game_id`: Foreign key to Games
- `name`: Achievement name
- `points`: Point value
- `rarity`: Common, Uncommon, Rare, Epic, Legendary

#### User_Achievements
Tracks which achievements users have unlocked.

**Key Fields:**
- `user_id`: Foreign key to Users
- `achievement_id`: Foreign key to Achievements
- `unlocked_at`: Timestamp when unlocked

#### DLC
Downloadable content and expansions.

**Key Fields:**
- `dlc_id`: Unique identifier
- `game_id`: Foreign key to Games
- `name`: DLC name
- `release_date`: Release date
- `price`: DLC price

#### System_Requirements
Hardware requirements for PC games.

**Key Fields:**
- `game_id`: Foreign key to Games
- `platform_id`: Foreign key to Platforms
- `requirement_type`: Minimum or Recommended
- `processor`, `memory_gb`, `graphics`, `storage_gb`: Specifications

## Installation

### Prerequisites
- MySQL 5.7+ or MariaDB 10.2+
- Database management tool (MySQL Workbench, phpMyAdmin, or command line)

### Setup Instructions

1. **Create the database:**
```sql
CREATE DATABASE videogame_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE videogame_db;
```

2. **Run the schema script:**
```bash
mysql -u username -p videogame_db < database/schema.sql
```

3. **Load sample data (optional):**
```bash
mysql -u username -p videogame_db < database/sample_data.sql
```

## Usage Examples

### Common Queries

See `database/queries.sql` for a comprehensive set of example queries.

**Get all games with their publishers:**
```sql
SELECT g.title, p.name AS publisher, g.release_date
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id
ORDER BY g.release_date DESC;
```

**Find games by platform:**
```sql
SELECT g.title, pl.name AS platform
FROM Games g
JOIN Game_Platforms gp ON g.game_id = gp.game_id
JOIN Platforms pl ON gp.platform_id = pl.platform_id
WHERE pl.name = 'PlayStation 5';
```

**Get user's game library:**
```sql
SELECT g.title, ul.playtime_hours, ul.status
FROM User_Library ul
JOIN Games g ON ul.game_id = g.game_id
WHERE ul.user_id = 1;
```

## Entity Relationship Diagram

```
Publishers ──┐
             ├──< Games >──┬── Game_Platforms ──< Platforms
Developers ──┘             ├── Game_Genres ──< Genres
                           ├── Characters
                           ├── Achievements ──< User_Achievements >── Users
                           ├── Reviews >── Users
                           ├── DLC
                           ├── Game_Updates
                           └── System_Requirements
                           
Users ──┬── User_Library
        ├── Reviews
        └── User_Achievements
```

## Data Model Highlights

### Normalization
- Database is normalized to 3NF (Third Normal Form)
- Prevents data redundancy
- Ensures data integrity through foreign key constraints

### Indexing
- Indexes on frequently queried columns (titles, dates, user IDs)
- Composite indexes on junction tables for many-to-many relationships
- Optimized for common query patterns

### Constraints
- Foreign key constraints maintain referential integrity
- Unique constraints prevent duplicate entries
- Check constraints ensure data validity (e.g., ratings between 0-10)
- ON DELETE CASCADE for dependent records
- ON DELETE SET NULL for optional relationships

## Best Practices

1. **Always use transactions** when inserting related data across multiple tables
2. **Index foreign keys** for better join performance
3. **Use prepared statements** to prevent SQL injection
4. **Implement proper password hashing** (bcrypt, Argon2) for user passwords
5. **Regular backups** of the database
6. **Monitor query performance** and optimize slow queries
7. **Use connection pooling** for better performance in applications

## Future Enhancements

Potential additions to the schema:
- Game streaming services integration
- Social features (friends, multiplayer sessions)
- Mod/workshop content tracking
- Esports and tournament data
- Game streaming/video content
- Wishlist and price tracking
- Multi-language support for game information
- Image and media management

## License

This database schema is provided as-is for educational and commercial use.

## Contributing

To suggest improvements or report issues, please create an issue or submit a pull request.

## Support

For questions or support, please refer to the documentation or create an issue in the repository.
