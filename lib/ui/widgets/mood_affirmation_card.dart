import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/services/gemini_service.dart';

class MoodAffirmationCard extends StatefulWidget {
  final String moodTag; // 🧘 Calm, 🧠 Think, etc.

  const MoodAffirmationCard({super.key, required this.moodTag});

  @override
  State<MoodAffirmationCard> createState() => _MoodAffirmationCardState();
}

class _MoodAffirmationCardState extends State<MoodAffirmationCard> {
  String _visibleText = "";
  String _fullText = "";
  int _index = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndTypeText();
  }

  // Fetch the affirmation text based on the mood
  Future<void> _fetchAndTypeText() async {
    // final response = await geminiService.generateVibeLine(widget.moodTag);
    // _fullText = response;
    _isLoading = false;
    _startTyping();
  }

  // Typewriter effect for typing the text one character at a time
  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_index < _fullText.length) {
        setState(() {
          _visibleText += _fullText[_index];
          _index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withOpacity(0.3),
            AppTheme.accentColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Text(
                _visibleText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
    );
  }
}
