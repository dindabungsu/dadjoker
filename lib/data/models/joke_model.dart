// Joke Model
class Joke {
  final int id;
  final String category;
  final String setup;
  final String punchline;

  Joke({
    required this.id,
    required this.category,
    required this.setup,
    required this.punchline,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      category: json['category'],
      setup: json['setup'],
      punchline: json['punchline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'setup': setup,
      'punchline': punchline,
    };
  }
}