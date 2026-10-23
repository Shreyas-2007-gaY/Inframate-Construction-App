class ExpenseRecord {
  String id;
  String category;
  double amount;
  String paymentMethod;
  String spentBy;
  String date;
  String notes;

  ExpenseRecord({
    required this.id,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.spentBy,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'category': category, 'amount': amount,
    'paymentMethod': paymentMethod, 'spentBy': spentBy,
    'date': date, 'notes': notes,
  };

  factory ExpenseRecord.fromJson(Map<String, dynamic> json) => ExpenseRecord(
    id: json['id'], category: json['category'],
    amount: (json['amount'] as num).toDouble(),
    paymentMethod: json['paymentMethod'], spentBy: json['spentBy'],
    date: json['date'], notes: json['notes'],
  );
}
