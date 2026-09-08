import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {'name': 'John Doe', 'action': 'liked your post', 'time': '2m ago'},
      {'name': 'Jane Smith', 'action': 'commented on your photo', 'time': '1h ago'},
      {'name': 'Mark Zuckerberg', 'action': 'sent you a friend request', 'time': '3h ago'},
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final item = notifications[index];
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.notifications),
          ),
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '${item['name']!} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: item['action']),
              ],
            ),
          ),
          subtitle: Text(item['time']!),
          trailing: const Icon(Icons.more_horiz),
        );
      },
    );
  }
}
