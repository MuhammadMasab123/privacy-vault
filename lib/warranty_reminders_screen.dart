import 'package:flutter/material.dart';

import 'models/warranty.dart';
import 'theme.dart';

/// Warranty Reminders screen.
///
/// Lists every warranty sorted by days left, with a coloured badge:
/// red = expired or under 7 days, amber = under 30 days, green = safe.
/// The bell toggles a reminder on/off for that warranty (kept in memory).
class WarrantyRemindersScreen extends StatefulWidget {
  final List<Warranty> warranties;

  const WarrantyRemindersScreen({super.key, required this.warranties});

  @override
  State<WarrantyRemindersScreen> createState() =>
      _WarrantyRemindersScreenState();
}

class _WarrantyRemindersScreenState extends State<WarrantyRemindersScreen> {
  final Set<String> _remindersOn = {};

  List<Warranty> get _sorted {
    final list = List<Warranty>.from(widget.warranties);
    list.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
    return list;
  }

  Color _badgeColor(int daysLeft) {
    if (daysLeft < 0 || daysLeft <= 7) return AppColors.danger;
    if (daysLeft <= 30) return AppColors.warning;
    return AppColors.mintDark;
  }

  String _badgeText(int daysLeft) {
    if (daysLeft < 0) return 'Expired';
    if (daysLeft == 0) return 'Expires today';
    if (daysLeft == 1) return '1 day left';
    return '$daysLeft days left';
  }

  @override
  Widget build(BuildContext context) {
    final warranties = _sorted;
    final attentionCount =
        warranties.where((w) => w.daysLeft <= 30).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Warranty Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.mintSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.shield,
                  color: AppColors.mintDark,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    attentionCount == 0
                        ? 'All warranties are safe for now.'
                        : '$attentionCount ${attentionCount == 1 ? 'warranty needs' : 'warranties need'} attention.',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...warranties.map((warranty) {
            final daysLeft = warranty.daysLeft;
            final badgeColor = _badgeColor(daysLeft);
            final reminderOn = _remindersOn.contains(warranty.product);

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coloured strip on the left shows urgency at a glance.
                    Container(
                      width: 6,
                      height: 64,
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  warranty.product,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _badgeText(daysLeft),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Store: ${warranty.company}'),
                          const SizedBox(height: 4),
                          Text(
                            'Expires: ${warranty.expiry}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        reminderOn
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                        color: reminderOn
                            ? AppColors.mintDark
                            : Colors.grey,
                      ),
                      tooltip: reminderOn
                          ? 'Reminder on'
                          : 'Set reminder',
                      onPressed: () {
                        setState(() {
                          if (reminderOn) {
                            _remindersOn.remove(warranty.product);
                          } else {
                            _remindersOn.add(warranty.product);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              reminderOn
                                  ? 'Reminder off for ${warranty.product}.'
                                  : 'Reminder on for ${warranty.product}.',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
