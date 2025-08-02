class Debt {
  final int? id;
  final String personName;
  final String type; // 'owed_to_me' or 'i_owe'
  final double amount;
  final String? description;
  final DateTime date;
  final DateTime? dueDate;
  final bool isPaid;

  Debt({
    this.id,
    required this.personName,
    required this.type,
    required this.amount,
    this.description,
    required this.date,
    this.dueDate,
    required this.isPaid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personName': personName,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isPaid': isPaid ? 1 : 0,
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      personName: map['personName'],
      type: map['type'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isPaid: map['isPaid'] == 1,
    );
  }
}