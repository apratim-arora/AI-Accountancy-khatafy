// import 'package:accountancy_ai_app/models/inventory_item.dart';
// import 'package:accountancy_ai_app/providers/providers.dart';
// import 'package:accountancy_ai_app/screens/forms.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class InventoryScreen extends ConsumerStatefulWidget {
//   const InventoryScreen({super.key});

//   @override
//   ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
// }

// class _InventoryScreenState extends ConsumerState<InventoryScreen>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//         length: 1, vsync: this); // Will be dynamic based on categories
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _showAddInventoryForm() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => const AddInventoryForm(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Inventory'),
//         backgroundColor: Colors.green.shade600,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Summary Cards
//           _buildSummarySection(),
//           // Search Bar
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search inventory...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//               onChanged: (value) {
//                 ref.read(searchQueryProvider.notifier).updateQuery(value);
//               },
//             ),
//           ),
//           // Categories and Items
//           Expanded(
//             child: _buildCategoriesAndItems(),
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             heroTag: "add_inventory",
//             onPressed: () => _showAddInventoryForm(),
//             backgroundColor: Colors.green.shade600,
//             child: const Icon(Icons.add, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSummarySection() {
//     return Consumer(
//       builder: (context, ref, child) {
//         final inventoryValue = ref.watch(inventoryValueProvider);
//         final lowStockCount = ref.watch(lowStockCountProvider);
//         final outOfStockCount = ref.watch(outOfStockCountProvider);

//         return Container(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: _buildSummaryCard(
//                   'Total Value',
//                   inventoryValue.when(
//                     data: (value) => '₹${value.toStringAsFixed(2)}',
//                     loading: () => '...',
//                     error: (_, __) => 'Error',
//                   ),
//                   Colors.blue,
//                   Icons.inventory,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildSummaryCard(
//                   'Low Stock',
//                   lowStockCount.when(
//                     data: (count) => count.toString(),
//                     loading: () => '...',
//                     error: (_, __) => 'Error',
//                   ),
//                   Colors.orange,
//                   Icons.warning,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildSummaryCard(
//                   'Out of Stock',
//                   outOfStockCount.when(
//                     data: (count) => count.toString(),
//                     loading: () => '...',
//                     error: (_, __) => 'Error',
//                   ),
//                   Colors.red,
//                   Icons.error,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSummaryCard(
//       String title, String value, Color color, IconData icon) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoriesAndItems() {
//     return Consumer(
//       builder: (context, ref, child) {
//         final categoriesAsync = ref.watch(categoriesFromInventoryProvider);
//         final selectedCategory = ref.watch(selectedCategoryProvider);
//         final searchQuery = ref.watch(searchQueryProvider);

//         return categoriesAsync.when(
//           data: (categories) {
//             // Update tab controller if needed
//             if (_tabController.length != categories.length + 1) {
//               _tabController.dispose();
//               _tabController =
//                   TabController(length: categories.length + 1, vsync: this);
//             }

//             return Column(
//               children: [
//                 // Category Tabs
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey.shade300),
//                     ),
//                   ),
//                   child: TabBar(
//                     controller: _tabController,
//                     isScrollable: true,
//                     labelColor: Colors.green.shade600,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.green.shade600,
//                     tabs: [
//                       const Tab(text: 'All'),
//                       ...categories.map((category) => Tab(text: category)),
//                     ],
//                     onTap: (index) {
//                       ref
//                           .read(selectedCategoryProvider.notifier)
//                           .updateCategory(
//                               index == 0 ? 'All' : categories[index - 1]);
//                     },
//                   ),
//                 ),
//                 // Items List
//                 Expanded(
//                   child: _buildItemsList(),
//                 ),
//               ],
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stackTrace) => Center(child: Text('Error: $error')),
//         );
//       },
//     );
//   }

//   Widget _buildItemsList() {
//     return Consumer(
//       builder: (context, ref, child) {
//         final searchQuery = ref.watch(searchQueryProvider);
//         final selectedCategory = ref.watch(selectedCategoryProvider);

//         AsyncValue<List<InventoryItem>> itemsAsync;

