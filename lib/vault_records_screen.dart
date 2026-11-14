import 'package:flutter/material.dart';

import 'models/warranty.dart';
import 'theme.dart';

/// Vault records screen.
///
/// Now a [StatefulWidget]: it keeps the "show active only" filter as
/// state, and each warranty card is an [ExpansionTile] the user can tap
/// to expand for details. Same content as before — the warranty list
/// now lives in [sampleWarranties] so the Reminders screen can use it.
class VaultRecordsScreen extends StatefulWidget {
  const VaultRecordsScreen({super.key});

  @override
  State<VaultRecordsScreen> createState() => _VaultRecordsScreenState();
}

class _VaultRecordsScreenState extends State<VaultRecordsScreen> {
  bool _showActiveOnly = false;

  List<Warranty> get _visibleWarranties {
    if (!_showActiveOnly) return sampleWarranties;
    return sampleWarranties.where((warranty) => warranty.isActive).toList();
  }

  @override
  Widget build(BuildContext context) {
    final warranties = _visibleWarranties;

    return Scaffold(
      appBar: AppBar(title: const Text('Vault Records')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy & Warranty Records',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Review your saved consent records and keep track of product warranties.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/privacy.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.privacy_tip,
                        size: 52,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Privacy Records',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('5 saved consent records'),
                          SizedBox(height: 4),
                          Text('Your data-sharing choices at a glance.',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Warranty Tracker',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
            const SizedBox(height: 8),
            const Text('Sample warranty records',
                style: TextStyle(color: Colors.grey)),
            // Filter switch — flipping it rebuilds the list below.
            SwitchListTile(
              title: const Text('Show active warranties only'),
              value: _showActiveOnly,
              activeThumbColor: AppColors.mintDark,
              onChanged: (value) {
                setState(() => _showActiveOnly = value);
              },
            ),
            const SizedBox(height: 4),
            if (warranties.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No active warranties.',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              )
            else
              ...warranties.map(
                (warranty) => WarrantyCard(warranty: warranty),
              ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.mintSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.mintDark),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'These are sample records for the project demonstration. They are not connected to a database.',
                      style: TextStyle(
                          color: AppColors.textDark, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One warranty card. Tap it to expand and see the expiry details —
/// [ExpansionTile] keeps its own open/closed state.
class WarrantyCard extends StatelessWidget {
  final Warranty warranty;

  const WarrantyCard({super.key, required this.warranty});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.mintSoft,
          child: Icon(
            warranty.icon,
            size: 26,
            color: AppColors.navy,
          ),
        ),
        title: Text(
          warranty.product,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(warranty.company),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expires: ${warranty.expiry}',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  warranty.status,
                  style: const TextStyle(
                    color: AppColors.mintDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
