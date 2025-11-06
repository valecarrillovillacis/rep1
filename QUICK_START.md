# Videogame Database Quick Reference

## Quick Setup
```bash
# 1. Create database
mysql -u root -p -e "CREATE DATABASE videogame_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Import schema
mysql -u root -p videogame_db < database/schema.sql

# 3. Load sample data
mysql -u root -p videogame_db < database/sample_data.sql

# 4. (Optional) Create views
mysql -u root -p videogame_db < database/views.sql
```

## Database Tables (16 Total)

### Core Tables
| Table | Purpose |
|-------|---------|
| **Games** | Main game information |
| **Publishers** | Game publishers |
| **Developers** | Development studios |
| **Platforms** | Gaming platforms |
| **Genres** | Game genres |

### User Tables
| Table | Purpose |
|-------|---------|
| **Users** | User accounts |
| **User_Library** | User's game collections |
| **Reviews** | User reviews and ratings |
| **User_Achievements** | Unlocked achievements |

### Game Details
| Table | Purpose |
|-------|---------|
| **Characters** | Game characters |
| **Achievements** | In-game achievements |
| **DLC** | Downloadable content |
| **Game_Updates** | Patches and updates |
| **System_Requirements** | Hardware requirements |

### Relationships
| Table | Purpose |
|-------|---------|
| **Game_Platforms** | Games ↔ Platforms |
| **Game_Genres** | Games ↔ Genres |

## Essential Queries

### Get All Games
```sql
SELECT * FROM v_game_details;
```

### Search Games
```sql
SELECT * FROM Games WHERE title LIKE '%Witcher%';
```

### Games by Platform
```sql
SELECT g.title, pl.name AS platform
FROM Games g
JOIN Game_Platforms gp ON g.game_id = gp.game_id
JOIN Platforms pl ON gp.platform_id = pl.platform_id
WHERE pl.name = 'PlayStation 5';
```

### Top Rated Games
```sql
SELECT * FROM v_top_rated_games LIMIT 10;
```

### User's Library
```sql
SELECT * FROM v_user_library_details WHERE username = 'gamer123';
```

### Game Reviews
```sql
SELECT * FROM v_recent_reviews WHERE game_title = 'Elden Ring';
```

## Common Operations

### Add a New Game
```sql
INSERT INTO Games (title, publisher_id, developer_id, release_date, price)
VALUES ('New Game', 1, 1, '2024-01-01', 59.99);
```

### Add Game to User Library
```sql
INSERT INTO User_Library (user_id, game_id, platform_id, status)
VALUES (1, 1, 1, 'Playing');
```

### Submit a Review
```sql
INSERT INTO Reviews (game_id, user_id, rating, title, review_text, recommended)
VALUES (1, 1, 9.5, 'Amazing!', 'Great game...', TRUE);
```

### Update Playtime
```sql
UPDATE User_Library
SET playtime_hours = 100, last_played = NOW()
WHERE user_id = 1 AND game_id = 1;
```

### Unlock Achievement
```sql
INSERT INTO User_Achievements (user_id, achievement_id)
VALUES (1, 1);
```

## Database Views

### Game Details
- `v_game_details` - Complete game info with platforms and genres
- `v_top_rated_games` - Highest rated games
- `v_game_content` - DLC and updates overview

### Statistics
- `v_platform_statistics` - Platform game counts
- `v_genre_statistics` - Genre distribution
- `v_achievement_statistics` - Achievement completion rates

### User Data
- `v_user_library_details` - User library with details
- `v_user_statistics` - User activity summary
- `v_recent_reviews` - Latest reviews

### Publishers/Developers
- `v_publisher_portfolio` - Publisher game counts and ratings
- `v_developer_portfolio` - Developer game counts and ratings

## File Reference

| File | Description |
|------|-------------|
| **schema.sql** | Database structure (273 lines) |
| **sample_data.sql** | Example data (203 lines) |
| **queries.sql** | Query examples (308 lines) |
| **views.sql** | Database views (243 lines) |
| **README.md** | Full documentation (298 lines) |
| **INSTALLATION.md** | Setup guide (229 lines) |
| **API_REFERENCE.md** | API design (548 lines) |
| **ER_DIAGRAM.md** | Visual schema (178 lines) |

## Key Features

✅ **16 normalized tables** with proper relationships  
✅ **Foreign key constraints** for data integrity  
✅ **Indexed columns** for query performance  
✅ **UTF-8 support** (utf8mb4) for international characters  
✅ **Sample data** with 8 games, platforms, users, reviews  
✅ **12+ database views** for common queries  
✅ **20+ query examples** for reference  
✅ **Complete API design** guide included  

## Support Resources

- 📖 Full documentation: `database/README.md`
- 🔧 Installation guide: `database/INSTALLATION.md`
- 🌐 API reference: `database/API_REFERENCE.md`
- 📊 ER diagram: `database/ER_DIAGRAM.md`
- 💡 Query examples: `database/queries.sql`

## Next Steps

1. ✅ Set up the database using INSTALLATION.md
2. ✅ Explore sample data with queries.sql
3. ✅ Review API_REFERENCE.md to build your app
4. ✅ Customize schema for your specific needs
5. ✅ Add more sample data or import real data

---

**Need Help?** Check the full documentation in the `database/` directory or create an issue in the repository.
