import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/services/gemini_service.dart';

class VibeCard extends StatefulWidget {
  final String mood;
  final String emoji;

  const VibeCard({super.key, required this.mood, required this.emoji});

  @override
  State<VibeCard> createState() => _VibeCardState();
}

class _VibeCardState extends State<VibeCard> {
  String? _content;
  bool _loading = true;
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = [];

  @override
  void initState() {
    super.initState();
    _loadContent();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('comments_card_${widget.mood}') ?? [];
    setState(() => comments = stored);
  }

  Future<void> _saveComment(String comment) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => comments.add(comment));
    await prefs.setStringList('comments_card_${widget.mood}', comments);
  }

  Future<void> _loadContent() async {
    setState(() => _loading = true);
    try {
      // final line = await geminiService.generateVibeLine(widget.mood);
      if (mounted) {
        setState(() {
          // _content = line;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _content = "⚠️ Couldn't load vibe, but you're still awesome!";
          _loading = false;
        });
      }
    }
  }

  void _toggleLike() {
    setState(() => isLiked = !isLiked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLiked ? '❤️ Liked!' : '💔 Unliked'),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📤 Shared to your story!'),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _comment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "💬 Comments",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: "Add a comment...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final text = _commentController.text.trim();
                    if (text.isNotEmpty) {
                      await _saveComment(text);
                      _commentController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("💌 Comment added!"),
                          duration: Duration(milliseconds: 800),
                        ),
                      );
                    }
                  },
                  child: const Text("Post Comment"),
                ),
                const SizedBox(height: 10),
                ...comments.map(
                  (c) => ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(c),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 10),
            Text(
              widget.mood,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : Text(_content ?? '', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : AppTheme.accentColor,
                  ),
                  onPressed: _toggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  color: AppTheme.secondaryColor,
                  onPressed: _comment,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  color: AppTheme.primaryColor,
                  onPressed: _share,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
