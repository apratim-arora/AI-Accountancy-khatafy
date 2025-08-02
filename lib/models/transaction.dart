class Transaction {
  final int? id;
  final String type;
  final String itemName;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final DateTime date;
  final String? notes;
  final String? customerName;
  final String? paymentMethod;

  Transaction({
    this.id,
    required this.type,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.date,
    this.notes,
    this.customerName,
    this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'itemName': itemName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'notes': notes,
      'customerName': customerName,
      'paymentMethod': paymentMethod,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      type: map['type'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      totalAmount: map['totalAmount'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      customerName: map['customerName'],
      paymentMethod: map['paymentMethod'],
    );
  }
}