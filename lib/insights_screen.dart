import 'package:flutter/material.dart';

import 'date_utils.dart';
import 'models/receipt.dart';
import 'theme.dart';

/// Spending Insights screen.
///
/// Total spent, a simple bar chart of spending by month (plain
/// Containers — no chart package, to keep the code simple), and a
/// breakdown by category with progress bars. Everything is computed
/// from the shared receipts list, so it updates when receipts change.
class InsightsScreen extends StatelessWidget {
  final List<Receipt> receipts;

  const InsightsScreen({super.key, required this.receipts});

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  double get _totalSpent {
    return receipts.fold(0, (sum, receipt) => sum + receipt.priceValue);
  }

  /// Spending per month for the last 6 months (including this month).
  List<_MonthSpending> get _monthlySpending {
    final now = DateTime.now();
    final months = List.generate(
      6,
      (i) => DateTime(now.year, now.month - 5 + i),
    );
    return months.map((month) {
      var total = 0.0;
      for (final receipt in receipts) {
        final date = receipt.purchaseDate;
        if (date != null &&
            date.year == month.year &&
            date.month == month.month) {
          total += receipt.priceValue;
        }
      }
      return _MonthSpending(
        label: _monthNames[month.month - 1],
        total: total,
      );
    }).toList();
  }

  /// Spending per category, biggest first.
  List<_CategorySpending> get _categorySpending {
    final totals = <String, double>{};
    for (final receipt in receipts) {
      totals[receipt.category] =
          (totals[receipt.category] ?? 0) + receipt.priceValue;
    }
    final list = totals.entries
        .map((entry) => _CategorySpending(
              category: entry.key,
              total: entry.value,
            ))
        .toList();
    list.sort((a, b) => b.total.compareTo(a.total));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = _totalSpent;
    final monthly = _monthlySpending;
    final categories = _categorySpending;
    final maxMonth = monthly.fold<double>(
      1,
      (max, month) => month.total > max ? month.total : max,
    );
    final maxCategory = categories.isEmpty ? 1.0 : categories.first.total;

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total spent card.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Spent',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatRs(totalSpent),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.lock,
                    color: AppColors.mint,
                    size: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Spending by Month',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Bar chart made of plain Containers.
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: monthly.map((month) {
                    final height = 12 + (month.total / maxMonth) * 110;
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            month.total == 0
                                ? ''
                                : formatRs(month.total),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mintDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: height,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: month.total == 0
                                  ? Colors.grey.shade300
                                  : AppColors.mint,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            month.label,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Category Breakdown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: categories.map((category) {
                    final share = totalSpent == 0
                        ? 0.0
                        : category.total / totalSpent;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.category,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                formatRs(category.total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: category.total / maxCategory,
                              minHeight: 8,
                              backgroundColor: AppColors.mintSoft,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                AppColors.mint,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(share * 100).round()}% of total spending',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _MonthSpending {
  final String label;
  final double total;

  const _MonthSpending({required this.label, required this.total});
}

class _CategorySpending {
  final String category;
  final double total;

  const _CategorySpending({required this.category, required this.total});
}
