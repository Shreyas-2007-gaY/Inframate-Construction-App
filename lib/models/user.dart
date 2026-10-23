class User {
  final String id;
  String name;
  String email;
  final String password;
  String role; // admin, project_manager, site_engineer, viewer
  final bool isDeactivated;
  final String? avatarAsset;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.isDeactivated = false,
    this.avatarAsset,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'isDeactivated': isDeactivated,
    'avatarAsset': avatarAsset,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    isDeactivated: json['isDeactivated'] ?? false,
    avatarAsset: json['avatarAsset'],
  );
}
