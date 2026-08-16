import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/inventory_item.dart';
import '../../../core/providers/inventory_provider.dart';

const _uuid = Uuid();

class AddItemDialog extends ConsumerStatefulWidget {
  final InventoryItem? itemToEdit;

  const AddItemDialog({super.key, this.itemToEdit});

  @override
  ConsumerState<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends ConsumerState<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _skuController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _minAlertController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  late TextEditingController _supplierController;
  late TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;
    _nameController = TextEditingController(text: item?.name ?? '');
    _skuController = TextEditingController(text: item?.sku ?? 'SKU-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    _categoryController = TextEditingController(text: item?.category ?? 'Electronics');
    _stockController = TextEditingController(text: item?.stockQuantity.toString() ?? '10');
    _minAlertController = TextEditingController(text: item?.minStockAlert.toString() ?? '5');
    _priceController = TextEditingController(text: item?.unitPrice.toString() ?? '99.99');
    _unitController = TextEditingController(text: item?.unit ?? 'pcs');
    _supplierController = TextEditingController(text: item?.supplier ?? 'Global Tech Distributors');
    _barcodeController = TextEditingController(text: item?.barcode ?? '${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _minAlertController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    _supplierController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = InventoryItem(
        id: widget.itemToEdit?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        category: _categoryController.text.trim(),
        stockQuantity: int.parse(_stockController.text.trim()),
        minStockAlert: int.parse(_minAlertController.text.trim()),
        unitPrice: double.parse(_priceController.text.trim()),
        unit: _unitController.text.trim(),
        supplier: _supplierController.text.trim(),
        barcode: _barcodeController.text.trim(),
        lastUpdated: DateTime.now(),
      );

      if (widget.itemToEdit != null) {
        ref.read(inventoryProvider.notifier).updateItem(newItem);
      } else {
        ref.read(inventoryProvider.notifier).addItem(newItem);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.itemToEdit != null ? 'Item updated successfully!' : 'New stock item created!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.itemToEdit != null;

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Inventory Item' : 'Create New Stock Item',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name', prefixIcon: Icon(Icons.inventory_2_outlined)),
                  validator: (v) => v == null || v.isEmpty ? 'Required field' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(labelText: 'SKU Code'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Initial Stock Qty'),
                        validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _minAlertController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Min Stock Threshold'),
                        validator: (v) => int.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Unit Price (\$)'),
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(labelText: 'Unit (pcs/boxes/kg)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _supplierController,
                  decoration: const InputDecoration(labelText: 'Supplier Name', prefixIcon: Icon(Icons.business_outlined)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(labelText: 'Barcode / EAN-13', prefixIcon: Icon(Icons.qr_code_outlined)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saveItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isEdit ? 'Update Item' : 'Save New Item',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
