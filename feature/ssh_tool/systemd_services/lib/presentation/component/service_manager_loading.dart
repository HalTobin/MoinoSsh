import 'package:flutter/material.dart';

class ServiceManagerLoading extends StatelessWidget {
  const ServiceManagerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}