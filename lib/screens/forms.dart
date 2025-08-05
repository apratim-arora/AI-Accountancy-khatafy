import 'package:accountancy_ai_app/models/debt.dart';
import 'package:accountancy_ai_app/models/inventory_item.dart';
import 'package:accountancy_ai_app/models/transaction.dart';
import 'package:accountancy_ai_app/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends ConsumerStatefulWidget {
  final String type;
  final Transaction? existingTransaction;

  const AddTransactionForm(this.type, {super.key, this.existingTransaction});

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      final tx = widget.existingTransaction!;
      _itemNameController.text = tx.itemName;
      _quantityController.text = tx.quantity.toString();
      _unitPriceController.text = tx.unitPrice.toStringAsFixed(2);
      _notesController.text = tx.notes ?? '';
      _selectedDate = tx.date;
      _dateController.text = DateFormat('dd MMM, yyyy').format(_selectedDate);
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final itemName = _itemNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final notes = _notesController.text.trim();
    final totalAmount = quantity * unitPrice;

    final transaction = Transaction(
      id: widget.existingTransaction?.id,
      itemName: itemName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalAmount: totalAmount,
      date: _selectedDate,
      type: widget.type,
      notes: notes.isEmpty ? null : notes,
    );

    final db = ref.read(databaseServiceProvider);

    if (widget.existingTransaction != null) {
      await db.updateTransaction(transaction);
    } else {
      await db.insertTransaction(transaction);
    }

    ref.invalidate(transactionsProvider);
    ref.invalidate(salesProvider);
    ref.invalidate(purchasesProvider);

    if (mounted) Navigator.pop(context);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd MMM, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTransaction != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Transaction' : 'Add Transaction',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter item name'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter quantity'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unitPriceController,
                      decoration:
                          const InputDecoration(labelText: 'Unit Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter unit price'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                      isEditing ? 'Update Transaction' : 'Add Transaction',
                      style: Theme.of(context).textTheme.labelMedium),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// class AddTransactionForm extends ConsumerStatefulWidget {
//   const AddTransactionForm({super.key});

//   @override
//   ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
// }

// class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _itemNameController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _unitPriceController = TextEditingController();
//   final _notesController = TextEditingController();
//   final _customerNameController = TextEditingController();

//   String _selectedType = 'sale';
//   String _selectedPaymentMethod = 'cash';
//   DateTime _selectedDate = DateTime.now();

//   @override
//   void dispose() {
//     _itemNameController.dispose();
//     _quantityController.dispose();
//     _unitPriceController.dispose();
//     _notesController.dispose();
//     _customerNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Add Transaction',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 20),
//             DropdownButtonFormField<String>(
//               value: _selectedType,
//               decoration: const InputDecoration(
//                 labelText: 'Type',
//                 border: OutlineInputBorder(),
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'sale', child: Text('Sale')),
//                 DropdownMenuItem(value: 'purchase', child: Text('Purchase')),
//               ],
//               onChanged: (value) => setState(() => _selectedType = value!),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _itemNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Item Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _quantityController,
//                     decoration: const InputDecoration(
//                       labelText: 'Quantity',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _unitPriceController,
//                     decoration: const InputDecoration(
//                       labelText: 'Unit Price',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _customerNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Customer Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<String>(
//               value: _selectedPaymentMethod,
//               decoration: const InputDecoration(
//                 labelText: 'Payment Method',
//                 border: OutlineInputBorder(),
//               ),
//               items: const [
//                 DropdownMenuItem(value: 'cash', child: Text('Cash')),
//                 DropdownMenuItem(value: 'card', child: Text('Card')),
//                 DropdownMenuItem(value: 'upi', child: Text('UPI')),
//                 DropdownMenuItem(value: 'bank_transfer', child: Text('Bank Transfer')),
//               ],
//               onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _notesController,
//               decoration: const InputDecoration(
//                 labelText: 'Notes',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _saveTransaction,
//                     child: const Text('Save'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void _saveTransaction() async {
//     if (_formKey.currentState!.validate()) {
//       final quantity = int.parse(_quantityController.text);
//       final unitPrice = double.parse(_unitPriceController.text);
//       final totalAmount = quantity * unitPrice;

//       final transaction = Transaction(
//         type: _selectedType,
//         itemName: _itemNameController.text,
//         quantity: quantity,
//         unitPrice: unitPrice,
//         totalAmount: totalAmount,
//         date: _selectedDate,
//         notes: _notesController.text.isEmpty ? null : _notesController.text,
//       );

//       final db = ref.read(databaseServiceProvider);
//       await db.insertTransaction(transaction);

//       // Refresh the providers
//       ref.invalidate(transactionsProvider);
//       ref.invalidate(salesProvider);
//       ref.invalidate(purchasesProvider);

//       Navigator.pop(context);
//     }
//   }
// }
class AddInventoryForm extends ConsumerStatefulWidget {
  final InventoryItem? existingItem;

  const AddInventoryForm({super.key, this.existingItem});

