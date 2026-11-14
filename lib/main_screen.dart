import 'package:flutter/material.dart';

import 'add_receipt_screen.dart';
import 'home_screen.dart';
import 'insights_screen.dart';
import 'models/receipt.dart';
import 'models/warranty.dart';
import 'receipt_list_screen.dart';
import 'theme.dart';
import 'vault_records_screen.dart';
import 'warranty_reminders_screen.dart';

/// The app's main shell.
///
/// A [StatefulWidget] because it owns the two pieces of state the whole
/// app shares:
/// 1. which bottom-navigation tab is showing, and
/// 2. the list of receipts (new ones added from [AddReceiptScreen] appear
///    here, and deletions from [ReceiptListScreen] remove them).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Receipt> _receipts = const [
    Receipt(
      title: 'Mobile Phone',
      store: 'Samsung Store',
      date: '10 October 2026',
      price: 'Rs. 45,000',
      icon: Icons.phone_android,
      category: 'Mobile Phone',
    ),
    Receipt(
      title: 'Headphones',
      store: 'Tech World',
      date: '5 October 2026',
      price: 'Rs. 5,000',
      icon: Icons.headphones,
      category: 'Headphones',
    ),
    Receipt(
      title: 'Laptop',
      store: 'Computer House',
      date: '1 October 2026',
      price: 'Rs. 120,000',
      icon: Icons.laptop,
      category: 'Laptop',
    ),
    Receipt(
      title: 'Wrist Watch',
      store: 'Time Zone',
      date: '25 September 2026',
      price: 'Rs. 8,000',
      icon: Icons.watch,
      category: 'Wrist Watch',
    ),
  ];

  void _goToTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _addReceipt(Receipt receipt) {
    setState(() => _receipts.add(receipt));
    // Jump to the Receipts tab so the user sees the new receipt.
    _goToTab(1);
  }

  void _deleteReceipt(Receipt receipt) {
    setState(() => _receipts.remove(receipt));
  }

  void _restoreReceipt(Receipt receipt, int index) {
    setState(() => _receipts.insert(index, receipt));
  }

  /// Insights and Reminders open as pushed screens from the Home tab,
  /// so the bottom navigation keeps its original four tabs.
  void _openInsights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsightsScreen(receipts: _receipts),
      ),
    );
  }

  void _openReminders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const WarrantyRemindersScreen(warranties: sampleWarranties),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        receipts: _receipts,
        warranties: sampleWarranties,
        onOpenReceipts: () => _goToTab(1),
        onOpenAddReceipt: () => _goToTab(2),
        onOpenVault: () => _goToTab(3),
        onOpenInsights: _openInsights,
        onOpenReminders: _openReminders,
      ),
      ReceiptListScreen(
        receipts: _receipts,
        onDelete: _deleteReceipt,
        onRestore: _restoreReceipt,
      ),
      AddReceiptScreen(onSave: _addReceipt),
      const VaultRecordsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.navy,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Receipts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Vault'),
        ],
      ),
    );
  }
}
