import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_item.dart';

const _uuid = Uuid();

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  InventoryNotifier() : super(_initialSampleItems);

  static final List<InventoryItem> _initialSampleItems = [
    InventoryItem(
      id: _uuid.v4(),
      name: 'MacBook Pro 16" M3 Max',
      sku: 'ELEC-MBP-16',
      category: 'Electronics',
      stockQuantity: 18,
      minStockAlert: 5,
      unitPrice: 2499.0,
      unit: 'pcs',
      supplier: 'Apple Inc.',
      barcode: '888462001928',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    InventoryItem(
      id: _uuid.v4(),
      name: 'Wireless Ergonomic Keyboard',
      sku: 'ELEC-KB-ERG',
      category: 'Electronics',
      stockQuantity: 4,
      minStockAlert: 10,
      unitPrice: 129.99,
      unit: 'pcs',
      supplier: 'Logitech',
      barcode: '097855154321',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    InventoryItem(
      id: _uuid.v4(),
      name: 'UltraWide 34" Curved Monitor',
      sku: 'ELEC-MON-34',
      category: 'Electronics',
      stockQuantity: 0,
      minStockAlert: 3,
      unitPrice: 799.50,
      unit: 'pcs',
      supplier: 'Dell Global',
      barcode: '884116345912',
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    ),
    InventoryItem(
      id: _uuid.v4(),
      name: 'Ergonomic Mesh Executive Chair',
      sku: 'FURN-CHR-EXEC',
      category: 'Furniture',
      stockQuantity: 25,
      minStockAlert: 8,
      unitPrice: 349.0,
      unit: 'pcs',
      supplier: 'Herman Miller Direct',
      barcode: '735219001248',
      lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    ),
    InventoryItem(
      id: _uuid.v4(),
      name: 'USB-C Fast Charging Hub (100W)',
      sku: 'ACC-HUB-100W',
      category: 'Accessories',
      stockQuantity: 65,
      minStockAlert: 15,
      unitPrice: 49.99,
      unit: 'pcs',
      supplier: 'Anker Innovations',
      barcode: '848061042318',
      lastUpdated: DateTime.now().subtract(const Duration(days: 4)),
    ),
    InventoryItem(
      id: _uuid.v4(),
      name: 'Thermal Receipt Paper Rolls (50 Pack)',
      sku: 'SUPP-PAP-80',
      category: 'Supplies',
      stockQuantity: 8,
      minStockAlert: 12,
      unitPrice: 38.50,
      unit: 'boxes',
      supplier: 'Office Depot',
      barcode: '014272183921',
      lastUpdated: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];

  void addItem(InventoryItem item) {
    state = [item, ...state];
  }

  void updateItem(InventoryItem updatedItem) {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item
    ];
  }

  void deleteItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void adjustStock(String id, int delta) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            stockQuantity: (item.stockQuantity + delta).clamp(0, 999999),
            lastUpdated: DateTime.now(),
          )
        else
          item
    ];
  }
}

// Global Providers
final inventoryProvider = StateNotifierProvider<InventoryNotifier, List<InventoryItem>>((ref) {
  return InventoryNotifier();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredInventoryProvider = Provider<List<InventoryItem>>((ref) {
  final items = ref.watch(inventoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(selectedCategoryProvider);

  return items.where((item) {
    final matchesQuery = query.isEmpty ||
        item.name.toLowerCase().contains(query) ||
        item.sku.toLowerCase().contains(query) ||
        item.barcode.contains(query);

    final matchesCategory = category == 'All' || item.category == category;

    return matchesQuery && matchesCategory;
  }).toList();
});

final categoriesProvider = Provider<List<String>>((ref) {
  final items = ref.watch(inventoryProvider);
  final categories = items.map((item) => item.category).toSet().toList();
  return ['All', ...categories];
});

final lowStockItemsProvider = Provider<List<InventoryItem>>((ref) {
  final items = ref.watch(inventoryProvider);
  return items.where((item) => item.status == StockStatus.lowStock || item.status == StockStatus.outOfStock).toList();
});

final totalInventoryValueProvider = Provider<double>((ref) {
  final items = ref.watch(inventoryProvider);
  return items.fold(0.0, (sum, item) => sum + item.totalValue);
});
