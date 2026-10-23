class EquipmentItem {
  String id;
  String name;
  String operatorName;
  String status;
  double hourlyRate;
  double hoursUsedToday;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.operatorName,
    required this.status,
    required this.hourlyRate,
    required this.hoursUsedToday,
  });

  double get dailyCost => hourlyRate * hoursUsedToday;

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'operatorName': operatorName,
    'status': status, 'hourlyRate': hourlyRate, 'hoursUsedToday': hoursUsedToday,
  };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
    id: json['id'], name: json['name'], operatorName: json['operatorName'],
    status: json['status'], hourlyRate: (json['hourlyRate'] as num).toDouble(),
    hoursUsedToday: (json['hoursUsedToday'] as num).toDouble(),
  );
}
