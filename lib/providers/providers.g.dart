// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseServiceHash() => r'953b1020c1ad50a75b4605d375910af4a4c2e3cd';

/// See also [databaseService].
@ProviderFor(databaseService)
final databaseServiceProvider = AutoDisposeProvider<DatabaseService>.internal(
  databaseService,
  name: r'databaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseServiceRef = AutoDisposeProviderRef<DatabaseService>;
String _$transactionsHash() => r'6db55792a46539af5f40fbcc08d9d46b61fe851f';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<Transaction>>.internal(
  transactions,
  name: r'transactionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$transactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeFutureProviderRef<List<Transaction>>;
String _$salesHash() => r'5c1b9ca03f6339bb08f8be18b6fb934bb187c35c';

/// See also [sales].
@ProviderFor(sales)
final salesProvider = AutoDisposeFutureProvider<List<Transaction>>.internal(
  sales,
  name: r'salesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$salesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SalesRef = AutoDisposeFutureProviderRef<List<Transaction>>;
String _$purchasesHash() => r'4f6a04592e736b1cb129f8aae7818e35e2f5d2a0';

/// See also [purchases].
@ProviderFor(purchases)
final purchasesProvider = AutoDisposeFutureProvider<List<Transaction>>.internal(
  purchases,
  name: r'purchasesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$purchasesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PurchasesRef = AutoDisposeFutureProviderRef<List<Transaction>>;
String _$inventoryHash() => r'58eaaf7cf42b8d7f2b6cd8395efac4a86cd8f951';

/// See also [inventory].
@ProviderFor(inventory)
final inventoryProvider =
    AutoDisposeFutureProvider<List<InventoryItem>>.internal(
  inventory,
  name: r'inventoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inventoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryRef = AutoDisposeFutureProviderRef<List<InventoryItem>>;
String _$categoriesHash() => r'2a46bdcb6dda09588e4fb82a3081e7a4d8d48670';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider = AutoDisposeFutureProvider<List<String>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$inventoryValueHash() => r'893011666ef64bba817e6e7860596b4217d44268';

/// See also [inventoryValue].
@ProviderFor(inventoryValue)
final inventoryValueProvider = AutoDisposeFutureProvider<double>.internal(
  inventoryValue,
  name: r'inventoryValueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryValueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryValueRef = AutoDisposeFutureProviderRef<double>;
String _$lowStockCountHash() => r'65f03a9d36070ce8b59893715d60836402eaf820';

/// See also [lowStockCount].
@ProviderFor(lowStockCount)
final lowStockCountProvider = AutoDisposeFutureProvider<int>.internal(
  lowStockCount,
  name: r'lowStockCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lowStockCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LowStockCountRef = AutoDisposeFutureProviderRef<int>;
String _$outOfStockCountHash() => r'09fcf57d1895d0ec9a25a6fb77d9086570ce41d7';

/// See also [outOfStockCount].
@ProviderFor(outOfStockCount)
final outOfStockCountProvider = AutoDisposeFutureProvider<int>.internal(
  outOfStockCount,
  name: r'outOfStockCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outOfStockCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OutOfStockCountRef = AutoDisposeFutureProviderRef<int>;
String _$debtsHash() => r'0d400a810d5b8554ac4d99d68a612dbd00fcab57';

/// See also [debts].
@ProviderFor(debts)
final debtsProvider = AutoDisposeFutureProvider<List<Debt>>.internal(
  debts,
  name: r'debtsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebtsRef = AutoDisposeFutureProviderRef<List<Debt>>;
String _$owedToMeHash() => r'93e929df69003b07b77b7c7e39e1dbc06d7fa12e';

/// See also [owedToMe].
@ProviderFor(owedToMe)
final owedToMeProvider = AutoDisposeFutureProvider<List<Debt>>.internal(
  owedToMe,
  name: r'owedToMeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$owedToMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OwedToMeRef = AutoDisposeFutureProviderRef<List<Debt>>;
String _$iOweHash() => r'68ef69fb4b476eb9e1a4927308b30c6503a3311d';

/// See also [iOwe].
@ProviderFor(iOwe)
final iOweProvider = AutoDisposeFutureProvider<List<Debt>>.internal(
  iOwe,
  name: r'iOweProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$iOweHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IOweRef = AutoDisposeFutureProviderRef<List<Debt>>;
String _$totalOwedToMeHash() => r'a9d32c672c398b36500f658afc78571cf5eb2bd1';

/// See also [totalOwedToMe].
@ProviderFor(totalOwedToMe)
final totalOwedToMeProvider = AutoDisposeFutureProvider<double>.internal(
  totalOwedToMe,
  name: r'totalOwedToMeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalOwedToMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalOwedToMeRef = AutoDisposeFutureProviderRef<double>;
String _$totalIOweHash() => r'f1d3467d69c50f1857b7ecb42375a904cdadc286';

/// See also [totalIOwe].
@ProviderFor(totalIOwe)
final totalIOweProvider = AutoDisposeFutureProvider<double>.internal(
  totalIOwe,
  name: r'totalIOweProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalIOweHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalIOweRef = AutoDisposeFutureProviderRef<double>;
String _$overdueDebtsCountHash() => r'424b4513e6f1b25657853c549693c3c558afc809';

/// See also [overdueDebtsCount].
@ProviderFor(overdueDebtsCount)
final overdueDebtsCountProvider = AutoDisposeFutureProvider<int>.internal(
  overdueDebtsCount,
  name: r'overdueDebtsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$overdueDebtsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueDebtsCountRef = AutoDisposeFutureProviderRef<int>;
String _$overdueDebtsHash() => r'd1c5656674ce0f7bb642b7934bffc2553303355d';

/// See also [overdueDebts].
@ProviderFor(overdueDebts)
final overdueDebtsProvider = AutoDisposeFutureProvider<List<Debt>>.internal(
  overdueDebts,
  name: r'overdueDebtsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$overdueDebtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverdueDebtsRef = AutoDisposeFutureProviderRef<List<Debt>>;
String _$searchTransactionsHash() =>
    r'4126cb51afecbb45e4ba57aa742139784e4f41ea';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchTransactions].
@ProviderFor(searchTransactions)
const searchTransactionsProvider = SearchTransactionsFamily();

/// See also [searchTransactions].
class SearchTransactionsFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [searchTransactions].
  const SearchTransactionsFamily();

  /// See also [searchTransactions].
  SearchTransactionsProvider call(
    String query,
  ) {
    return SearchTransactionsProvider(
      query,
    );
  }

  @override
  SearchTransactionsProvider getProviderOverride(
    covariant SearchTransactionsProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchTransactionsProvider';
}

/// See also [searchTransactions].
class SearchTransactionsProvider
    extends AutoDisposeFutureProvider<List<Transaction>> {
  /// See also [searchTransactions].
  SearchTransactionsProvider(
    String query,
  ) : this._internal(
          (ref) => searchTransactions(
            ref as SearchTransactionsRef,
            query,
          ),
          from: searchTransactionsProvider,
          name: r'searchTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchTransactionsHash,
          dependencies: SearchTransactionsFamily._dependencies,
          allTransitiveDependencies:
              SearchTransactionsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Transaction>> Function(SearchTransactionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchTransactionsProvider._internal(
        (ref) => create(ref as SearchTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _SearchTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchTransactionsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchTransactionsRef on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with SearchTransactionsRef {
  _SearchTransactionsProviderElement(super.provider);

  @override
  String get query => (origin as SearchTransactionsProvider).query;
}

String _$inventoryItemsByCategoryHash() =>
    r'848f6cea11b08f92646a5174468c41eb074ff002';

/// See also [inventoryItemsByCategory].
@ProviderFor(inventoryItemsByCategory)
const inventoryItemsByCategoryProvider = InventoryItemsByCategoryFamily();

/// See also [inventoryItemsByCategory].
class InventoryItemsByCategoryFamily
    extends Family<AsyncValue<List<InventoryItem>>> {
  /// See also [inventoryItemsByCategory].
  const InventoryItemsByCategoryFamily();

  /// See also [inventoryItemsByCategory].
  InventoryItemsByCategoryProvider call(
    String category,
  ) {
    return InventoryItemsByCategoryProvider(
      category,
    );
  }

  @override
  InventoryItemsByCategoryProvider getProviderOverride(
    covariant InventoryItemsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'inventoryItemsByCategoryProvider';
}

/// See also [inventoryItemsByCategory].
class InventoryItemsByCategoryProvider
    extends AutoDisposeFutureProvider<List<InventoryItem>> {
  /// See also [inventoryItemsByCategory].
  InventoryItemsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => inventoryItemsByCategory(
            ref as InventoryItemsByCategoryRef,
            category,
          ),
          from: inventoryItemsByCategoryProvider,
          name: r'inventoryItemsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryItemsByCategoryHash,
          dependencies: InventoryItemsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              InventoryItemsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  InventoryItemsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<InventoryItem>> Function(InventoryItemsByCategoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryItemsByCategoryProvider._internal(
        (ref) => create(ref as InventoryItemsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<InventoryItem>> createElement() {
    return _InventoryItemsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryItemsByCategoryProvider &&
        other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InventoryItemsByCategoryRef
    on AutoDisposeFutureProviderRef<List<InventoryItem>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _InventoryItemsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<InventoryItem>>
    with InventoryItemsByCategoryRef {
  _InventoryItemsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as InventoryItemsByCategoryProvider).category;
}

String _$searchInventoryItemsHash() =>
    r'04b2e19688865940d37ce30822e28e198948329b';

/// See also [searchInventoryItems].
@ProviderFor(searchInventoryItems)
const searchInventoryItemsProvider = SearchInventoryItemsFamily();

/// See also [searchInventoryItems].
class SearchInventoryItemsFamily
    extends Family<AsyncValue<List<InventoryItem>>> {
  /// See also [searchInventoryItems].
  const SearchInventoryItemsFamily();

  /// See also [searchInventoryItems].
  SearchInventoryItemsProvider call(
    String query,
  ) {
    return SearchInventoryItemsProvider(
      query,
    );
  }

  @override
  SearchInventoryItemsProvider getProviderOverride(
    covariant SearchInventoryItemsProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchInventoryItemsProvider';
}

/// See also [searchInventoryItems].
class SearchInventoryItemsProvider
    extends AutoDisposeFutureProvider<List<InventoryItem>> {
  /// See also [searchInventoryItems].
  SearchInventoryItemsProvider(
    String query,
  ) : this._internal(
          (ref) => searchInventoryItems(
            ref as SearchInventoryItemsRef,
            query,
          ),
          from: searchInventoryItemsProvider,
          name: r'searchInventoryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchInventoryItemsHash,
          dependencies: SearchInventoryItemsFamily._dependencies,
          allTransitiveDependencies:
              SearchInventoryItemsFamily._allTransitiveDependencies,
          query: query,
        );

  SearchInventoryItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<InventoryItem>> Function(SearchInventoryItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchInventoryItemsProvider._internal(
        (ref) => create(ref as SearchInventoryItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<InventoryItem>> createElement() {
    return _SearchInventoryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchInventoryItemsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchInventoryItemsRef
    on AutoDisposeFutureProviderRef<List<InventoryItem>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchInventoryItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<InventoryItem>>
    with SearchInventoryItemsRef {
  _SearchInventoryItemsProviderElement(super.provider);

  @override
  String get query => (origin as SearchInventoryItemsProvider).query;
}

String _$categoriesFromInventoryHash() =>
    r'31446b7d6156f6748c2f5f67bc002483ae8b0b0e';

/// See also [categoriesFromInventory].
@ProviderFor(categoriesFromInventory)
final categoriesFromInventoryProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
  categoriesFromInventory,
  name: r'categoriesFromInventoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoriesFromInventoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesFromInventoryRef = AutoDisposeFutureProviderRef<List<String>>;
String _$totalRevenueHash() => r'7505fca99585d93f636c4fe7007cfa34fe54eaf2';

/// See also [totalRevenue].
@ProviderFor(totalRevenue)
const totalRevenueProvider = TotalRevenueFamily();

/// See also [totalRevenue].
class TotalRevenueFamily extends Family<AsyncValue<double>> {
  /// See also [totalRevenue].
  const TotalRevenueFamily();

  /// See also [totalRevenue].
  TotalRevenueProvider call(
    String period,
  ) {
    return TotalRevenueProvider(
      period,
    );
  }

  @override
  TotalRevenueProvider getProviderOverride(
    covariant TotalRevenueProvider provider,
  ) {
    return call(
      provider.period,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'totalRevenueProvider';
}

/// See also [totalRevenue].
class TotalRevenueProvider extends AutoDisposeFutureProvider<double> {
  /// See also [totalRevenue].
  TotalRevenueProvider(
    String period,
  ) : this._internal(
          (ref) => totalRevenue(
            ref as TotalRevenueRef,
            period,
          ),
          from: totalRevenueProvider,
          name: r'totalRevenueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalRevenueHash,
          dependencies: TotalRevenueFamily._dependencies,
          allTransitiveDependencies:
              TotalRevenueFamily._allTransitiveDependencies,
          period: period,
        );

  TotalRevenueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final String period;

  @override
  Override overrideWith(
    FutureOr<double> Function(TotalRevenueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalRevenueProvider._internal(
        (ref) => create(ref as TotalRevenueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _TotalRevenueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalRevenueProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TotalRevenueRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `period` of this provider.
  String get period;
}

class _TotalRevenueProviderElement
    extends AutoDisposeFutureProviderElement<double> with TotalRevenueRef {
  _TotalRevenueProviderElement(super.provider);

  @override
  String get period => (origin as TotalRevenueProvider).period;
}

String _$totalExpensesHash() => r'ad54cfc0c3d65c950e456708b415cd817bc66571';

/// See also [totalExpenses].
@ProviderFor(totalExpenses)
const totalExpensesProvider = TotalExpensesFamily();

/// See also [totalExpenses].
class TotalExpensesFamily extends Family<AsyncValue<double>> {
  /// See also [totalExpenses].
  const TotalExpensesFamily();

  /// See also [totalExpenses].
  TotalExpensesProvider call(
    String period,
  ) {
    return TotalExpensesProvider(
      period,
    );
  }

  @override
  TotalExpensesProvider getProviderOverride(
    covariant TotalExpensesProvider provider,
  ) {
    return call(
      provider.period,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'totalExpensesProvider';
}

/// See also [totalExpenses].
class TotalExpensesProvider extends AutoDisposeFutureProvider<double> {
  /// See also [totalExpenses].
  TotalExpensesProvider(
    String period,
  ) : this._internal(
          (ref) => totalExpenses(
            ref as TotalExpensesRef,
            period,
          ),
          from: totalExpensesProvider,
          name: r'totalExpensesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$totalExpensesHash,
          dependencies: TotalExpensesFamily._dependencies,
          allTransitiveDependencies:
              TotalExpensesFamily._allTransitiveDependencies,
          period: period,
        );

  TotalExpensesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final String period;

  @override
  Override overrideWith(
    FutureOr<double> Function(TotalExpensesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TotalExpensesProvider._internal(
        (ref) => create(ref as TotalExpensesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _TotalExpensesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalExpensesProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TotalExpensesRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `period` of this provider.
  String get period;
}

class _TotalExpensesProviderElement
    extends AutoDisposeFutureProviderElement<double> with TotalExpensesRef {
  _TotalExpensesProviderElement(super.provider);

  @override
  String get period => (origin as TotalExpensesProvider).period;
}

String _$outstandingDebtsHash() => r'b39fcfa282dc9fe0d718d9a13446da94e4fcf7f6';

/// See also [outstandingDebts].
@ProviderFor(outstandingDebts)
final outstandingDebtsProvider = AutoDisposeFutureProvider<double>.internal(
  outstandingDebts,
  name: r'outstandingDebtsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outstandingDebtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OutstandingDebtsRef = AutoDisposeFutureProviderRef<double>;
String _$searchQueryHash() => r'5cfb8bc058f64b12d9a61421526a8ea7b414d4fa';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$selectedCategoryHash() => r'fe9c43024d66bca287482ad10da5c9038f0508c1';

/// See also [SelectedCategory].
@ProviderFor(SelectedCategory)
final selectedCategoryProvider =
    AutoDisposeNotifierProvider<SelectedCategory, String>.internal(
  SelectedCategory.new,
  name: r'selectedCategoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategory = AutoDisposeNotifier<String>;
String _$selectedTransactionTypeHash() =>
    r'286488fc0bde918dd36d726bbf87692367ef34c1';

/// See also [SelectedTransactionType].
@ProviderFor(SelectedTransactionType)
final selectedTransactionTypeProvider =
    AutoDisposeNotifierProvider<SelectedTransactionType, String>.internal(
  SelectedTransactionType.new,
  name: r'selectedTransactionTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTransactionTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTransactionType = AutoDisposeNotifier<String>;
String _$selectedDebtTypeHash() => r'1feaa8b21506878c1bab7c69e6c34b2fad07da4a';

/// See also [SelectedDebtType].
@ProviderFor(SelectedDebtType)
final selectedDebtTypeProvider =
    AutoDisposeNotifierProvider<SelectedDebtType, String>.internal(
  SelectedDebtType.new,
  name: r'selectedDebtTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDebtTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDebtType = AutoDisposeNotifier<String>;
String _$transactionFormDataHash() =>
    r'21aacc6ae690b67c953947584e7bcdbb82df6a18';

/// See also [TransactionFormData].
@ProviderFor(TransactionFormData)
final transactionFormDataProvider = AutoDisposeNotifierProvider<
    TransactionFormData, Map<String, dynamic>>.internal(
  TransactionFormData.new,
  name: r'transactionFormDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionFormDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionFormData = AutoDisposeNotifier<Map<String, dynamic>>;
String _$debtFormDataHash() => r'9120faae4c9942b894ed7d25bdb7172a8a3810b4';

/// See also [DebtFormData].
@ProviderFor(DebtFormData)
final debtFormDataProvider =
    AutoDisposeNotifierProvider<DebtFormData, Map<String, dynamic>>.internal(
  DebtFormData.new,
  name: r'debtFormDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debtFormDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DebtFormData = AutoDisposeNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