  @override
  ConsumerState<AddInventoryForm> createState() => _AddInventoryFormState();
}

class _AddInventoryFormState extends ConsumerState<AddInventoryForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _currentStockController;
  late final TextEditingController _minStockController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _unitController;

  bool get isEditing => widget.existingItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.existingItem;

    _nameController = TextEditingController(text: item?.name ?? '');
    _currentStockController =
        TextEditingController(text: item?.currentStock.toString() ?? '');
    _minStockController =
        TextEditingController(text: item?.minStock.toString() ?? '');
    _purchasePriceController =
        TextEditingController(text: item?.purchasePrice.toString() ?? '');
    _sellingPriceController =
        TextEditingController(text: item?.sellingPrice.toString() ?? '');
    _categoryController = TextEditingController(text: item?.category ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _unitController = TextEditingController(text: item?.unit ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentStockController.dispose();
    _minStockController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Inventory Item' : 'Add Inventory Item',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildTextField(_nameController, 'Item Name', isRequired: true),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _currentStockController,
                    'Current Stock',
                    isRequired: true,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _minStockController,
                    'Min Stock',
                    isRequired: true,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _purchasePriceController,
                    'Purchase Price',
                    isRequired: true,
                    isNumber: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _sellingPriceController,
                    'Selling Price',
                    isRequired: true,
                    isNumber: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _categoryController,
                    'Category',
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _unitController,
                    'Unit (kg, pcs, etc.)',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              _descriptionController,
              'Description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveInventoryItem,
                    child: Text(isEditing ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isRequired = false,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: isRequired
          ? (value) => value == null || value.isEmpty ? 'Required' : null
          : null,
    );
  }

  Future<void> _saveInventoryItem() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      final item = InventoryItem(
        id: widget.existingItem?.id,
        name: _nameController.text,
        currentStock: int.parse(_currentStockController.text),
        minStock: int.parse(_minStockController.text),
        purchasePrice: double.parse(_purchasePriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        category: _categoryController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        unit: _unitController.text.isEmpty ? null : _unitController.text,
        lastUpdated: DateTime.now(),
      );

      final db = ref.read(databaseServiceProvider);

      // if (isEditing) {
      //   await db.updateInventoryItem(item);
      // } else {
      await db.insertInventoryItem(item);
      // }

      await db.insertCategory(_categoryController.text, null);

      // Refresh relevant providers
      ref.invalidate(inventoryProvider);
      ref.invalidate(categoriesProvider);
      ref.invalidate(categoriesFromInventoryProvider);
      ref.invalidate(inventoryValueProvider);
      ref.invalidate(lowStockCountProvider);
      ref.invalidate(outOfStockCountProvider);

      final searchQuery = ref.read(searchQueryProvider);
      final selectedCategory = ref.read(selectedCategoryProvider);

      if (searchQuery.isNotEmpty) {
        ref.invalidate(searchInventoryItemsProvider);
      }
      if (selectedCategory != 'All') {
        ref.invalidate(inventoryItemsByCategoryProvider);
      }

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? '${item.name} updated successfully!'
                  : '${item.name} added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class AddDebtForm extends ConsumerStatefulWidget {
  const AddDebtForm({super.key});

  @override
  ConsumerState<AddDebtForm> createState() => _AddDebtFormState();
}

class _AddDebtFormState extends ConsumerState<AddDebtForm> {
  final _formKey = GlobalKey<FormState>();
  final _personNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _dueDateController = TextEditingController();

  String _selectedType = 'owed_to_me';
  String _selectedPaymentMethod = 'cash';
  final DateTime _selectedDate = DateTime.now();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _personNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _contactNumberController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
        _dueDateController.text = DateFormat('dd MMM, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Debt',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'owed_to_me', child: Text('Money Owed to Me')),
                  DropdownMenuItem(value: 'i_owe', child: Text('Money I Owe')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _personNameController,
                decoration: const InputDecoration(
                  labelText: 'Person Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _contactNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickDueDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dueDateController,
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'card', child: Text('Card')),
                  DropdownMenuItem(value: 'upi', child: Text('UPI')),
                  DropdownMenuItem(
                      value: 'bank_transfer', child: Text('Bank Transfer')),
                ],
                onChanged: (value) =>
                    setState(() => _selectedPaymentMethod = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveDebt,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDebt() async {
    if (_formKey.currentState!.validate()) {
      final debt = Debt(
        personName: _personNameController.text,
        type: _selectedType,
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        date: _selectedDate,
        dueDate: _selectedDueDate,
        isPaid: false,
      );

      final db = ref.read(databaseServiceProvider);
      await db.insertDebt(debt);

      // Refresh the providers
      ref.invalidate(debtsProvider);
      ref.invalidate(owedToMeProvider);
      ref.invalidate(iOweProvider);
      ref.invalidate(totalOwedToMeProvider);
      ref.invalidate(totalIOweProvider);
      ref.invalidate(overdueDebtsCountProvider);
      ref.invalidate(overdueDebtsProvider);

      Navigator.pop(context);
    }
  }
}
