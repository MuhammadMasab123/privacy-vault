import 'package:flutter/material.dart';

import 'models/receipt.dart';
import 'receipt_detail_screen.dart';
import 'theme.dart';

/// Receipt list screen.
///
/// Now a [StatefulWidget]: it keeps the search text and the selected
/// category chip as state and filters the list live. Receipts come from
/// [MainScreen] (shared state), so a receipt added on the Add tab shows
/// up here automatically.
///
/// Tap a card to open its detail page ([Navigator.push]); swipe a card
/// sideways to delete it (with an Undo snackbar).
class ReceiptListScreen extends StatefulWidget {
  final List<Receipt> receipts;
  final void Function(Receipt receipt) onDelete;
  final void Function(Receipt receipt, int index) onRestore;

  const ReceiptListScreen({
    super.key,
    required this.receipts,
    required this.onDelete,
    required this.onRestore,
  });

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = widget.receipts.map((r) => r.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<Receipt> get _filteredReceipts {
    final query = _searchQuery.toLowerCase();
    return widget.receipts.where((receipt) {
      final matchesSearch = query.isEmpty ||
          receipt.title.toLowerCase().contains(query) ||
          receipt.store.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' ||
          receipt.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _openDetail(Receipt receipt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptDetailScreen(
          receipt: receipt,
          onDelete: () => widget.onDelete(receipt),
        ),
      ),
    );
  }

  void _deleteWithUndo(Receipt receipt) {
    final index = widget.receipts.indexOf(receipt);
    widget.onDelete(receipt);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${receipt.title} deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => widget.onRestore(receipt, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receipts = _filteredReceipts;

    return Scaffold(
      appBar: AppBar(title: const Text('My Receipts')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'My Purchase Records',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'All your receipts in one secure place.',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 16),
                // Search box — typing here rebuilds the filtered list.
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search receipts',
                    hintText: 'e.g. Laptop or Samsung Store',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),
                // Category filter chips.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final selected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: selected,
                          selectedColor: AppColors.mint,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textDark,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (_) {
                            setState(
                              () => _selectedCategory = category,
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: receipts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No receipts found.',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: receipts.length,
                    itemBuilder: (context, index) {
                      final receipt = receipts[index];
                      return Dismissible(
                        key: ValueKey(receipt.title + receipt.date),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) => _deleteWithUndo(receipt),
                        child: ReceiptCard(
                          receipt: receipt,
                          onTap: () => _openDetail(receipt),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final VoidCallback onTap;

  const ReceiptCard({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.mintSoft,
                child: Icon(
                  receipt.icon,
                  size: 26,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(receipt.store),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mintSoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        receipt.date,
                        style: const TextStyle(
                          color: AppColors.mintDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                receipt.price,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
