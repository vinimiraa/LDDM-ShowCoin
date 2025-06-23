class LocalUserModel {
  final int id;
  final String name;
  final double spendingLimit; 
  final String? profilePictureUrl;

  LocalUserModel({
    required this.id,
    required this.name,
    required this.spendingLimit,
    this.profilePictureUrl,
  });

  factory LocalUserModel.defaultUser() {
    return LocalUserModel(
      id: 1, // ID padrão para o usuário
      name: 'Usuário',
      spendingLimit: 0.0,
      profilePictureUrl: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'spending_limit': spendingLimit,
      'profile_picture_url': profilePictureUrl,
    };
  }

  factory LocalUserModel.fromMap(Map<String, dynamic> map) {
    return LocalUserModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      spendingLimit: (map['spending_limit'] is num)
          ? (map['spending_limit'] as num).toDouble()
          : 0.0,
      profilePictureUrl: map['profile_picture_url'] as String?,
    );
  }

  @override
  String toString() {
    return 'LocalUserModel{id: $id, name: $name, spendingLimit: $spendingLimit, profilePictureUrl: $profilePictureUrl}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalUserModel &&
        other.id == id &&
        other.name == name &&
        other.spendingLimit == spendingLimit &&
        other.profilePictureUrl == profilePictureUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        spendingLimit.hashCode ^
        profilePictureUrl.hashCode;
  }
}