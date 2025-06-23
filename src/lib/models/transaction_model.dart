class TransactionModel {
  final String? id;
  final String name;
  final double value;
  final String date; // ISO8601 (recomendado)
  final String? category;
  final int userId;

  TransactionModel({
    this.id,
    required this.name,
    required this.value,
    required this.date,
    this.category,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id != null ? int.tryParse(id!) : null,
      'nome': name,
      'valor': value,
      'data': date,
      'categoria': category,
      'usuario_id': userId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString(),
      name: map['nome'] ?? '',
      value: (map['valor'] is num) ? (map['valor'] as num).toDouble() : 0.0,
      date: map['data'] ?? '',
      category: map['categoria'] as String?,
      userId: (map['usuario_id'] as int),
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, name: $name, value: $value, date: $date, category: $category, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final TransactionModel otherTransaction = other as TransactionModel;
    return id == otherTransaction.id &&
        name == otherTransaction.name &&
        value == otherTransaction.value &&
        date == otherTransaction.date &&
        category == otherTransaction.category &&
        userId == otherTransaction.userId;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        value.hashCode ^
        date.hashCode ^
        category.hashCode ^
        userId.hashCode;
  }
}
