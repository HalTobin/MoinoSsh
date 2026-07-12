import 'package:flutter/material.dart';

class OfflineView extends StatelessWidget {

  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Please connect to a server',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}