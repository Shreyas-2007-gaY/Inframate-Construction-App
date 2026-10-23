class AttendanceRecord {
  String id;
  String date;
  int laborersCount;
  int masonsCount;
  int engineersCount;
  double overtimeHours;
  double dailyWageRate;
  String shift;
  String notes;

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.laborersCount,
    required this.masonsCount,
    required this.engineersCount,
    required this.overtimeHours,
    required this.dailyWageRate,
    required this.shift,
    required this.notes,
  });

  int get totalWorkers => laborersCount + masonsCount + engineersCount;
  double get totalWages => (totalWorkers * dailyWageRate) + (overtimeHours * (dailyWageRate / 8) * 1.5);

  Map<String, dynamic> toJson() => {
    'id': id, 'date': date, 'laborersCount': laborersCount,
    'masonsCount': masonsCount, 'engineersCount': engineersCount,
    'overtimeHours': overtimeHours, 'dailyWageRate': dailyWageRate,
    'shift': shift, 'notes': notes,
  };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => AttendanceRecord(
    id: json['id'], date: json['date'],
    laborersCount: json['laborersCount'], masonsCount: json['masonsCount'],
    engineersCount: json['engineersCount'], overtimeHours: (json['overtimeHours'] as num).toDouble(),
    dailyWageRate: (json['dailyWageRate'] as num).toDouble(),
    shift: json['shift'], notes: json['notes'],
  );
}
