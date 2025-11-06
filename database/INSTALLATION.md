# Installation and Setup Guide

This guide will help you set up the videogame database on your system.

## Prerequisites

Before you begin, ensure you have one of the following database systems installed:
- MySQL 5.7 or higher
- MariaDB 10.2 or higher

## Installation Steps

### Option 1: Using MySQL Command Line

1. **Create the database:**
```bash
mysql -u root -p -e "CREATE DATABASE videogame_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

2. **Import the schema:**
```bash
mysql -u root -p videogame_db < database/schema.sql
```

3. **Load sample data (optional):**
```bash
mysql -u root -p videogame_db < database/sample_data.sql
```

4. **Verify the installation:**
```bash
mysql -u root -p videogame_db -e "SHOW TABLES;"
```

### Option 2: Using MySQL Workbench

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Create a new schema/database named `videogame_db`
4. Set character set to `utf8mb4` and collation to `utf8mb4_unicode_ci`
5. Open the SQL file `database/schema.sql`
6. Execute the script
7. (Optional) Open and execute `database/sample_data.sql`

### Option 3: Using phpMyAdmin

1. Log in to phpMyAdmin
2. Click "New" to create a new database
3. Name it `videogame_db`
4. Select collation: `utf8mb4_unicode_ci`
5. Click "Create"
6. Select the new database
7. Click "Import" tab
8. Choose file: `database/schema.sql`
9. Click "Go"
10. (Optional) Repeat import for `database/sample_data.sql`

## Verification

After installation, verify the database is set up correctly:

```sql
-- Check all tables exist
SHOW TABLES;

-- Expected output: 16 tables
-- Achievements, Characters, DLC, Developers, Game_Genres, Game_Platforms,
-- Game_Updates, Games, Genres, Platforms, Publishers, Reviews,
-- System_Requirements, User_Achievements, User_Library, Users

-- If you loaded sample data, check it
SELECT COUNT(*) FROM Games;
-- Expected: 8 games

SELECT COUNT(*) FROM Publishers;
-- Expected: 8 publishers

SELECT COUNT(*) FROM Platforms;
-- Expected: 10 platforms
```

## Testing the Database

Run some example queries to ensure everything works:

```sql
-- List all games with their publishers
SELECT g.title, p.name AS publisher
FROM Games g
LEFT JOIN Publishers p ON g.publisher_id = p.publisher_id;

-- Get games by platform
SELECT g.title, pl.name AS platform
FROM Games g
JOIN Game_Platforms gp ON g.game_id = gp.game_id
JOIN Platforms pl ON gp.platform_id = pl.platform_id
WHERE pl.name = 'PlayStation 5';

-- Get average ratings
SELECT g.title, AVG(r.rating) AS avg_rating
FROM Games g
LEFT JOIN Reviews r ON g.game_id = r.game_id
GROUP BY g.game_id, g.title;
```

## Configuration for Applications

### Connection String Examples

**PHP (MySQLi):**
```php
$conn = new mysqli("localhost", "username", "password", "videogame_db");
mysqli_set_charset($conn, "utf8mb4");
```

**Python (MySQL Connector):**
```python
import mysql.connector

db = mysql.connector.connect(
    host="localhost",
    user="username",
    password="password",
    database="videogame_db",
    charset="utf8mb4"
)
```

**Node.js (mysql2):**
```javascript
const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'username',
    password: 'password',
    database: 'videogame_db',
    charset: 'utf8mb4'
});
```

**Java (JDBC):**
```java
String url = "jdbc:mysql://localhost:3306/videogame_db?characterEncoding=utf8mb4";
Connection conn = DriverManager.getConnection(url, "username", "password");
```

## User Permissions

Create a dedicated database user for your application:

```sql
-- Create user
CREATE USER 'videogame_user'@'localhost' IDENTIFIED BY 'secure_password';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON videogame_db.* TO 'videogame_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
```

## Database Maintenance

### Backup

**Create a backup:**
```bash
mysqldump -u root -p videogame_db > backup_videogame_db.sql
```

**Restore from backup:**
```bash
mysql -u root -p videogame_db < backup_videogame_db.sql
```

### Regular Maintenance

```sql
-- Optimize tables (run periodically)
OPTIMIZE TABLE Games;
OPTIMIZE TABLE Reviews;
OPTIMIZE TABLE User_Library;

-- Check table integrity
CHECK TABLE Games;
CHECK TABLE Reviews;

-- Analyze tables for query optimization
ANALYZE TABLE Games;
ANALYZE TABLE Reviews;
```

## Troubleshooting

### Common Issues

**Issue: Character encoding problems**
- Solution: Ensure your database, tables, and connection all use utf8mb4

**Issue: Foreign key constraint errors**
- Solution: Always insert parent records before child records
- Order: Publishers/Developers → Games → Game_Platforms, Characters, etc.

**Issue: Slow queries**
- Solution: Check that indexes are created (they should be in schema.sql)
- Run EXPLAIN on slow queries to optimize

**Issue: Import fails with syntax error**
- Solution: Check MySQL version (needs 5.7+)
- Some features like JSON might need newer versions

## Next Steps

1. Review the [database documentation](README.md)
2. Explore [example queries](queries.sql)
3. Study the [ER diagram](ER_DIAGRAM.md)
4. Start building your application!

## Getting Help

If you encounter issues:
1. Check the error message carefully
2. Verify MySQL version compatibility
3. Review the documentation
4. Create an issue in the repository with:
   - Your MySQL version
   - The error message
   - What you were trying to do
