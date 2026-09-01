class SubActivity {
  String id;
  String parentId;
  String title;
  double directCost;
  int durationDays;
  String assignedTo;
  String notes;
  String status;
  String createdDate;
  String lastUpdatedDate;
  String startDate;
  String dueDate;

  SubActivity({
    required this.id,
    required this.parentId,
    required this.title,
    required this.directCost,
    required this.durationDays,
    required this.assignedTo,
    required this.notes,
    required this.status,
    required this.createdDate,
    required this.lastUpdatedDate,
    required this.startDate,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'title': title,
    'directCost': directCost,
    'durationDays': durationDays,
    'assignedTo': assignedTo,
    'notes': notes,
    'status': status,
    'createdDate': createdDate,
    'lastUpdatedDate': lastUpdatedDate,
    'startDate': startDate,
    'dueDate': dueDate,
  };

  factory SubActivity.fromJson(Map<String, dynamic> json) => SubActivity(
    id: json['id'],
    parentId: json['parentId'],
    title: json['title'],
    directCost: (json['directCost'] as num).toDouble(),
    durationDays: json['durationDays'],
    assignedTo: json['assignedTo'],
    notes: json['notes'],
    status: json['status'],
    createdDate: json['createdDate'],
    lastUpdatedDate: json['lastUpdatedDate'],
    startDate: json['startDate'],
    dueDate: json['dueDate'],
  );
}
