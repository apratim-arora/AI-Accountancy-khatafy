
// lib/models/inventory_item.dart
class InventoryItem {
  final int? id;
  final String name;
  final int currentStock;
  final int minStock;
  final double purchasePrice;
  final double sellingPrice;
  final String category;
  final String? description;
  final String? unit; // kg, pieces, liters, etc.
  final DateTime lastUpdated;

  InventoryItem({
    this.id,
    required this.name,
    required this.currentStock,
    required this.minStock,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.category,
    this.description,
    this.unit,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currentStock': currentStock,
      'minStock': minStock,
      'purchasePrice': purchasePrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'description': description,
      'unit': unit,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      name: map['name'],
      currentStock: map['currentStock'],
      minStock: map['minStock'],
      purchasePrice: map['purchasePrice'],
      sellingPrice: map['sellingPrice'],
      category: map['category'] ?? 'General',
      description: map['description'],
      unit: map['unit'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  double get inventoryValue => currentStock * sellingPrice;
  bool get isLowStock => currentStock <= minStock;
}
