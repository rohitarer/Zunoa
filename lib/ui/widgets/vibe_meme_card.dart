import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/services/gemini_service.dart';

class VibeMemeCard extends StatefulWidget {
  final String mood;
  final String imageUrl;
  final String? preloadedCaption;

  const VibeMemeCard({
    super.key,
    required this.mood,
    required this.imageUrl,
    this.preloadedCaption,
  });

  @override
  State<VibeMemeCard> createState() => _VibeMemeCardState();
}

class _VibeMemeCardState extends State<VibeMemeCard> {
  String? caption;
  bool isLoading = true;
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
    if (widget.preloadedCaption != null) {
      caption = widget.preloadedCaption;
      isLoading = false;
    } else {
      _loadCaption();
    }
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('comments_${widget.mood}') ?? [];
    setState(() => comments = stored);
  }

  Future<void> _saveComment(String comment) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => comments.add(comment));
    await prefs.setStringList('comments_${widget.mood}', comments);
  }

  Future<void> _loadCaption() async {
    setState(() => isLoading = true);
    try {
      // final vibe = await geminiService.generateVibeLine(widget.mood);
      if (mounted) {
        // final sanitized = _sanitizeText(vibe);
        setState(() {
          // caption = sanitized;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          caption = "⚠️ Couldn't load caption.";
          isLoading = false;
        });
      }
    }
  }

  String _sanitizeText(String text) {
    return text.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: theme.colorScheme.surface,
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              errorBuilder:
                  (context, error, stackTrace) => const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.broken_image, size: 40)),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                      caption ?? '',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _toggleLike,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : AppTheme.primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: _comment,
                  icon: const Icon(Icons.mode_comment_outlined),
                  color: AppTheme.secondaryColor,
                ),
                IconButton(
                  onPressed: _share,
                  icon: const Icon(Icons.share),
                  color: AppTheme.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
