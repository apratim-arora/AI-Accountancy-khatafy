import 'package:accountancy_ai_app/models/debt.dart';
import 'package:accountancy_ai_app/providers/providers.dart';
import 'package:accountancy_ai_app/screens/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

class DebtScreen extends ConsumerStatefulWidget {
  const DebtScreen({super.key});

  @override
  ConsumerState<DebtScreen> createState() => _DebtScreenState();
}

class _DebtScreenState extends ConsumerState<DebtScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(
                'Debts',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
              pinned: true,
              floating: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade700, Colors.purple.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.purple.shade200.withOpacity(0.5),
              bottom: TabBar(
                indicatorPadding:
                    const EdgeInsetsGeometry.symmetric(vertical: 5),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w400),
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.white,
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Tab(
                      text: 'Money I Owe',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Tab(text: 'Money Owed to Me'),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            FadeInUp(child: _buildDebtSummary()),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDebtList('i_owe'),
                  _buildDebtList('owed_to_me'),
                ],
              ),
            ),
            FadeInUp(child: _buildPendingPaymentsSummary()),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
        child: FloatingActionButton(
          heroTag: "add_debt",
          onPressed: () => _showAddDebtForm(),
          backgroundColor: Colors.purple.shade600,
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

  Widget _buildDebtSummary() {
    var width = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, ref, child) {
        final totalIOwe = ref.watch(totalIOweProvider);
        final totalOwedToMe = ref.watch(totalOwedToMeProvider);
        final overdueCount = ref.watch(overdueDebtsCountProvider);

        return Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
            children: [
              // Total I Owe box (full width at the top)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: width * 0.2), // Left padding
                  Expanded(
                    child: FadeInUp(
                      child: _buildSummaryCard(
                        'Total I Owe',
                        totalIOwe.when(
                          data: (amount) => '₹${amount.toStringAsFixed(2)}',
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.red.shade400,
                        Icons.arrow_upward,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.2),
                ],
              ),
              const SizedBox(
                  height: 5), // Spacing between the top card and the row below

              // Owed to Me and Overdue boxes (side-by-side below)
              Row(
                children: [
                  Expanded(
                    child: FadeInLeft(
                      child: _buildSummaryCard(
                        'Owed to Me',
                        totalOwedToMe.when(
                          data: (amount) => '₹${amount.toStringAsFixed(2)}',
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.green.shade400,
                        Icons.arrow_downward,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 5), // Spacing between the two cards in the row
                  Expanded(
                    child: FadeInRight(
                      child: _buildSummaryCard(
                        'Overdue',
                        overdueCount.when(
                          data: (count) => count.toString(),
                          loading: () => '...',
                          error: (_, __) => 'Error',
                        ),
                        Colors.orange.shade400,
                        Icons.warning,
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
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtList(String type) {
    return Consumer(
      builder: (context, ref, child) {
        final debtsAsync = type == 'i_owe'
            ? ref.watch(iOweProvider)
            : ref.watch(owedToMeProvider);

        return debtsAsync.when(
          data: (debts) {
            if (debts.isEmpty) {
              return Center(
                child: FadeIn(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money_off,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No debts found',
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
              // Remove padding here if you want it to align with the rest of the scrollable content
              // Otherwise, keep it if you want internal padding for the list
              padding: const EdgeInsets.all(16),
              itemCount: debts.length,
              itemBuilder: (context, index) {
                final debt = debts[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: _buildDebtCard(debt),
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

  Widget _buildDebtCard(Debt debt) {
    final isOverdue = debt.dueDate != null &&
        debt.dueDate!.isBefore(DateTime.now()) &&
        !debt.isPaid;
    final isIOwe = debt.type == 'i_owe';
    final color = isIOwe ? Colors.red.shade400 : Colors.green.shade400;

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
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIOwe ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 28,
            ),
          ),
          title: Text(
            debt.personName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (debt.description != null && debt.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    debt.description!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(debt.date)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              if (debt.dueDate != null)
                Text(
                  'Due: ${DateFormat('MMM dd, yyyy').format(debt.dueDate!)}',
                  style: TextStyle(
                    color:
                        isOverdue ? Colors.red.shade400 : Colors.grey.shade600,
                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              if (debt.isPaid)
                Text(
                  'PAID',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${debt.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 16,
                ),
              ),
              if (isOverdue && !debt.isPaid)
                Text(
                  'OVERDUE',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          onTap: () => _showDebtDetails(debt),
        ),
      ),
    );
  }

  Widget _buildPendingPaymentsSummary() {
    return Consumer(
      builder: (context, ref, child) {
        final overdueDebts = ref.watch(overdueDebtsProvider);

        return overdueDebts.when(
          data: (debts) {
            if (debts.isEmpty) return const SizedBox.shrink();

            final totalOverdue =
                debts.fold<double>(0, (sum, debt) => sum + debt.amount);

            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.red.shade600, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overdue Payments',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${debts.length} payments overdue: ₹${totalOverdue.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  void _showAddDebtForm() {
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
        child: const AddDebtForm(),
      ),
    );
  }

  void _showDebtDetails(Debt debt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          debt.personName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ₹${debt.amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.grey.shade800),
            ),
            Text(
              'Type: ${debt.type == 'i_owe' ? 'I Owe' : 'Owed to Me'}',
              style: TextStyle(color: Colors.grey.shade800),
            ),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(debt.date)}',
              style: TextStyle(color: Colors.grey.shade800),
            ),
            if (debt.dueDate != null)
              Text(
                'Due Date: ${DateFormat('MMM dd, yyyy').format(debt.dueDate!)}',
                style: TextStyle(color: Colors.grey.shade800),
              ),
            if (debt.description != null && debt.description!.isNotEmpty)
              Text(
                'Description: ${debt.description}',
                style: TextStyle(color: Colors.grey.shade800),
              ),
            Text(
              'Status: ${debt.isPaid ? 'Paid' : 'Pending'}',
              style: TextStyle(
                color:
                    debt.isPaid ? Colors.green.shade400 : Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          if (!debt.isPaid)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(databaseServiceProvider).markDebtAsPaid(debt.id!);
                ref.invalidate(iOweProvider);
                ref.invalidate(owedToMeProvider);
                ref.invalidate(totalOwedToMeProvider);
                ref.invalidate(totalIOweProvider);
              },
              child: Text(
                'Mark as Paid',
                style: TextStyle(color: Colors.purple.shade600),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: Colors.purple.shade600),
            ),
          ),
        ],
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
              style: TextStyle(color: Colors.purple.shade600),
            ),
          ),
        ],
      ),
    );
  }
}