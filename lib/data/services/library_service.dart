import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/joke_model.dart';

class LibraryService {
  static final LibraryService _instance = LibraryService._internal();
  factory LibraryService() => _instance;
  LibraryService._internal();

  static const String _savedJokesKey = 'saved_jokes';
  List<Joke> _savedJokes = [];

  /// Load all saved jokes from local storage
  Future<void> loadSavedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_savedJokesKey);

    if (savedData != null) {
      final List<dynamic> jsonList = json.decode(savedData);
      _savedJokes = jsonList.map((json) => Joke.fromJson(json)).toList();
    }
  }

  /// Save a joke to the library
  Future<bool> saveJoke(Joke joke) async {
    // Check if joke already exists
    if (_savedJokes.any((j) => j.id == joke.id)) {
      return false; // Already saved
    }

    _savedJokes.add(joke);
    await _persistJokes();
    return true;
  }

  /// Remove a joke from the library
  Future<bool> removeJoke(int jokeId) async {
    final initialLength = _savedJokes.length;
    _savedJokes.removeWhere((joke) => joke.id == jokeId);

    if (_savedJokes.length < initialLength) {
      await _persistJokes();
      return true;
    }
    return false;
  }

  /// Check if a joke is already saved
  bool isJokeSaved(int jokeId) {
    return _savedJokes.any((joke) => joke.id == jokeId);
  }

  /// Get all saved jokes
  List<Joke> getSavedJokes() {
    return List.unmodifiable(_savedJokes);
  }

  /// Get jokes filtered by category
  List<Joke> getJokesByCategory(String category) {
    return _savedJokes
        .where((joke) => joke.category == category)
        .toList();
  }

  /// Get list of categories that have saved jokes
  List<String> getSavedCategories() {
    return _savedJokes
        .map((joke) => joke.category)
        .toSet()
        .toList()
      ..sort();
  }

  /// Get the count of saved jokes
  int getSavedJokesCount() {
    return _savedJokes.length;
  }

  /// Clear all saved jokes
  Future<void> clearAllJokes() async {
    _savedJokes.clear();
    await _persistJokes();
  }

  /// Private method to persist jokes to local storage
  Future<void> _persistJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonData = json.encode(
      _savedJokes.map((joke) => {
        'id': joke.id,
        'category': joke.category,
        'setup': joke.setup,
        'punchline': joke.punchline,
      }).toList(),
    );
    await prefs.setString(_savedJokesKey, jsonData);
  }
}
