import 'package:flutter/material.dart';

import 'date_utils.dart';
import 'models/receipt.dart';
import 'models/warranty.dart';
import 'theme.dart';

/// Home / dashboard screen.
///
/// Same content as before (counts, recent receipts, quick actions) —
/// only the look changed: a dark navy header with a greeting, summary
/// cards, an "expiring soon" strip, and recent receipts. It only
/// displays data passed in by [MainScreen], so it stays a
/// [StatelessWidget].
class HomeScreen extends StatelessWidget {
  final List<Receipt> receipts;
  final List<Warranty> warranties;
  final VoidCallback onOpenReceipts;
  final VoidCallback onOpenAddReceipt;
  final VoidCallback onOpenVault;
  final VoidCallback onOpenInsights;
  final VoidCallback onOpenReminders;

  const HomeScreen({
    super.key,
    required this.receipts,
    required this.warranties,
    required this.onOpenReceipts,
    required this.onOpenAddReceipt,
    required this.onOpenVault,
    required this.onOpenInsights,
    required this.onOpenReminders,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  double get _totalSpent {
    return receipts.fold(0, (sum, receipt) => sum + receipt.priceValue);
  }

  /// Warranties expiring within 30 days (or already expired).
  int get _attentionCount {
    return warranties.where((w) => w.daysLeft <= 30).length;
  }

  @override
  Widget build(BuildContext context) {
    final attentionCount = _attentionCount;
    final recentReceipts = receipts.take(3).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark navy header with greeting.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              decoration: const BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield,
                    color: AppColors.mint,
                    size: 44,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Here's your privacy & documents overview",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Three summary cards: tap Receipts / Warranties / Total.
                  Row(
                    children: [
                      _SummaryCard(
                        icon: Icons.receipt_long,
                        label: 'Receipts',
                        value: '${receipts.length}',
                        onTap: onOpenReceipts,
                      ),
                      const SizedBox(width: 10),
                      _SummaryCard(
                        icon: Icons.verified_user,
                        label: 'Warranties',
                        value: '${warranties.length}',
                        onTap: onOpenVault,
                      ),
                      const SizedBox(width: 10),
                      _SummaryCard(
                        icon: Icons.account_balance_wallet,
                        label: 'Total Spent',
                        value: formatRs(_totalSpent),
                        onTap: onOpenInsights,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Expiring-soon strip — red when something needs
                  // attention, green when everything is safe.
                  InkWell(
                    onTap: onOpenReminders,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: attentionCount == 0
                            ? AppColors.mintDark
                            : AppColors.danger,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            attentionCount == 0
                                ? Icons.check_circle
                                : Icons.warning_amber_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attentionCount == 0
                                      ? 'All warranties safe'
                                      : 'Expiring soon',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  attentionCount == 0
                                      ? 'No warranty expires in the next 30 days.'
                                      : '$attentionCount ${attentionCount == 1 ? 'warranty expires' : 'warranties expire'} soon • Tap to review',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent receipts.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Receipts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: onOpenReceipts,
                        child: const Text(
                          'See all >',
                          style: TextStyle(color: AppColors.mintDark),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...recentReceipts.map(
                    (receipt) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: onOpenReceipts,
                        leading: CircleAvatar(
                          backgroundColor: AppColors.mintSoft,
                          child: Icon(
                            receipt.icon,
                            color: AppColors.navy,
                          ),
                        ),
                        title: Text(
                          receipt.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${receipt.store} • ${receipt.date}',
                        ),
                        trailing: Text(
                          receipt.price,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Your Personal Vault — same text as before.
                  Card(
                    color: AppColors.navy,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock,
                            size: 32,
                            color: AppColors.mint,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Your Personal Vault',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Keep your important purchase records organized and private.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Image.asset(
                              'assets/images/receipt.png',
                              height: 140,
                              fit: BoxFit.contain,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // View receipts — navigates to the Receipts tab.
                  _QuickAction(
                    icon: Icons.receipt_long,
                    title: 'View Receipts',
                    subtitle: 'View your purchase records',
                    onTap: onOpenReceipts,
                  ),
                  const SizedBox(height: 10),

                  // Create a receipt — navigates to the Add tab.
                  _QuickAction(
                    icon: Icons.add_circle_outline,
                    title: 'Create New Receipt',
                    subtitle: 'Enter details of a new purchase',
                    onTap: onOpenAddReceipt,
                  ),
                  const SizedBox(height: 10),

                  // Warranty reminders — opens the new Reminders screen.
                  _QuickAction(
                    icon: Icons.notifications_active,
                    title: 'Warranty Reminders',
                    subtitle: 'View warranty expiry dates',
                    onTap: onOpenReminders,
                  ),
                  const SizedBox(height: 10),

                  // Spending insights — opens the new Insights screen.
                  _QuickAction(
                    icon: Icons.bar_chart,
                    title: 'Spending Insights',
                    subtitle: 'See where your money goes',
                    onTap: onOpenInsights,
                  ),
                  const SizedBox(height: 10),

                  // Privacy records — navigates to the Vault tab.
                  _QuickAction(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Records',
                    subtitle: '5 saved consent records',
                    onTap: onOpenVault,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the three summary cards on the dashboard.
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.mintSoft,
                  child: Icon(icon, color: AppColors.navy),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One row in the Quick Actions list.
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.navy, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.navy,
          size: 18,
        ),
      ),
    );
  }
}
