import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/joke_model.dart';

class JokeService {
  List<Joke> _allJokes = [];

  Future<void> loadJokes() async {
    final String jsonString = await rootBundle.loadString('assets/jokes.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    final List<dynamic> jokesJson = jsonData['dad_jokes'];

    _allJokes = jokesJson.map((joke) => Joke.fromJson(joke)).toList();
  }

  Joke getRandomJokeByCategory(String category) {
    final filteredJokes = _allJokes.where((joke) => joke.category == category).toList();

    if (filteredJokes.isEmpty) {
      throw Exception('No jokes found for category: $category');
    }

    final random = Random();
    return filteredJokes[random.nextInt(filteredJokes.length)];
  }
}