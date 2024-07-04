import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String payload;

  NotificationPage({required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
      ),
      body: Center(
        child: Text('Notification Payload: $payload'),
      ),
    );
  }
}
