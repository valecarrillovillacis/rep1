# API Reference Guide

This document provides guidance for building an API on top of the videogame database.

## RESTful API Endpoint Suggestions

### Games

#### GET /api/games
Get all games with optional filtering and pagination.

**Query Parameters:**
- `page` (integer): Page number (default: 1)
- `limit` (integer): Results per page (default: 20, max: 100)
- `platform` (string): Filter by platform name
- `genre` (string): Filter by genre name
- `publisher` (string): Filter by publisher name
- `esrb_rating` (string): Filter by ESRB rating
- `sort` (string): Sort field (title, release_date, price, rating)
- `order` (string): Sort order (asc, desc)

**SQL Query:**
```sql
SELECT * FROM v_game_details
WHERE 1=1
  AND (? IS NULL OR platforms LIKE CONCAT('%', ?, '%'))
  AND (? IS NULL OR genres LIKE CONCAT('%', ?, '%'))
  AND (? IS NULL OR publisher = ?)
  AND (? IS NULL OR esrb_rating = ?)
ORDER BY ? ?
LIMIT ? OFFSET ?;
```

#### GET /api/games/:id
Get detailed information about a specific game.

**SQL Query:**
```sql
SELECT * FROM v_game_details WHERE game_id = ?;
```

#### POST /api/games
Create a new game (admin only).

**Request Body:**
```json
{
  "title": "Game Title",
  "publisher_id": 1,
  "developer_id": 1,
  "release_date": "2024-01-01",
  "description": "Game description",
  "esrb_rating": "T",
  "multiplayer": true,
  "price": 59.99
}
```

**SQL Query:**
```sql
INSERT INTO Games (title, publisher_id, developer_id, release_date, 
                   description, esrb_rating, multiplayer, price)
VALUES (?, ?, ?, ?, ?, ?, ?, ?);
```

#### PUT /api/games/:id
Update a game (admin only).

#### DELETE /api/games/:id
Delete a game (admin only).

### Platforms

#### GET /api/platforms
Get all platforms.

**SQL Query:**
```sql
SELECT * FROM v_platform_statistics;
```

#### GET /api/platforms/:id/games
Get all games for a specific platform.

**SQL Query:**
```sql
SELECT g.* FROM Games g
JOIN Game_Platforms gp ON g.game_id = gp.game_id
WHERE gp.platform_id = ?;
```

### Genres

#### GET /api/genres
Get all genres with statistics.

**SQL Query:**
```sql
SELECT * FROM v_genre_statistics;
```

#### GET /api/genres/:id/games
Get all games in a specific genre.

**SQL Query:**
```sql
SELECT g.* FROM Games g
JOIN Game_Genres gg ON g.game_id = gg.game_id
WHERE gg.genre_id = ?;
```

### Reviews

#### GET /api/games/:id/reviews
Get all reviews for a game.

**Query Parameters:**
- `page` (integer): Page number
- `limit` (integer): Results per page
- `sort` (string): rating, created_at, helpful_count

**SQL Query:**
```sql
SELECT r.*, u.username, u.display_name
FROM Reviews r
JOIN Users u ON r.user_id = u.user_id
WHERE r.game_id = ?
ORDER BY ? DESC
LIMIT ? OFFSET ?;
```

#### POST /api/games/:id/reviews
Submit a review for a game (authenticated user).

**Request Body:**
```json
{
  "rating": 8.5,
  "title": "Great game!",
  "review_text": "Detailed review...",
  "playtime_hours": 50.5,
  "recommended": true
}
```

**SQL Query:**
```sql
INSERT INTO Reviews (game_id, user_id, rating, title, review_text, 
                     playtime_hours, recommended)
VALUES (?, ?, ?, ?, ?, ?, ?);
```

#### PUT /api/reviews/:id
Update a review (owner only).

#### DELETE /api/reviews/:id
Delete a review (owner or admin).

### User Library

