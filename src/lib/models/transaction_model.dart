class TransactionModel {
  final String? id;
  final String name;
  final double value;
  final int amount; // Quantidade de transações
  final String date; // ISO8601

  TransactionModel({
    this.id,
    required this.name,
    required this.value,
    this.amount = 1,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id != null ? int.tryParse(id!) : null,
      'name': name,
      'value': value,
      'amount': amount,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      value: (map['value'] is num) ? (map['value'] as num).toDouble() : 0.0,
      amount: (map['amount'] is int) ? map['amount'] as int : 1,
      date: map['date'] ?? '',
    );
  }

  TransactionModel copyWith({
    String? id,
    String? name,
    double? value,
    int? amount,
    String? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  static TransactionModel normalize(TransactionModel t) {
    // Nome limpo
    final name = t.name.trim();
    // Valor como double, aceitando vírgula ou ponto
    final value =
        double.tryParse(t.value.toString().replaceAll(',', '.')) ?? 0.0;
    // Quantidade como int
    final amount = int.tryParse(t.amount.toString()) ?? 1;
    // Data em ISO 8601
    String dateIso;
    try {
      dateIso = DateTime.parse(t.date).toIso8601String();
    } catch (_) {
      dateIso = DateTime.now().toIso8601String();
    }
    return TransactionModel(
      id: t.id,
      name: name,
      value: value,
      amount: amount,
      date: dateIso,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, name: $name, value: $value, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final TransactionModel otherTransaction = other as TransactionModel;
    return id == otherTransaction.id &&
        name == otherTransaction.name &&
        value == otherTransaction.value &&
        date == otherTransaction.date;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ value.hashCode ^ date.hashCode;
  }
}
