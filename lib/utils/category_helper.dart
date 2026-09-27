import 'package:flutter/material.dart';

/// Icons and colors for each expense category (used in lists and charts).
class CategoryHelper {
  static IconData iconFor(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Travel':
        return Icons.flight_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Bills':
        return Icons.receipt_long_rounded;
      default:
        return Icons.more_horiz_rounded;
    }
  }

  static Color colorFor(String category) {
    switch (category) {
      case 'Food':
        return const Color(0xFFF97316);
      case 'Travel':
        return const Color(0xFF3B82F6);
      case 'Shopping':
        return const Color(0xFFA855F7);
      case 'Bills':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
