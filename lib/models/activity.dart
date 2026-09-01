import 'sub_activity.dart';

class Activity {
  String id;
  String title;
  String type; // PROFESSIONAL WORK or PROCUREMENT
  double directCost;
  int durationDays;
  String assignedTo;
  String notes;
  String status;
  String createdDate;
  String lastUpdatedDate;
  String startDate;
  String dueDate;
  List<SubActivity> subActivities;

  Activity({
    required this.id,
    required this.title,
    required this.type,
    required this.directCost,
    required this.durationDays,
    required this.assignedTo,
    required this.notes,
    required this.status,
    required this.createdDate,
    required this.lastUpdatedDate,
    required this.startDate,
    required this.dueDate,
    required this.subActivities,
  });

  // Calculate total cost (directCost + sum of sub-activities directCost)
  double get totalCost {
    double subSum = subActivities.fold(0.0, (sum, s) => sum + s.directCost);
    return directCost + subSum;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'directCost': directCost,
    'durationDays': durationDays,
    'assignedTo': assignedTo,
    'notes': notes,
    'status': status,
    'createdDate': createdDate,
    'lastUpdatedDate': lastUpdatedDate,
    'startDate': startDate,
    'dueDate': dueDate,
    'subActivities': subActivities.map((s) => s.toJson()).toList(),
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    directCost: (json['directCost'] as num).toDouble(),
    durationDays: json['durationDays'],
    assignedTo: json['assignedTo'],
    notes: json['notes'],
    status: json['status'],
    createdDate: json['createdDate'],
    lastUpdatedDate: json['lastUpdatedDate'],
    startDate: json['startDate'],
    dueDate: json['dueDate'],
    subActivities: (json['subActivities'] as List)
        .map((s) => SubActivity.fromJson(s))
        .toList(),
  );
}
