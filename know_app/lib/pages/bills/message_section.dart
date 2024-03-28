import 'package:flutter/material.dart';

class MessageSection extends StatelessWidget {
  const MessageSection({
    Key? key,
    required this.title,
    required this.messages,
  }) : super(key: key);

  final String title;
  final List<String?> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        if (messages.isNotEmpty)
          SizedBox(
            height: 200, // Set a fixed height or use Expanded
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]!),
                );
              },
            ),
          )
        else
          Text('No $title messages to show.'),
      ],
    );
  }
}
