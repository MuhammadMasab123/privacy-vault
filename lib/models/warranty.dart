import 'package:flutter/material.dart';

import '../date_utils.dart';

/// One product warranty. The same list is shown on the Vault tab and on
/// the Warranty Reminders screen, so it lives here instead of in a screen.
class Warranty {
  final String product;
  final String company;
  final String expiry;
  final String status;
  final IconData icon;
  final bool isActive;

  const Warranty({
    required this.product,
    required this.company,
    required this.expiry,
    required this.status,
    required this.icon,
    required this.isActive,
  });

  DateTime? get expiryDate => parseDisplayDate(expiry);

  /// Days left until expiry. Negative means already expired.
  int get daysLeft {
    final date = expiryDate;
    if (date == null) return 0;
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    return date.difference(startOfToday).inDays;
  }
}

/// The sample warranties (same content as before — only moved here).
const sampleWarranties = [
  Warranty(
    product: 'Mobile Phone',
    company: 'Samsung Store',
    expiry: '10 October 2027',
    status: 'Active warranty',
    icon: Icons.phone_android,
    isActive: true,
  ),
  Warranty(
    product: 'Laptop',
    company: 'Computer House',
    expiry: '1 October 2027',
    status: 'Active warranty',
    icon: Icons.laptop,
    isActive: true,
  ),
  Warranty(
    product: 'Headphones',
    company: 'Tech World',
    expiry: '5 October 2026',
    status: 'Check expiry date',
    icon: Icons.headphones,
    isActive: false,
  ),
];
