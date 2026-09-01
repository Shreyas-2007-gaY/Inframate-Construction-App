class AuditLog {
  final String id;
  final String action; // e.g. "ROLE_ASSIGNED", "PERMISSIONS_UPDATED", "CUSTOM_ROLE_CREATED"
  final String performedBy;
  final String targetUserOrRole;
  final String details;
  final String timestamp;

  AuditLog({
    required this.id,
    required this.action,
    required this.performedBy,
    required this.targetUserOrRole,
    required this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'action': action,
        'performedBy': performedBy,
        'targetUserOrRole': targetUserOrRole,
        'details': details,
        'timestamp': timestamp,
      };

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
        id: json['id'],
        action: json['action'],
        performedBy: json['performedBy'],
        targetUserOrRole: json['targetUserOrRole'],
        details: json['details'],
        timestamp: json['timestamp'],
      );
}
