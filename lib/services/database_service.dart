import 'package:accountancy_ai_app/models/debt.dart';
import 'package:accountancy_ai_app/models/inventory_item.dart';
import 'package:accountancy_ai_app/models/transaction.dart' as txn;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'inventory.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        itemName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unitPrice REAL NOT NULL,
        totalAmount REAL NOT NULL,
        date TEXT NOT NULL,
        notes TEXT,
        customerName TEXT,
        paymentMethod TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE inventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        currentStock INTEGER NOT NULL,
        minStock INTEGER NOT NULL,
        purchasePrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        unit TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE debts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        personName TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        dueDate TEXT,
        isPaid INTEGER NOT NULL,
        contactNumber TEXT,
        paymentMethod TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Insert default categories
    await db.insert('categories', {
      'name': 'Electronics',
      'description': 'Electronic devices and accessories',
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Clothing',
      'description': 'Apparel and fashion items',
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Food',
      'description': 'Food and beverages',
      'createdAt': DateTime.now().toIso8601String(),
    });

    await db.insert('categories', {
      'name': 'Books',
      'description': 'Books and stationery',
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Insert dummy data
    await _insertDummyData(db);
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query) async {
    final db = await database;
    return await db.rawQuery(query);
  }

  Future<void> _insertDummyData(Database db) async {
    // Dummy transactions
    final transactions = [
      {
        'type': 'sale',
        'itemName': 'iPhone 13',
        'quantity': 1,
        'unitPrice': 65000.0,
        'totalAmount': 65000.0,
        'date': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'notes': 'Sold to regular customer',
        'customerName': 'Rajesh Kumar',
        'paymentMethod': 'UPI',
      },
      {
        'type': 'sale',
        'itemName': 'Samsung Galaxy S21',
        'quantity': 2,
        'unitPrice': 45000.0,
        'totalAmount': 90000.0,
        'date': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'notes': 'Bulk sale',
        'customerName': 'Priya Sharma',
        'paymentMethod': 'Cash',
      },
      {
        'type': 'purchase',
        'itemName': 'iPhone 13',
        'quantity': 5,
        'unitPrice': 58000.0,
        'totalAmount': 290000.0,
        'date': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'notes': 'Purchased from distributor',
        'customerName': 'Tech Distributors Ltd',
        'paymentMethod': 'Bank Transfer',
      },
      {
        'type': 'purchase',
        'itemName': 'Samsung Galaxy S21',
        'quantity': 10,
        'unitPrice': 38000.0,
        'totalAmount': 380000.0,
        'date': DateTime.now().subtract(Duration(days: 4)).toIso8601String(),
        'notes': 'Stock replenishment',
        'customerName': 'Mobile World',
        'paymentMethod': 'Cheque',
      },
    ];

    for (var transaction in transactions) {
      await db.insert('transactions', transaction);
    }

    // Dummy inventory
    final inventoryItems = [
      {
        'name': 'iPhone 13',
        'currentStock': 8,
        'minStock': 3,
        'purchasePrice': 58000.0,
        'sellingPrice': 65000.0,
        'category': 'Electronics',
        'description': '128GB, Blue Color',
        'unit': 'pieces',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Samsung Galaxy S21',
        'currentStock': 12,
        'minStock': 5,
        'purchasePrice': 38000.0,
        'sellingPrice': 45000.0,
        'category': 'Electronics',
        'description': '256GB, Black Color',
        'unit': 'pieces',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'name': 'AirPods Pro',
        'currentStock': 2,
        'minStock': 5,
        'purchasePrice': 18000.0,
        'sellingPrice': 22000.0,
        'category': 'Electronics',
        'description': '2nd Generation',
        'unit': 'pieces',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Nike T-Shirt',
        'currentStock': 15,
        'minStock': 8,
        'purchasePrice': 1200.0,
        'sellingPrice': 1800.0,
        'category': 'Clothing',
        'description': 'Cotton, Size M',
        'unit': 'pieces',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Notebook',
        'currentStock': 50,
        'minStock': 20,
        'purchasePrice': 45.0,
        'sellingPrice': 80.0,
        'category': 'Books',
        'description': 'A4 Size, 200 pages',
        'unit': 'pieces',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ];

    for (var item in inventoryItems) {
      await db.insert('inventory', item);
    }

    // Dummy debts
    final debts = [
      {
        'personName': 'Amit Gupta',
        'type': 'owed_to_me',
        'amount': 25000.0,
        'description': 'Payment for iPhone 13',
        'date': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'dueDate': DateTime.now().add(Duration(days: 10)).toIso8601String(),
        'isPaid': 0,
        'contactNumber': '+91-9876543210',
        'paymentMethod': 'UPI',
      },
      {
        'personName': 'Sunita Devi',
        'type': 'owed_to_me',
        'amount': 12000.0,
        'description': 'Payment for Samsung Galaxy',
        'date': DateTime.now().subtract(Duration(days: 8)).toIso8601String(),
        'dueDate': DateTime.now().add(Duration(days: 2)).toIso8601String(),
        'isPaid': 0,
        'contactNumber': '+91-9876543211',
        'paymentMethod': 'Cash',
      },
      {
        'personName': 'Tech Suppliers',
        'type': 'i_owe',
        'amount': 45000.0,
        'description': 'Payment for inventory purchase',
        'date': DateTime.now().subtract(Duration(days: 10)).toIso8601String(),
        'dueDate': DateTime.now().add(Duration(days: 5)).toIso8601String(),
        'isPaid': 0,
        'contactNumber': '+91-9876543212',
        'paymentMethod': 'Bank Transfer',
      },
      {
        'personName': 'Rental Agency',
        'type': 'i_owe',
        'amount': 8000.0,
        'description': 'Shop rent for current month',
        'date': DateTime.now().subtract(Duration(days: 15)).toIso8601String(),
        'dueDate': DateTime.now().add(Duration(days: 15)).toIso8601String(),
        'isPaid': 0,
        'contactNumber': '+91-9876543213',
        'paymentMethod': 'Cash',
      },
    ];

    for (var debt in debts) {
      await db.insert('debts', debt);
    }
  }

  Future<void> initDatabase() async {
    await database;
  }

  // Transaction methods
  Future<int> insertTransaction(txn.Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<txn.Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (i) => txn.Transaction.fromMap(maps[i]));
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTransaction(txn.Transaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // Inventory methods
  Future<void> updateInventoryItem(InventoryItem item) async {
    final db = await database;
    await db.update(
      'inventory',
      item.toMap(), // Converts the InventoryItem to a Map
      where: 'id = ?',
      whereArgs: [item.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertInventoryItem(InventoryItem item) async {
    final db = await database;
    return await db.insert('inventory', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<InventoryItem>> getInventoryItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('inventory');
    return List.generate(maps.length, (i) => InventoryItem.fromMap(maps[i]));
  }

  // Debt methods
  Future<int> insertDebt(Debt debt) async {
    final db = await database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<Debt>> getDebts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('debts');
    return List.generate(maps.length, (i) => Debt.fromMap(maps[i]));
  }

  // Analytics methods
  Future<double> getTotalRevenue({String? period}) async {
    final db = await database;
    String whereClause = "type = 'sale'";
    if (period != null) {
      whereClause += " AND date >= '${_getPeriodDate(period)}'";
    }

    final result = await db.rawQuery(
        'SELECT SUM(totalAmount) as total FROM transactions WHERE $whereClause');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalExpenses({String? period}) async {
    final db = await database;
    String whereClause = "type = 'purchase'";
    if (period != null) {
      whereClause += " AND date >= '${_getPeriodDate(period)}'";
    }

    final result = await db.rawQuery(
        'SELECT SUM(totalAmount) as total FROM transactions WHERE $whereClause');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getOutstandingDebts() async {
    final db = await database;
    final result = await db
        .rawQuery('SELECT SUM(amount) as total FROM debts WHERE isPaid = 0');
    return result.first['total'] as double? ?? 0.0;
  }

  String _getPeriodDate(String period) {
    DateTime now = DateTime.now();
    switch (period) {
      case 'today':
        return DateTime(now.year, now.month, now.day).toIso8601String();
      case 'week':
        return now.subtract(Duration(days: 7)).toIso8601String();
      case 'month':
        return DateTime(now.year, now.month, 1).toIso8601String();
      case 'year':
        return DateTime(now.year, 1, 1).toIso8601String();
      default:
        return now.toIso8601String();
    }
  }

  // Category methods
  Future<List<String>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return maps.map((map) => map['name'] as String).toList();
  }

  Future<int> insertCategory(String name, String? description) async {
    final db = await database;
    return await db.insert(
      'categories',
      {
        'name': name,
        'description': description,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // ← key line
    );
  }

  // Updated inventory methods
  Future<List<InventoryItem>> getInventoryItemsByCategory(
      String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => InventoryItem.fromMap(maps[i]));
  }

  Future<List<InventoryItem>> searchInventoryItems(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'inventory',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => InventoryItem.fromMap(maps[i]));
  }

  Future<double> getTotalInventoryValue() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(currentStock * sellingPrice) as total FROM inventory');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> getLowStockCount() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM inventory WHERE currentStock <= minStock');
    return result.first['count'] as int? ?? 0;
  }

  Future<int> getOutOfStockCount() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM inventory WHERE currentStock = 0');
    return result.first['count'] as int? ?? 0;
  }

  // Updated txn.Transaction methods
  Future<List<txn.Transaction>> getTransactionsByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => txn.Transaction.fromMap(maps[i]));
  }

  Future<List<txn.Transaction>> searchTransactions(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'itemName LIKE ? OR notes LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => txn.Transaction.fromMap(maps[i]));
  }

  // Updated debt methods
  Future<List<Debt>> getDebtsByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'debts',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Debt.fromMap(maps[i]));
  }

  Future<double> getTotalDebtByType(String type) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM debts WHERE type = ? AND isPaid = 0',
        [type]);
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> getOverdueDebtsCount() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM debts WHERE dueDate < ? AND isPaid = 0',
        [DateTime.now().toIso8601String()]);
    return result.first['count'] as int? ?? 0;
  }

  Future<List<Debt>> getOverdueDebts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'debts',
      where: 'dueDate < ? AND isPaid = 0',
      whereArgs: [DateTime.now().toIso8601String()],
      orderBy: 'dueDate ASC',
    );
    return List.generate(maps.length, (i) => Debt.fromMap(maps[i]));
  }

  // Update debt status
  Future<void> markDebtAsPaid(int debtId) async {
    final db = await database;
    await db.update(
      'debts',
      {'isPaid': 1},
      where: 'id = ?',
      whereArgs: [debtId],
    );
  }

  // Update inventory stock
  Future<void> updateInventoryStock(int itemId, int newStock) async {
    final db = await database;
    await db.update(
      'inventory',
      {
        'currentStock': newStock,
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }
}
