class LocalUser {
  final String id;
  final String name;
  final double spendingLimit; 
  final String? profilePictureUrl;

  LocalUser({
    required this.id,
    required this.name,
    required this.spendingLimit,
    this.profilePictureUrl,
  });

  factory LocalUser.defaultUser() {
    return LocalUser(
      id: '',
      name: 'Usuário',
      spendingLimit: 0.0,
      profilePictureUrl: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': int.tryParse(id),
      'nome': name,
      'limite_gastos': spendingLimit,
      'foto_de_perfil': profilePictureUrl,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      id: map['id']?.toString() ?? '',
      name: map['nome'] ?? '',
      spendingLimit: (map['limite_gastos'] is num)
          ? (map['limite_gastos'] as num).toDouble()
          : 0.0,
      profilePictureUrl: map['foto_de_perfil'] as String?,
    );
  }

  @override
  String toString() {
    return 'LocalUser{id: $id, name: $name, spendingLimit: $spendingLimit, profilePictureUrl: $profilePictureUrl}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocalUser &&
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