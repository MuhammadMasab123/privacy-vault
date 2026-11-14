import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../date_utils.dart';

/// A single purchase receipt stored in the app's in-memory state.
/// (No database yet — receipts live only while the app is running.)
class Receipt {
  final String title;
  final String store;
  final String date;
  final String price;
  final IconData icon;

  /// Category picked on the Add screen ('Mobile Phone', 'Laptop', ...).
  /// Used for the filter chips on the Receipts tab and the Insights screen.
  final String category;

  /// Photo of the paper receipt, attached from camera or gallery.
  /// Stored as bytes so it works on mobile and on web.
  final Uint8List? photo;

  const Receipt({
    required this.title,
    required this.store,
    required this.date,
    required this.price,
    required this.icon,
    this.category = 'Other',
    this.photo,
  });

  /// 'Rs. 45,000' -> 45000 (used by the Insights screen).
  double get priceValue {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  /// '10 October 2026' -> a real DateTime (used by the Insights screen).
  DateTime? get purchaseDate => parseDisplayDate(date);
}