#### GET /api/users/:id/library
Get a user's game library.

**Query Parameters:**
- `status` (string): Filter by status (Playing, Completed, Backlog, etc.)
- `platform` (string): Filter by platform

**SQL Query:**
```sql
SELECT * FROM v_user_library_details
WHERE username = ?
  AND (? IS NULL OR status = ?)
  AND (? IS NULL OR platform = ?)
ORDER BY playtime_hours DESC;
```

#### POST /api/users/:id/library
Add a game to user's library.

**Request Body:**
```json
{
  "game_id": 1,
  "platform_id": 1,
  "status": "Playing"
}
```

**SQL Query:**
```sql
INSERT INTO User_Library (user_id, game_id, platform_id, status)
VALUES (?, ?, ?, ?);
```

#### PUT /api/users/:id/library/:game_id
Update library entry (playtime, status, completion).

**Request Body:**
```json
{
  "playtime_hours": 75.5,
  "status": "Completed",
  "completion_percentage": 100
}
```

**SQL Query:**
```sql
UPDATE User_Library
SET playtime_hours = ?, status = ?, completion_percentage = ?,
    last_played = CURRENT_TIMESTAMP
WHERE user_id = ? AND game_id = ?;
```

### Achievements

#### GET /api/games/:id/achievements
Get all achievements for a game.

**SQL Query:**
```sql
SELECT * FROM Achievements WHERE game_id = ? ORDER BY points DESC;
```

#### GET /api/users/:id/achievements
Get user's unlocked achievements.

**Query Parameters:**
- `game_id` (integer): Filter by game

**SQL Query:**
```sql
SELECT a.*, ua.unlocked_at, g.title AS game_title
FROM User_Achievements ua
JOIN Achievements a ON ua.achievement_id = a.achievement_id
JOIN Games g ON a.game_id = g.game_id
WHERE ua.user_id = ?
  AND (? IS NULL OR a.game_id = ?)
ORDER BY ua.unlocked_at DESC;
```

#### POST /api/users/:id/achievements
Unlock an achievement for a user.

**Request Body:**
```json
{
  "achievement_id": 1
}
```

**SQL Query:**
```sql
INSERT INTO User_Achievements (user_id, achievement_id)
VALUES (?, ?);
```

### Search

#### GET /api/search
Global search across games.

**Query Parameters:**
- `q` (string): Search query
- `type` (string): games, publishers, developers

**SQL Query for Games:**
```sql
SELECT * FROM v_game_details
WHERE title LIKE CONCAT('%', ?, '%')
   OR publisher LIKE CONCAT('%', ?, '%')
   OR developer LIKE CONCAT('%', ?, '%')
LIMIT 20;
```

### Statistics

#### GET /api/statistics/games
General game statistics.

**Response:**
```json
{
  "total_games": 1500,
  "total_platforms": 25,
  "total_publishers": 300,
  "average_rating": 7.8,
  "total_reviews": 45000
}
```

**SQL Query:**
```sql
SELECT 
  (SELECT COUNT(*) FROM Games) AS total_games,
  (SELECT COUNT(*) FROM Platforms) AS total_platforms,
  (SELECT COUNT(*) FROM Publishers) AS total_publishers,
  (SELECT ROUND(AVG(rating), 1) FROM Reviews) AS average_rating,
  (SELECT COUNT(*) FROM Reviews) AS total_reviews;
```

#### GET /api/statistics/users/:id
User-specific statistics.

**SQL Query:**
```sql
SELECT * FROM v_user_statistics WHERE user_id = ?;
```

### Publishers and Developers

#### GET /api/publishers
Get all publishers.

**SQL Query:**
```sql
SELECT * FROM v_publisher_portfolio;
```

#### GET /api/publishers/:id
Get publisher details.

#### GET /api/publishers/:id/games
Get all games by publisher.

**SQL Query:**
```sql
SELECT g.* FROM Games g WHERE g.publisher_id = ?;
```

