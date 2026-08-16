enum StockStatus { inStock, lowStock, outOfStock }

class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String category;
  final int stockQuantity;
  final int minStockAlert;
  final double unitPrice;
  final String unit;
  final String supplier;
  final String barcode;
  final DateTime lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.stockQuantity,
    required this.minStockAlert,
    required this.unitPrice,
    required this.unit,
    required this.supplier,
    required this.barcode,
    required this.lastUpdated,
  });

  StockStatus get status {
    if (stockQuantity == 0) return StockStatus.outOfStock;
    if (stockQuantity <= minStockAlert) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get totalValue => stockQuantity * unitPrice;

  InventoryItem copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    int? stockQuantity,
    int? minStockAlert,
    double? unitPrice,
    String? unit,
    String? supplier,
    String? barcode,
    DateTime? lastUpdated,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minStockAlert: minStockAlert ?? this.minStockAlert,
      unitPrice: unitPrice ?? this.unitPrice,
      unit: unit ?? this.unit,
      supplier: supplier ?? this.supplier,
      barcode: barcode ?? this.barcode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category': category,
      'stockQuantity': stockQuantity,
      'minStockAlert': minStockAlert,
      'unitPrice': unitPrice,
      'unit': unit,
      'supplier': supplier,
      'barcode': barcode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      category: json['category'],
      stockQuantity: json['stockQuantity'],
      minStockAlert: json['minStockAlert'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      unit: json['unit'],
      supplier: json['supplier'],
      barcode: json['barcode'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
