"""
Unit tests for the Videogame Database
"""

import unittest
import os
import tempfile
from videogame_database import VideogameDatabase


class TestVideogameDatabase(unittest.TestCase):
    """Test cases for the VideogameDatabase class."""
    
    def setUp(self):
        """Set up test database before each test."""
        # Create a temporary database file
        self.test_db_fd, self.test_db_path = tempfile.mkstemp(suffix='.db')
        self.db = VideogameDatabase(self.test_db_path)
    
    def tearDown(self):
        """Clean up after each test."""
        self.db.close()
        os.close(self.test_db_fd)
        os.unlink(self.test_db_path)
    
    def test_add_game(self):
        """Test adding a game to the database."""
        game_id = self.db.add_game(
            title="Test Game",
            genre="Action",
            platform="PC",
            release_year=2023,
            developer="Test Dev",
            publisher="Test Pub",
            rating=8.5
        )
        self.assertIsNotNone(game_id)
        self.assertGreater(game_id, 0)
    
    def test_get_game(self):
        """Test retrieving a game by ID."""
        game_id = self.db.add_game("Test Game", "Action", "PC", 2023)
        game = self.db.get_game(game_id)
        
        self.assertIsNotNone(game)
        self.assertEqual(game['title'], "Test Game")
        self.assertEqual(game['genre'], "Action")
        self.assertEqual(game['platform'], "PC")
        self.assertEqual(game['release_year'], 2023)
    
    def test_get_nonexistent_game(self):
        """Test retrieving a game that doesn't exist."""
        game = self.db.get_game(9999)
        self.assertIsNone(game)
    
    def test_get_all_games(self):
        """Test retrieving all games."""
        self.db.add_game("Game 1", "RPG", "PC", 2020)
        self.db.add_game("Game 2", "FPS", "Xbox", 2021)
        self.db.add_game("Game 3", "Strategy", "PC", 2022)
        
        all_games = self.db.get_all_games()
        self.assertEqual(len(all_games), 3)
    
    def test_update_game(self):
        """Test updating a game's information."""
        game_id = self.db.add_game("Original Title", "Action", "PC", 2020, rating=7.0)
        
        # Update the game
        success = self.db.update_game(game_id, title="Updated Title", rating=9.0)
        self.assertTrue(success)
        
        # Verify the update
        updated_game = self.db.get_game(game_id)
        self.assertEqual(updated_game['title'], "Updated Title")
        self.assertEqual(updated_game['rating'], 9.0)
        self.assertEqual(updated_game['platform'], "PC")  # Unchanged field
    
    def test_update_nonexistent_game(self):
        """Test updating a game that doesn't exist."""
        success = self.db.update_game(9999, title="New Title")
        self.assertFalse(success)
    
    def test_delete_game(self):
        """Test deleting a game."""
        game_id = self.db.add_game("Game to Delete", "Action", "PC", 2020)
        
        # Delete the game
        success = self.db.delete_game(game_id)
        self.assertTrue(success)
        
        # Verify it's deleted
        game = self.db.get_game(game_id)
        self.assertIsNone(game)
    
    def test_delete_nonexistent_game(self):
        """Test deleting a game that doesn't exist."""
        success = self.db.delete_game(9999)
        self.assertFalse(success)
    
    def test_search_by_title(self):
        """Test searching games by title."""
        self.db.add_game("Legend of Heroes", "RPG", "PC", 2020)
        self.db.add_game("Legend of Zelda", "Action", "Switch", 2017)
        self.db.add_game("Final Fantasy", "RPG", "PS5", 2023)
        
        results = self.db.search_games(title="Legend")
        self.assertEqual(len(results), 2)
    
    def test_search_by_genre(self):
        """Test searching games by genre."""
        self.db.add_game("Game 1", "RPG", "PC", 2020)
        self.db.add_game("Game 2", "RPG", "PS5", 2021)
        self.db.add_game("Game 3", "FPS", "Xbox", 2022)
        
        results = self.db.search_games(genre="RPG")
        self.assertEqual(len(results), 2)
    
    def test_search_by_platform(self):
        """Test searching games by platform."""
        self.db.add_game("Game 1", "RPG", "PC", 2020)
        self.db.add_game("Game 2", "Action", "PC", 2021)
        self.db.add_game("Game 3", "FPS", "Xbox", 2022)
        
        results = self.db.search_games(platform="PC")
        self.assertEqual(len(results), 2)
    
    def test_search_by_min_rating(self):
        """Test searching games by minimum rating."""
        self.db.add_game("Game 1", "RPG", "PC", 2020, rating=7.5)
        self.db.add_game("Game 2", "Action", "PC", 2021, rating=9.0)
        self.db.add_game("Game 3", "FPS", "Xbox", 2022, rating=8.5)
        
        results = self.db.search_games(min_rating=8.0)
        self.assertEqual(len(results), 2)
    
    def test_search_multiple_criteria(self):
        """Test searching with multiple criteria."""
        self.db.add_game("Game 1", "RPG", "PC", 2020, rating=9.0)
        self.db.add_game("Game 2", "RPG", "PS5", 2021, rating=8.0)
        self.db.add_game("Game 3", "Action", "PC", 2022, rating=9.5)
        
        results = self.db.search_games(platform="PC", min_rating=8.5)
        self.assertEqual(len(results), 2)
    
    def test_get_statistics(self):
        """Test getting database statistics."""
        self.db.add_game("Game 1", "RPG", "PC", 2020, rating=8.0)
        self.db.add_game("Game 2", "RPG", "PS5", 2021, rating=9.0)
        self.db.add_game("Game 3", "Action", "PC", 2022, rating=7.5)
        
        stats = self.db.get_statistics()
        
        self.assertEqual(stats['total_games'], 3)
        self.assertEqual(stats['average_rating'], 8.17)
        self.assertEqual(len(stats['by_genre']), 2)
        self.assertEqual(len(stats['by_platform']), 2)
    
    def test_context_manager(self):
        """Test using the database as a context manager."""
        with VideogameDatabase(self.test_db_path) as db:
            game_id = db.add_game("Context Test", "Action", "PC", 2023)
            game = db.get_game(game_id)
            self.assertIsNotNone(game)
    
    def test_add_game_minimal_data(self):
        """Test adding a game with only required fields."""
        game_id = self.db.add_game("Minimal Game")
        game = self.db.get_game(game_id)
        
        self.assertIsNotNone(game)
        self.assertEqual(game['title'], "Minimal Game")
        self.assertIsNone(game['genre'])
        self.assertIsNone(game['platform'])
        self.assertIsNone(game['rating'])


if __name__ == '__main__':
    unittest.main()