#### GET /api/developers
Get all developers.

**SQL Query:**
```sql
SELECT * FROM v_developer_portfolio;
```

## Authentication Endpoints

### POST /api/auth/register
Register a new user.

**Request Body:**
```json
{
  "username": "newuser",
  "email": "user@example.com",
  "password": "securepassword",
  "display_name": "Display Name"
}
```

**SQL Query:**
```sql
INSERT INTO Users (username, email, password_hash, display_name)
VALUES (?, ?, ?, ?);
```

### POST /api/auth/login
Login user.

**Request Body:**
```json
{
  "username": "user",
  "password": "password"
}
```

**SQL Query:**
```sql
SELECT user_id, username, email, password_hash
FROM Users
WHERE username = ? AND is_active = TRUE;
```

### POST /api/auth/logout
Logout user.

### GET /api/auth/me
Get current user info (authenticated).

## Response Format

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "GAME_NOT_FOUND",
    "message": "Game with ID 999 not found"
  }
}
```

## Error Codes

- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `409` - Conflict (e.g., duplicate entry)
- `422` - Unprocessable Entity (validation error)
- `500` - Internal Server Error

## Rate Limiting

Suggested rate limits:
- Anonymous: 100 requests/hour
- Authenticated: 1000 requests/hour
- Admin: Unlimited

## Security Considerations

1. **Password Hashing**: Use bcrypt or Argon2
2. **SQL Injection**: Always use prepared statements
3. **Authentication**: Use JWT or session-based auth
4. **Authorization**: Verify user permissions for write operations
5. **Input Validation**: Validate all user inputs
6. **HTTPS**: Always use HTTPS in production
7. **CORS**: Configure appropriate CORS policies
8. **Rate Limiting**: Implement rate limiting to prevent abuse

## Example Implementation (Node.js + Express)

```javascript
const express = require('express');
const mysql = require('mysql2/promise');

const app = express();
app.use(express.json());

// Database connection
const pool = mysql.createPool({
  host: 'localhost',
  user: 'videogame_user',
  password: 'password',
  database: 'videogame_db',
  waitForConnections: true,
  connectionLimit: 10
});

// Get all games
app.get('/api/games', async (req, res) => {
  try {
    const { page = 1, limit = 20, platform, genre } = req.query;
    const offset = (page - 1) * limit;
    
    let query = 'SELECT * FROM v_game_details WHERE 1=1';
    const params = [];
    
    if (platform) {
      query += ' AND platforms LIKE ?';
      params.push(`%${platform}%`);
    }
    
    if (genre) {
      query += ' AND genres LIKE ?';
      params.push(`%${genre}%`);
    }
    
    query += ' LIMIT ? OFFSET ?';
    params.push(parseInt(limit), offset);
    
    const [rows] = await pool.query(query, params);
    
    res.json({
      success: true,
      data: rows,
      meta: { page: parseInt(page), limit: parseInt(limit) }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: { message: error.message }
    });
  }
});

// Get game by ID
app.get('/api/games/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM v_game_details WHERE game_id = ?',
      [req.params.id]
    );
    
    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: { message: 'Game not found' }
      });
    }
    
    res.json({ success: true, data: rows[0] });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: { message: error.message }
    });
  }
});

app.listen(3000, () => {
  console.log('API server running on port 3000');
});
```

## Caching Strategy

Implement caching for frequently accessed data:

1. **Redis** for API response caching
2. **Cache invalidation** on data updates
3. **TTL** (Time To Live) settings:
   - Game details: 1 hour
   - User library: 5 minutes
   - Statistics: 15 minutes
   - Reviews: 10 minutes

## WebSocket Events (Real-time)

For real-time features:

```javascript
// New review posted
socket.emit('review:new', { game_id, review });

// Achievement unlocked
socket.emit('achievement:unlocked', { user_id, achievement });

// User status update
socket.emit('user:status', { user_id, status });
```
