# Videogame Database

A simple, lightweight videogame database system built with Python and SQLite.

## Features

- **CRUD Operations**: Create, Read, Update, and Delete videogame records
- **Search & Filter**: Search games by title, genre, platform, developer, and rating
- **Statistics**: Get insights about your game collection
- **Lightweight**: Uses SQLite - no external database server required
- **Easy to Use**: Simple Python API with context manager support

## Quick Start

### Basic Usage

```python
from videogame_database import VideogameDatabase

# Create a database instance
db = VideogameDatabase()

# Add a game
game_id = db.add_game(
    title="The Legend of Zelda: Breath of the Wild",
    genre="Action-Adventure",
    platform="Switch",
    release_year=2017,
    developer="Nintendo",
    publisher="Nintendo",
    rating=9.7
)

# Get all games
all_games = db.get_all_games()
for game in all_games:
    print(f"{game['title']} ({game['release_year']}) - Rating: {game['rating']}")

# Search for games
action_games = db.search_games(genre="Action")

# Get statistics
stats = db.get_statistics()
print(f"Total games: {stats['total_games']}")
print(f"Average rating: {stats['average_rating']}")

# Close the database
db.close()
```

### Using Context Manager

```python
with VideogameDatabase() as db:
    db.add_game("Elden Ring", "Action RPG", "PC", 2022, rating=9.5)
    games = db.get_all_games()
```

## Running the Example

Run the included example to see the database in action:

```bash
python videogame_database.py
```

## Running Tests

Run the unit tests to verify functionality:

```bash
python test_videogame_database.py
```

## Database Schema

The database stores games with the following fields:

- **id**: Auto-incrementing primary key
- **title**: Game title (required)
- **genre**: Game genre (optional)
- **platform**: Gaming platform (optional)
- **release_year**: Year of release (optional)
- **developer**: Game developer/studio (optional)
- **publisher**: Game publisher (optional)
- **rating**: Game rating 0-10 (optional)
- **created_at**: Timestamp when record was created
- **updated_at**: Timestamp when record was last updated

## API Reference

### VideogameDatabase Class

#### Methods

- `add_game(title, genre, platform, release_year, developer, publisher, rating)` - Add a new game
- `get_game(game_id)` - Retrieve a game by ID
- `get_all_games()` - Get all games in the database
- `update_game(game_id, **kwargs)` - Update game information
- `delete_game(game_id)` - Delete a game
- `search_games(**criteria)` - Search for games matching criteria
- `get_statistics()` - Get collection statistics
- `close()` - Close database connection

## Requirements

- Python 3.6+
- SQLite3 (included with Python)

No external dependencies required!
