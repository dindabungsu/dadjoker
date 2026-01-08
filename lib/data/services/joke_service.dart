import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/joke_model.dart';

class JokeService {
  static final JokeService _instance = JokeService._internal();
  factory JokeService() => _instance;
  JokeService._internal();

  List<Joke> _allJokes = [];
  bool _isLoaded = false;

  /// Load all jokes from JSON (call once)
  Future<void> loadJokes() async {
    if (_isLoaded) return; // Skip if already loaded

    try {
      final String jsonString = await rootBundle.loadString('assets/data/jokes.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> jokesJson = jsonData['dad_jokes'];

      _allJokes = jokesJson.map((joke) => Joke.fromJson(joke)).toList();
      _isLoaded = true;

      print('✅ Loaded ${_allJokes.length} jokes successfully');
    } catch (e) {
      print('❌ Error loading jokes: $e');
      rethrow;
    }
  }

  /// Get random joke by category
  Joke getRandomJokeByCategory(String category) {
    final filteredJokes = _allJokes
        .where((joke) => joke.category == category)
        .toList();

    print('📚 Found ${filteredJokes.length} jokes in "$category" category');

    if (filteredJokes.isEmpty) {
      throw Exception('No jokes found for category: $category');
    }

    final random = Random();
    return filteredJokes[random.nextInt(filteredJokes.length)];
  }
}