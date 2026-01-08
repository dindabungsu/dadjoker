import 'package:flutter/material.dart';
import '../../data/models/joke_model.dart';
import '../../data/services/joke_service.dart';
import '../../data/services/library_service.dart';

// Joke Popup Dialog Widget
class JokePopup extends StatefulWidget {
  final String category;

  const JokePopup({super.key, required this.category});

  @override
  State<JokePopup> createState() => _JokePopupState();

  /// Show the joke popup dialog
  static Future<void> show(BuildContext context, String category) async {
    await JokeService().loadJokes(); // ✅ Correct - no parameter

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => JokePopup(category: category),
      );
    }
  }
}

class _JokePopupState extends State<JokePopup> {
  Joke? _currentJoke;
  bool _showPunchline = false;
  bool _isSaved = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeJoke();
  }

  Future<void> _initializeJoke() async {
    await LibraryService().loadSavedJokes();
    _loadJoke();
  }

  void _loadJoke() {
    try {
      final joke = JokeService().getRandomJokeByCategory(widget.category); // ✅ Correct
      setState(() {
        _currentJoke = joke;
        _showPunchline = false;
        _isSaved = LibraryService().isJokeSaved(joke.id);
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading joke: $e')),
          );
        }
      });
    }
  }

  Future<void> _toggleSaveJoke() async {
    if (_currentJoke == null) return;

    if (_isSaved) {
      await LibraryService().removeJoke(_currentJoke!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from library', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF8B4513),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      await LibraryService().saveJoke(_currentJoke!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to library!', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF6B8E23),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFF8B4513),
            width: 4,
          ),
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        // Header
          Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: const BoxDecoration(
          color: Color(0xFF8B4513),
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
          ),
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
          children: [
          const Text('👨', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
          widget.category.toUpperCase(),
          style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1,
          ),
          ),
          ],
          ),
          IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          ),
          ],
          ),
          ),

        // Content
          Flexible(
          child: _isLoading
          ? const Padding(
          padding: EdgeInsets.all(60.0),
          child: Center(
          child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
          Color(0xFF8B4513),
          ),
          ),
          ),
          )
              : _currentJoke == null
          ? const Padding(
          padding: EdgeInsets.all(60.0),
          child: Center(
          child: Text(
          'No joke available',
          style: TextStyle(
          fontSize: 16,
          color: Color(0xFF654321),
          ),
          ),
          ),
          )
              : SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Setup container
          Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          style: TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 12),
          Text(
          _currentJoke!.setup,
          textAlign: TextAlign.center,
          style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF654321),
          height: 1.4,
          ),
          ),
          ],
          ),
          ),
          const SizedBox(height: 20),

          // Punchline reveal button or punchline
          if (!_showPunchline)
          ElevatedButton(
          onPressed: () {
          setState(() {
          _showPunchline = true;
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
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
          ),
          ),
          SizedBox(width: 8),
          Text('👀', style: TextStyle(fontSize: 18)),
          ],
          ),
          )
          else
          Column(
          children: [
          // Punchline container
          Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
          style: TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 12),
          Text(
          _currentJoke!.punchline,
          textAlign: TextAlign.center,
          style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF654321),
          height: 1.4,
          ),
          ),
          ],
          ),
          ),
          const SizedBox(height: 16),

          // Reaction text
          Container(
          padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
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
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Color(0xFF654321),
          ),
          ),
          ),
          ],
          ),
          const SizedBox(height: 20),

          // Save and Another joke buttons
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Save to library button
          ElevatedButton(
          onPressed: _toggleSaveJoke,
          style: ElevatedButton.styleFrom(
          backgroundColor: _isSaved
          ? const Color(0xFF6B8E23)
              : Colors.white,
          foregroundColor: _isSaved
          ? Colors.white
              : const Color(0xFF8B4513),
          side: BorderSide(
          color: _isSaved
          ? const Color(0xFF556B2F)
              : const Color(0xFF8B4513),
          width: 2,
          ),
          padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
          ),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
          ),
          child: Icon(
          _isSaved ? Icons.bookmark : Icons.bookmark_border,
          size: 20,
          ),
          ),
          const SizedBox(width: 12),

          // Another joke button
          Expanded(
          child: OutlinedButton(
          onPressed: _loadJoke,
          style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF8B4513),
          side: const BorderSide(
          color: Color(0xFF8B4513),
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
          child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          Icon(Icons.refresh, size: 20),
          SizedBox(width: 8),
          Text(
          'ANOTHER ONE!',
          style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          ),
          ),
          ],
          ),
          ),
          ),
          ],
          ),
          ],
          ),
          ),
          ),
        ],
        ),
    ),
    ));
  }
}