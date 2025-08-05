import 'package:accountancy_ai_app/models/transaction.dart';
import 'package:accountancy_ai_app/providers/providers.dart';
import 'package:accountancy_ai_app/screens/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.blue.shade200.withOpacity(0.5),
        bottom: TabBar(
          indicatorPadding: EdgeInsetsGeometry.symmetric(vertical: 5),
          labelPadding: EdgeInsets.symmetric(horizontal: 8),
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.white70,
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Tab(text: 'All'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Tab(text: 'Sales'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Tab(text: 'Purchases'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FadeInUp(child: _buildSearchBar()),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList('all'),
                _buildTransactionList('sale'),
                _buildTransactionList('purchase'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
        child: FloatingActionButton(
          heroTag: "add_transaction",
          onPressed: () => _showTransactionTypeDialog(),
          backgroundColor: Colors.blue.shade600,
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

  void _showTransactionTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Transaction'),
          content: const Text('What type of transaction would you like to add?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Purchase'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToAddTransactionForm('purchase');
              },
            ),
            TextButton(
              child: const Text('Sale'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _navigateToAddTransactionForm('sale');
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddTransactionForm(String type) {
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
        child: AddTransactionForm(type),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          hintText: 'Search transactions...',
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

  Widget _buildTransactionList(String type) {
    return Consumer(
      builder: (context, ref, child) {
        final searchQuery = ref.watch(searchQueryProvider);
        AsyncValue<List<Transaction>> transactionsAsync;

        if (searchQuery.isNotEmpty) {
          transactionsAsync = ref.watch(searchTransactionsProvider(searchQuery));
        } else {
          switch (type) {
            case 'sale':
              transactionsAsync = ref.watch(salesProvider);
              break;
            case 'purchase':
              transactionsAsync = ref.watch(purchasesProvider);
              break;
            default:
              transactionsAsync = ref.watch(transactionsProvider);
          }
        }

        return transactionsAsync.when(
          data: (transactions) {
            if (transactions.isEmpty) {
              return Center(
                child: FadeIn(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
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
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildTransactionCard(transaction),
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

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = transaction.type == 'sale';
    final color = isIncome ? Colors.green.shade400 : Colors.red.shade400;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${transaction.quantity} x ₹${transaction.unitPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(transaction.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (transaction.notes != null && transaction.notes!.isNotEmpty)
                      Text(
                        transaction.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${transaction.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade600),
                        onPressed: () {
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
                              child: AddTransactionForm(
                                transaction.type,
                                existingTransaction: transaction,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade600),
                        onPressed: () async {
                          await ref.read(databaseServiceProvider).deleteTransaction(transaction.id!);
                          ref.invalidate(transactionsProvider);
                          ref.invalidate(salesProvider);
                          ref.invalidate(purchasesProvider);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}