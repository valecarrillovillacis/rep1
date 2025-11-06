"""
Videogame Database
A simple database system for managing videogame information.
"""

import sqlite3
import json
from datetime import datetime
from typing import List, Dict, Optional


class VideogameDatabase:
    """A database system for managing videogame records."""
    
    def __init__(self, db_path: str = "videogames.db"):
        """Initialize the database connection.
        
        Args:
            db_path: Path to the SQLite database file
        """
        self.db_path = db_path
        self.conn = None
        self.cursor = None
        self._connect()
        self._create_tables()
    
    def _connect(self):
        """Establish connection to the database."""
        self.conn = sqlite3.connect(self.db_path)
        self.conn.row_factory = sqlite3.Row
        self.cursor = self.conn.cursor()
    
    def _create_tables(self):
        """Create database tables if they don't exist."""
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS videogames (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                genre TEXT,
                platform TEXT,
                release_year INTEGER,
                developer TEXT,
                publisher TEXT,
                rating REAL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        self.conn.commit()
    
    def add_game(self, title: str, genre: str = None, platform: str = None,
                 release_year: int = None, developer: str = None,
                 publisher: str = None, rating: float = None) -> int:
        """Add a new videogame to the database.
        
        Args:
            title: The title of the game
            genre: The genre of the game (e.g., RPG, FPS, Action)
            platform: The platform (e.g., PC, PS5, Xbox, Switch)
            release_year: Year the game was released
            developer: Game developer/studio
            publisher: Game publisher
            rating: Rating score (0-10)
        
        Returns:
            The ID of the newly added game
        """
        self.cursor.execute("""
            INSERT INTO videogames (title, genre, platform, release_year, developer, publisher, rating)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (title, genre, platform, release_year, developer, publisher, rating))
        self.conn.commit()
        return self.cursor.lastrowid
    
    def get_game(self, game_id: int) -> Optional[Dict]:
        """Retrieve a game by its ID.
        
        Args:
            game_id: The ID of the game to retrieve
        
        Returns:
            Dictionary containing game information or None if not found
        """
        self.cursor.execute("SELECT * FROM videogames WHERE id = ?", (game_id,))
        row = self.cursor.fetchone()
        return dict(row) if row else None
    
    def get_all_games(self) -> List[Dict]:
        """Retrieve all games from the database.
        
        Returns:
            List of dictionaries containing game information
        """
        self.cursor.execute("SELECT * FROM videogames ORDER BY title")
        return [dict(row) for row in self.cursor.fetchall()]
    
    def update_game(self, game_id: int, **kwargs) -> bool:
        """Update a game's information.
        
        Args:
            game_id: The ID of the game to update
            **kwargs: Fields to update (title, genre, platform, etc.)
        
        Returns:
            True if update was successful, False otherwise
        """
        allowed_fields = ['title', 'genre', 'platform', 'release_year', 
                         'developer', 'publisher', 'rating']
        
        updates = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not updates:
            return False
        
        set_clause = ", ".join([f"{k} = ?" for k in updates.keys()])
        values = list(updates.values()) + [game_id]
        
        self.cursor.execute(f"""
            UPDATE videogames 
            SET {set_clause}, updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        """, values)
        self.conn.commit()
        return self.cursor.rowcount > 0
    
    def delete_game(self, game_id: int) -> bool:
        """Delete a game from the database.
        
        Args:
            game_id: The ID of the game to delete
        
        Returns:
            True if deletion was successful, False otherwise
        """
        self.cursor.execute("DELETE FROM videogames WHERE id = ?", (game_id,))
        self.conn.commit()
        return self.cursor.rowcount > 0
    
    def search_games(self, **criteria) -> List[Dict]:
        """Search for games based on criteria.
        
        Args:
            **criteria: Search criteria (title, genre, platform, etc.)
        
        Returns:
            List of matching games
        """
        conditions = []
        values = []
        
        for key, value in criteria.items():
            if key in ['title', 'genre', 'platform', 'developer', 'publisher']:
                conditions.append(f"{key} LIKE ?")
                values.append(f"%{value}%")
            elif key == 'release_year':
                conditions.append(f"{key} = ?")
                values.append(value)
            elif key == 'min_rating':
                conditions.append("rating >= ?")
                values.append(value)
        
        if not conditions:
            return self.get_all_games()
        
        where_clause = " AND ".join(conditions)
        query = f"SELECT * FROM videogames WHERE {where_clause} ORDER BY title"
        
        self.cursor.execute(query, values)
        return [dict(row) for row in self.cursor.fetchall()]
    
    def get_statistics(self) -> Dict:
        """Get statistics about the game collection.
        
        Returns:
            Dictionary containing various statistics
        """
        stats = {}
        
        # Total games
        self.cursor.execute("SELECT COUNT(*) as count FROM videogames")
        stats['total_games'] = self.cursor.fetchone()['count']
        
        # Games by genre
        self.cursor.execute("""
            SELECT genre, COUNT(*) as count 
            FROM videogames 
            WHERE genre IS NOT NULL
            GROUP BY genre 
            ORDER BY count DESC
        """)
        stats['by_genre'] = [dict(row) for row in self.cursor.fetchall()]
        
        # Games by platform
        self.cursor.execute("""
            SELECT platform, COUNT(*) as count 
            FROM videogames 
            WHERE platform IS NOT NULL
            GROUP BY platform 
            ORDER BY count DESC
        """)
        stats['by_platform'] = [dict(row) for row in self.cursor.fetchall()]
        
        # Average rating
        self.cursor.execute("SELECT AVG(rating) as avg_rating FROM videogames WHERE rating IS NOT NULL")
        avg_rating = self.cursor.fetchone()['avg_rating']
        stats['average_rating'] = round(avg_rating, 2) if avg_rating else None
        
        return stats
    
    def close(self):
        """Close the database connection."""
        if self.conn:
            self.conn.close()
    
    def __enter__(self):
        """Context manager entry."""
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        self.close()


def main():
    """Example usage of the VideogameDatabase."""
    # Create database instance
    db = VideogameDatabase()
    
    # Add some sample games
    print("Adding sample games...")
    db.add_game("The Legend of Zelda: Breath of the Wild", "Action-Adventure", 
                "Switch", 2017, "Nintendo", "Nintendo", 9.7)
    db.add_game("Elden Ring", "Action RPG", "PC", 2022, 
                "FromSoftware", "Bandai Namco", 9.5)
    db.add_game("Red Dead Redemption 2", "Action-Adventure", "PS4", 2018,
                "Rockstar Games", "Rockstar Games", 9.8)
    db.add_game("Hades", "Roguelike", "PC", 2020, 
                "Supergiant Games", "Supergiant Games", 9.2)
    db.add_game("God of War", "Action-Adventure", "PS4", 2018,
                "Santa Monica Studio", "Sony Interactive Entertainment", 9.6)
    
    # Display all games
    print("\n=== All Games ===")
    for game in db.get_all_games():
        print(f"{game['id']}: {game['title']} ({game['release_year']}) - {game['platform']} - Rating: {game['rating']}")
    
    # Search for games
    print("\n=== Action-Adventure Games ===")
    action_games = db.search_games(genre="Action-Adventure")
    for game in action_games:
        print(f"  - {game['title']}")
    
    # Get statistics
    print("\n=== Statistics ===")
    stats = db.get_statistics()
    print(f"Total games: {stats['total_games']}")
    print(f"Average rating: {stats['average_rating']}")
    print("\nGames by genre:")
    for item in stats['by_genre']:
        print(f"  {item['genre']}: {item['count']}")
    print("\nGames by platform:")
    for item in stats['by_platform']:
        print(f"  {item['platform']}: {item['count']}")
    
    # Update a game
    print("\n=== Updating game ===")
    db.update_game(1, rating=9.9)
    updated_game = db.get_game(1)
    print(f"Updated rating for '{updated_game['title']}': {updated_game['rating']}")
    
    # Close database
    db.close()
    print("\nDatabase operations completed successfully!")


if __name__ == "__main__":
    main()
