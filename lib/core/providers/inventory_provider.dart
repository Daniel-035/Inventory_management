import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory_item.dart';

const _uuid = Uuid();

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  InventoryNotifier() : super([]); // Start empty from 0

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

  void clearAll() {
    state = [];
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
