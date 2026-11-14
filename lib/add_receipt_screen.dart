import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/receipt.dart';
import 'theme.dart';

/// Add-receipt form.
///
/// Now a [StatefulWidget]: it owns the form state — text controllers, the
/// picked date, the selected category, and the validation. Saving builds a
/// [Receipt] and hands it to [onSave] (owned by [MainScreen]), which adds
/// it to the shared list and jumps to the Receipts tab.
class AddReceiptScreen extends StatefulWidget {
  final void Function(Receipt receipt) onSave;

  const AddReceiptScreen({super.key, required this.onSave});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _storeController = TextEditingController();
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime? _purchaseDate;
  String _category = 'Other';

  /// Photo of the paper receipt, picked from camera or gallery.
  /// Kept as bytes so it works on mobile and on web.
  Uint8List? _photoBytes;

  static const Map<String, IconData> _categoryIcons = {
    'Mobile Phone': Icons.phone_android,
    'Headphones': Icons.headphones,
    'Laptop': Icons.laptop,
    'Wrist Watch': Icons.watch,
    'Other': Icons.receipt_long,
  };

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  /// Picks a receipt photo from the camera or the gallery.
  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1200,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => _photoBytes = bytes);
  }

  void _saveReceipt() {
    if (!_formKey.currentState!.validate()) return;
    if (_purchaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick a purchase date.')),
      );
      return;
    }

    final receipt = Receipt(
      title: _productController.text.trim(),
      store: _storeController.text.trim(),
      date: _formatDate(_purchaseDate!),
      price: 'Rs. ${_priceController.text.trim()}',
      icon: _categoryIcons[_category] ?? Icons.receipt_long,
      category: _category,
      photo: _photoBytes,
    );

    widget.onSave(receipt);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${receipt.title} saved.')),
    );

    // Clear the form for the next receipt.
    _formKey.currentState!.reset();
    _productController.clear();
    _storeController.clear();
    _priceController.clear();
    _dateController.clear();
    setState(() {
      _purchaseDate = null;
      _category = 'Other';
      _photoBytes = null;
    });
  }

  @override
  void dispose() {
    _productController.dispose();
    _storeController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Receipt'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: AppColors.navy),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Enter Receipt Details',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the product name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _storeController,
                decoration: const InputDecoration(
                  labelText: 'Store Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the store name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categoryIcons.keys
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: 15),
              // Date field — opens a date picker instead of free typing.
              TextFormField(
                readOnly: true,
                controller: _dateController,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Purchase Date',
                  hintText: 'Tap to pick a date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (Rs.)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_exchange),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the price.';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Price must be a number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              // Receipt photo — snap the paper receipt with the camera
              // or pick it from the gallery. Optional.
              const Text(
                'Receipt Photo (optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_photoBytes != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _photoBytes!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() => _photoBytes = null);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              if (_photoBytes != null) const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      onPressed: () => _pickPhoto(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      onPressed: () => _pickPhoto(ImageSource.gallery),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mintDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Receipt'),
                  onPressed: _saveReceipt,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
