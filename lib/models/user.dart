class User {
  final String id;
  String name;
  String email;
  final String password;
  String role; // admin, project_manager, site_engineer, viewer
  final bool isDeactivated;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.isDeactivated = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'isDeactivated': isDeactivated,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    isDeactivated: json['isDeactivated'] ?? false,
  );
}
