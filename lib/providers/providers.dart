import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/transaction.dart';
import '../models/inventory_item.dart';
import '../models/debt.dart';
import '../services/database_service.dart';

part 'providers.g.dart';

@riverpod
DatabaseService databaseService(Ref ref) {
  return DatabaseService();
}

// Transaction providers
@riverpod
Future<List<Transaction>> transactions(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTransactions();
}

@riverpod
Future<List<Transaction>> sales(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTransactionsByType('sale');
}

@riverpod
Future<List<Transaction>> purchases(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTransactionsByType('purchase');
}

// Inventory providers
@riverpod
Future<List<InventoryItem>> inventory(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getInventoryItems();
}

@riverpod
Future<List<String>> categories(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getCategories();
}

@riverpod
Future<double> inventoryValue(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTotalInventoryValue();
}

@riverpod
Future<int> lowStockCount(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getLowStockCount();
}

@riverpod
Future<int> outOfStockCount(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getOutOfStockCount();
}

// Debt providers
@riverpod
Future<List<Debt>> debts(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getDebts();
}

@riverpod
Future<List<Debt>> owedToMe(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getDebtsByType('owed_to_me');
}

@riverpod
Future<List<Debt>> iOwe(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getDebtsByType('i_owe');
}

@riverpod
Future<double> totalOwedToMe(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTotalDebtByType('owed_to_me');
}

@riverpod
Future<double> totalIOwe(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getTotalDebtByType('i_owe');
}

@riverpod
Future<int> overdueDebtsCount(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getOverdueDebtsCount();
}

@riverpod
Future<List<Debt>> overdueDebts(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getOverdueDebts();
}

// Search providers - Updated with proper methods
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }

  void clearQuery() {
    state = '';
  }
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'All';

  void updateCategory(String category) {
    state = category;
  }

  void resetCategory() {
    state = 'All';
  }
}

@riverpod
class SelectedTransactionType extends _$SelectedTransactionType {
  @override
  String build() => 'All';

  void updateTransactionType(String type) {
    state = type;
  }

  void resetTransactionType() {
    state = 'All';
  }
}

@riverpod
class SelectedDebtType extends _$SelectedDebtType {
  @override
  String build() => 'owed_to_me';

  void updateDebtType(String type) {
    state = type;
  }

  void resetDebtType() {
    state = 'owed_to_me';
  }
}

@riverpod
Future<List<Transaction>> searchTransactions(Ref ref, String query) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.searchTransactions(query);
}

@riverpod
Future<List<InventoryItem>> inventoryItemsByCategory(
    Ref ref, String category) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.getInventoryItemsByCategory(category);
}

@riverpod
Future<List<InventoryItem>> searchInventoryItems(Ref ref, String query) async {
  final db = ref.watch(databaseServiceProvider);
  return await db.searchInventoryItems(query);
}

// Updated provider file additions:

@riverpod
Future<List<String>> categoriesFromInventory(Ref ref) async {
  final db = ref.watch(databaseServiceProvider);
  final inventoryItems = await db.getInventoryItems();
  final categories = inventoryItems.map((item) => item.category).toSet().toList();
  categories.sort();
  return categories;
}

// Additional providers for form functionality
@riverpod
class TransactionFormData extends _$TransactionFormData {
  @override
  Map<String, dynamic> build() => {
    'type': 'sale',
    'paymentMethod': 'cash',
    'date': DateTime.now().toIso8601String(),
  };
  
  void updateField(String field, dynamic value) {
    state = {...state, field: value};
  }
  
  void reset() {
    state = {
      'type': 'sale',
      'paymentMethod': 'cash',
      'date': DateTime.now().toIso8601String(),
    };
  }
}

@riverpod
class DebtFormData extends _$DebtFormData {
  @override
  Map<String, dynamic> build() => {
    'type': 'owed_to_me',
    'paymentMethod': 'cash',
    'date': DateTime.now().toIso8601String(),
    'isPaid': false,
  };
  
  void updateField(String field, dynamic value) {
    state = {...state, field: value};
  }
  
  void reset() {
    state = {
      'type': 'owed_to_me',
      'paymentMethod': 'cash',
      'date': DateTime.now().toIso8601String(),
      'isPaid': false,
    };
  }
}
@riverpod
Future<double> totalRevenue(Ref ref, String period) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getTotalRevenue(period: period);
}

@riverpod
Future<double> totalExpenses(Ref ref, String period) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getTotalExpenses(period: period);
}

@riverpod
Future<double> outstandingDebts(Ref ref) async {
  final databaseService = ref.watch(databaseServiceProvider);
  return await databaseService.getOutstandingDebts();
}