//         if (searchQuery.isNotEmpty) {
//           itemsAsync = ref.watch(searchInventoryItemsProvider(searchQuery));
//         } else if (selectedCategory != 'All') {
//           itemsAsync =
//               ref.watch(inventoryItemsByCategoryProvider(selectedCategory));
//         } else {
//           itemsAsync = ref.watch(inventoryProvider);
//         }

//         return itemsAsync.when(
//           data: (items) {
//             if (items.isEmpty) {
//               return const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.inventory_2, size: 64, color: Colors.grey),
//                     SizedBox(height: 16),
//                     Text('No items found',
//                         style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   ],
//                 ),
//               );
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return _buildInventoryCard(item);
//               },
//             );
//           },
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stackTrace) => Center(child: Text('Error: $error')),
//         );
//       },
//     );
//   }

//   Widget _buildInventoryCard(InventoryItem item) {
//     final isLowStock = item.currentStock <= item.minStock;
//     final isOutOfStock = item.currentStock == 0;

//     Color statusColor = Colors.green;
//     if (isOutOfStock) {
//       statusColor = Colors.red;
//     } else if (isLowStock) {
//       statusColor = Colors.orange;
//     }

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: () => _showEditInventoryForm(item), // <-- tap to edit
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(Icons.inventory, color: statusColor, size: 30),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(item.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         )),
//                     const SizedBox(height: 4),
//                     Text(
//                         'Stock: ${item.currentStock} ${item.unit ?? ''} • Category: ${item.category}',
//                         style:
//                             TextStyle(fontSize: 13, color: Colors.grey[700])),
//                     Text(
//                       '₹${item.purchasePrice.toStringAsFixed(2)} ➝ ₹${item.sellingPrice.toStringAsFixed(2)}',
//                       style:
//                           const TextStyle(fontSize: 13, color: Colors.black54),
//                     ),
//                     if (item.description != null &&
//                         item.description!.isNotEmpty)
//                       Text(
//                         item.description!,
//                         style:
//                             const TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                   ],
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
//                     onPressed: () => _showEditInventoryForm(item),
//                   ),
//                   Text(
//                     isOutOfStock
//                         ? 'Out of Stock'
//                         : isLowStock
//                             ? 'Low Stock'
//                             : 'In Stock',
//                     style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: statusColor),
//                   ),
//                   Text(
//                     'Value: ₹${(item.currentStock * item.sellingPrice).toStringAsFixed(2)}',
//                     style: const TextStyle(fontSize: 11, color: Colors.grey),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showEditInventoryForm(InventoryItem item) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) => AddInventoryForm(
//       existingItem: item,
//     ),
//   );
// }

