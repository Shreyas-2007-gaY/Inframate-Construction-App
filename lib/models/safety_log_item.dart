class SafetyLogItem {
  String id;
  String date;
  String auditTopic;
  int incidentCount;
  String inspectorName;
  String status;

  SafetyLogItem({
    required this.id,
    required this.date,
    required this.auditTopic,
    required this.incidentCount,
    required this.inspectorName,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'date': date, 'auditTopic': auditTopic,
    'incidentCount': incidentCount, 'inspectorName': inspectorName, 'status': status,
  };

  factory SafetyLogItem.fromJson(Map<String, dynamic> json) => SafetyLogItem(
    id: json['id'], date: json['date'], auditTopic: json['auditTopic'],
    incidentCount: json['incidentCount'], inspectorName: json['inspectorName'],
    status: json['status'],
  );
}
