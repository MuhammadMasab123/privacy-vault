import 'package:flutter/material.dart';

import 'models/receipt.dart';
import 'theme.dart';

/// Detail view for one receipt, opened with [Navigator.push] from the
/// receipt list. The Delete button removes the receipt from the shared
/// list (via [onDelete]) and pops back to the list.
class ReceiptDetailScreen extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback onDelete;

  const ReceiptDetailScreen({
    super.key,
    required this.receipt,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receipt.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo of the paper receipt, when one was attached.
            if (receipt.photo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  receipt.photo!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (receipt.photo != null) const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.mintSoft,
                child: Icon(
                  receipt.icon,
                  size: 48,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _DetailRow(label: 'Product', value: receipt.title),
                    const Divider(),
                    _DetailRow(label: 'Store', value: receipt.store),
                    const Divider(),
                    _DetailRow(label: 'Purchase date', value: receipt.date),
                    const Divider(),
                    _DetailRow(label: 'Price', value: receipt.price),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              icon: const Icon(Icons.delete),
              label: const Text('Delete Receipt'),
              onPressed: () {
                onDelete();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${receipt.title} deleted.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
