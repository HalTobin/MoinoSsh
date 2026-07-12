import 'package:flutter/material.dart';

class MoinoTheme {

    static InputDecorationTheme inputDecoration() {
        const circular = 12.0;
        const offWidth = 1.5;

        return InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.withValues(alpha: 0.1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(circular),
            borderSide: const BorderSide(width: offWidth, color: Colors.grey),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(circular),
            borderSide: const BorderSide(width: offWidth, color: Colors.grey),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(circular),
            borderSide: const BorderSide(width: 2.0),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(circular),
            borderSide: const BorderSide(width: offWidth),
          ),
        );
    }

}