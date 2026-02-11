import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/joke_model.dart';
import '../../data/services/joke_service.dart';
import '../../data/services/library_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedCategory;
  Joke? currentJoke;
  bool showPunchline = false;
  bool isLoading = false;
  bool isSaved = false;

  final List<Map<String, dynamic>> categories = [
    {'name': 'animals', 'emoji': '🐶'},
    {'name': 'food', 'emoji': '🍔'},
    {'name': 'science', 'emoji': '🔬'},
    {'name': 'puns', 'emoji': '✨'},
    {'name': 'family', 'emoji': '👨‍👩‍👧‍👦'},
    {'name': 'sports', 'emoji': '⚽'},
    {'name': 'technology', 'emoji': '💻'},
    {'name': 'work', 'emoji': '💼'},
    {'name': 'random', 'emoji': '🎲'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await JokeService().loadJokes();
    await LibraryService().loadSavedJokes();
  }

  void _generateJoke() {
    if (selectedCategory == null) return;

    setState(() {
      isLoading = true;
      showPunchline = false;
    });

    try {
      final joke = JokeService().getRandomJokeByCategory(selectedCategory!);
      setState(() {
        currentJoke = joke;
        isSaved = LibraryService().isJokeSaved(joke.id);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _toggleSave() async {
    if (currentJoke == null) return;

    if (isSaved) {
      await LibraryService().removeJoke(currentJoke!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from library'),
            backgroundColor: Color(0xFF8B4513),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      await LibraryService().saveJoke(currentJoke!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to library!'),
            backgroundColor: Color(0xFF6B8E23),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B4513),
        elevation: 0,
        title: const Text(
          'DadJoker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books, color: Colors.white),
            onPressed: () {
              context.push("/library");
            },
            tooltip: 'My Library',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header with dad vibes
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '👨',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Flexible(
                            child: Text(
                              'DadJoker',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'serif',
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Guaranteed to make you groan!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Category Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF8B4513),
                      width: 3,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Row(
                        children: [
                          Text('👇', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Text(
                            'Pick a category, kiddo!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF654321),
                            ),
                          ),
                        ],
                      ),
                      value: selectedCategory,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF8B4513),
                        size: 30,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF654321),
                      ),
                      dropdownColor: const Color(0xFFFFE5B4),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Row(
                            children: [
                              Text(
                                category['emoji'],
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                category['name'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          currentJoke = null;
                          showPunchline = false;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Generate Button
                ElevatedButton(
                  onPressed: selectedCategory == null ? null : _generateJoke,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TELL ME A JOKE!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('😄', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Joke Display Area
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF8B4513),
                      ),
                    ),
                  )
                else if (currentJoke != null) ...[
                  // Setup
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF8B4513),
                        width: 3,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🤔',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentJoke!.setup,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF654321),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Show Punchline Button or Punchline
                  if (!showPunchline)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showPunchline = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E23),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'SHOW PUNCHLINE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('👀', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    )
                  else ...[
                    // Punchline
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5B4),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF8B4513),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '😄',
                            style: TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentJoke!.punchline,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF654321),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Reaction
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF8B4513),
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'Classic dad joke! 🙄',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF654321),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Save Button
                        ElevatedButton(
                          onPressed: _toggleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSaved
                                ? const Color(0xFF6B8E23)
                                : Colors.white,
                            foregroundColor: isSaved
                                ? Colors.white
                                : const Color(0xFF8B4513),
                            side: BorderSide(
                              color: isSaved
                                  ? const Color(0xFF556B2F)
                                  : const Color(0xFF8B4513),
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSaved ? Icons.bookmark : Icons.bookmark_border,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isSaved ? 'SAVED' : 'SAVE',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Another Joke Button
                        ElevatedButton(
                          onPressed: _generateJoke,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B4513),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.refresh, size: 20, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'ANOTHER ONE!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}