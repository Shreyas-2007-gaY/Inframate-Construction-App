class Role {
  final String id; // e.g. "admin", "mentor", "executive_admin", "project_manager_engineer", "viewer_1", etc.
  String name;
  String description;
  Set<String> permissions;
  bool isCustom;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    this.isCustom = false,
  });

  bool hasPermission(String permissionKey) {
    return permissions.contains(permissionKey);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'permissions': permissions.toList(),
        'isCustom': isCustom,
      };

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? '',
        permissions: Set<String>.from(json['permissions'] ?? []),
        isCustom: json['isCustom'] ?? false,
      );
}
