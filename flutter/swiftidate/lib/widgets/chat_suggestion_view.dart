// lib/widgets/chat_suggestion_view.dart

import 'package:flutter/material.dart';

class ChatSuggestionView extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelect;

  const ChatSuggestionView({
    Key? key,
    required this.suggestions,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: suggestions.map((suggestion) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => onSelect(suggestion),
                child: Text(
                  suggestion,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.blue),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
