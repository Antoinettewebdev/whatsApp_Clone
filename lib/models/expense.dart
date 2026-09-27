/// Represents a single expense stored in the local database.
class Expense {
  const Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
  });

  /// Database primary key (null when creating a new expense).
  final int? id;
  final String name;
  final double amount;
  final DateTime date;
  final String category;

  /// All categories supported by the app.
  static const List<String> categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Other',
  ];

  /// Converts a database row (Map) into an [Expense] object.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      name: map['name'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
    );
  }

  /// Converts this expense into a Map for database insert/update.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  /// Creates a copy with optional field overrides (useful when editing).
  Expense copyWith({
    int? id,
    String? name,
    double? amount,
    DateTime? date,
    String? category,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }
}
