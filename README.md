# Videogame Repository Database

A comprehensive database schema for managing videogame data, including games, platforms, developers, publishers, user reviews, achievements, and more.

## Overview

This repository contains a complete relational database schema designed for videogame management systems. It can be used for:
- Game library applications
- Review platforms
- Achievement tracking systems
- Game cataloging services
- Digital storefronts
- Gaming social networks

## Features

✅ **Core Game Data** - Complete game information including titles, descriptions, ratings, and prices  
✅ **Multi-Platform Support** - Track games across PC, consoles, mobile, VR, and cloud platforms  
✅ **Genre Classification** - Categorize games with multiple genres  
✅ **Publisher & Developer Tracking** - Maintain relationships with game creators  
✅ **User Management** - Support for user accounts and personal game libraries  
✅ **Review System** - User ratings and reviews with recommendations  
✅ **Achievement Tracking** - Store and track game achievements and user progress  
✅ **Character Database** - Catalog game characters with detailed information  
✅ **DLC Management** - Track downloadable content and expansions  
✅ **System Requirements** - Store hardware requirements for PC games  
✅ **Update Tracking** - Monitor game patches and updates  

## Database Structure

The database includes **18 tables** covering:

### Core Entities
- **Games** - Main game information
- **Publishers** - Game publishers
- **Developers** - Game development studios
- **Platforms** - Gaming platforms (PC, PlayStation, Xbox, Switch, etc.)
- **Genres** - Game genres (Action, RPG, Strategy, etc.)

### User Features
- **Users** - User accounts
- **User_Library** - User's game collections
- **Reviews** - User reviews and ratings
- **User_Achievements** - Achievement tracking

### Game Details
- **Characters** - Game characters
- **Achievements** - In-game achievements
- **DLC** - Downloadable content
- **Game_Updates** - Patches and updates
- **System_Requirements** - Hardware requirements

### Relationships
- **Game_Platforms** - Games available on multiple platforms
- **Game_Genres** - Games belonging to multiple genres

## Quick Start

### 1. Create the Database

```bash
# Create database
mysql -u root -p -e "CREATE DATABASE videogame_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import schema
mysql -u root -p videogame_db < database/schema.sql

# Load sample data (optional)
mysql -u root -p videogame_db < database/sample_data.sql
```

### 2. Explore Sample Data

The sample data includes:
- 8 popular games (The Witcher 3, Elden Ring, GTA V, etc.)
- Multiple platforms (PlayStation, Xbox, PC, Nintendo Switch)
- Publishers and developers
- User reviews and achievements
- Sample user libraries

### 3. Run Example Queries

```bash
# See example queries
cat database/queries.sql
```

## Documentation

- **[Database README](database/README.md)** - Comprehensive documentation
- **[Schema](database/schema.sql)** - Complete database schema
- **[Sample Data](database/sample_data.sql)** - Example data for testing
- **[Query Examples](database/queries.sql)** - Common query patterns
- **[ER Diagram](database/ER_DIAGRAM.md)** - Visual database structure

## Database Schema Highlights

### Key Relationships

```
Publishers → Games ← Developers
                ↓
         Game_Platforms → Platforms
         Game_Genres → Genres
         Characters
         Achievements → User_Achievements → Users
         Reviews → Users
         DLC
```

### Sample Query

```sql
-- Get all games with their platforms and average ratings
SELECT 
    g.title,
    GROUP_CONCAT(DISTINCT pl.name) AS platforms,
    AVG(r.rating) AS avg_rating
FROM Games g
LEFT JOIN Game_Platforms gp ON g.game_id = gp.game_id
LEFT JOIN Platforms pl ON gp.platform_id = pl.platform_id
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title;
```

## Use Cases

This database schema supports various applications:

1. **Game Library Manager** - Track your personal game collection
2. **Review Platform** - Build a game review and rating website
3. **Achievement Tracker** - Monitor gaming achievements across platforms
4. **Game Catalog** - Create a comprehensive game database
5. **Store Backend** - Power a digital game storefront
6. **Analytics Platform** - Analyze gaming trends and user preferences

## Technical Details

- **Database**: MySQL 5.7+ / MariaDB 10.2+
- **Normalization**: 3NF (Third Normal Form)
- **Character Set**: UTF-8 (utf8mb4)
- **Indexes**: Optimized for common queries
- **Constraints**: Foreign keys, unique constraints, check constraints

## Contributing

Contributions are welcome! Feel free to:
- Report bugs or issues
- Suggest new features or tables
- Submit pull requests with improvements
- Share your use cases

## License

This project is open source and available for educational and commercial use.

## Support

For questions or support:
- Check the [documentation](database/README.md)
- Review the [example queries](database/queries.sql)
- Open an issue in this repository