//   void _showVoiceInterface() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Voice Interface'),
//         content: const Text('Voice interface coming soon!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:accountancy_ai_app/models/inventory_item.dart';
import 'package:accountancy_ai_app/providers/providers.dart';
import 'package:accountancy_ai_app/screens/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showAddInventoryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const AddInventoryForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.green.shade200.withOpacity(0.5),
      ),
      body: Column(
        children: [
          FadeInUp(child: _buildSummarySection()),
          FadeInUp(child: _buildSearchBar()),
          Expanded(
            child: _buildCategoriesAndItems(),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
        child: FloatingActionButton(
          heroTag: "add_inventory",
          onPressed: () => _showAddInventoryForm(),
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Consumer(
      builder: (context, ref, child) {
        final inventoryValue = ref.watch(inventoryValueProvider);
        final lowStockCount = ref.watch(lowStockCountProvider);
        final outOfStockCount = ref.watch(outOfStockCountProvider);

        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            // Changed from Row to Column
            children: [
              // First Row: Total Value box (full width)
              Row(
                children: [
                  Expanded(
                    child: FadeInDown(
                      // Keeping the original animation
                      child: _buildSummaryCard(
                        'Total Value',
                        inventoryValue.when(
                          data: (value) => '₹${value.toStringAsFixed(2)}',
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.blue.shade400,
                        Icons.inventory,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              // Second Row: Low Stock and Out of Stock boxes (half width each)
              Row(
                children: [
                  Expanded(
                    child: FadeInLeft(
                      // Keeping the original animation
                      child: _buildSummaryCard(
                        'Low Stock',
                        lowStockCount.when(
                          data: (count) => count.toString(),
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.orange.shade400,
                        Icons.warning,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 5), // Spacing between the two cards in the row
                  Expanded(
                    child: FadeInRight(
                      // Keeping the original animation
                      child: _buildSummaryCard(
                        'Out of Stock',
                        outOfStockCount.when(
                          data: (count) => count.toString(),
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.red.shade400,
                        Icons.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8), // Reduced padding from 16 to 12
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Use minimum space required by children
          children: [
            Icon(icon,
                color: color,
                size: 24), // Slightly reduced icon size from 28 to 24
            const SizedBox(height: 6), // Reduced SizedBox height from 8 to 6
            Text(
              value,
              style: TextStyle(
                fontSize: 18, // Reduced font size from 20 to 18
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // Reduced font size from 14 to 12
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      margin: const EdgeInsets.only(left: 16,right: 16, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search inventory...',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).updateQuery(value);
        },
      ),
    );
  }

  Widget _buildCategoriesAndItems() {
    return Consumer(
      builder: (context, ref, child) {
        final categoriesAsync = ref.watch(categoriesFromInventoryProvider);
        final selectedCategory = ref.watch(selectedCategoryProvider);

        return categoriesAsync.when(
          data: (categories) {
            if (_tabController.length != categories.length + 1) {
              _tabController.dispose();
              _tabController =
                  TabController(length: categories.length + 1, vsync: this);
            }

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FadeIn(
                    delay: const Duration(milliseconds: 300),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorPadding: EdgeInsetsGeometry.symmetric(vertical: 5),
                      labelColor: Colors.white,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade600,
                            Colors.green.shade400,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w400),
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Tab(text: 'All'),
                        ),
                        ...categories.map((category) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Tab(text: category),
                            )),
                      ],
                      onTap: (index) {
                        ref
                            .read(selectedCategoryProvider.notifier)
                            .updateCategory(
                                index == 0 ? 'All' : categories[index - 1]);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: _buildItemsList(),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsList() {
    return Consumer(
      builder: (context, ref, child) {
        final searchQuery = ref.watch(searchQueryProvider);
        final selectedCategory = ref.watch(selectedCategoryProvider);

        AsyncValue<List<InventoryItem>> itemsAsync;

        if (searchQuery.isNotEmpty) {
          itemsAsync = ref.watch(searchInventoryItemsProvider(searchQuery));
        } else if (selectedCategory != 'All') {
          itemsAsync =
              ref.watch(inventoryItemsByCategoryProvider(selectedCategory));
        } else {
          itemsAsync = ref.watch(inventoryProvider);
        }

        return itemsAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: FadeIn(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildInventoryCard(item),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    final isLowStock = item.currentStock <= item.minStock;
    final isOutOfStock = item.currentStock == 0;

    Color statusColor = Colors.green.shade400;
    if (isOutOfStock) {
      statusColor = Colors.red.shade400;
    } else if (isLowStock) {
      statusColor = Colors.orange.shade400;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, statusColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () => _showEditInventoryForm(item),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inventory, color: statusColor, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Stock: ${item.currentStock} ${item.unit ?? ''} • Category: ${item.category}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '₹${item.purchasePrice.toStringAsFixed(2)} ➝ ₹${item.sellingPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (item.description != null &&
                          item.description!.isNotEmpty)
                        Text(
                          item.description!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          size: 20, color: Colors.grey.shade600),
                      onPressed: () => _showEditInventoryForm(item),
                    ),
                    Text(
                      isOutOfStock
                          ? 'Out of Stock'
                          : isLowStock
                              ? 'Low Stock'
                              : 'In Stock',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      'Value: ₹${(item.currentStock * item.sellingPrice).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditInventoryForm(InventoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: AddInventoryForm(existingItem: item),
      ),
    );
  }

  void _showVoiceInterface() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Voice Interface',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Voice interface coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.green.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
