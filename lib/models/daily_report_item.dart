class DailyReportItem {
  String id;
  String date;
  String day;
  String weather;
  String workSummary;
  String issuesEncountered;
  String supervisorName;
  String photoUrl;

  DailyReportItem({
    required this.id,
    required this.date,
    required this.day,
    required this.weather,
    required this.workSummary,
    required this.issuesEncountered,
    required this.supervisorName,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'date': date, 'day': day, 'weather': weather,
    'workSummary': workSummary, 'issuesEncountered': issuesEncountered,
    'supervisorName': supervisorName, 'photoUrl': photoUrl,
  };

  factory DailyReportItem.fromJson(Map<String, dynamic> json) => DailyReportItem(
    id: json['id'], date: json['date'], day: json['day'],
    weather: json['weather'], workSummary: json['workSummary'],
    issuesEncountered: json['issuesEncountered'],
    supervisorName: json['supervisorName'], photoUrl: json['photoUrl'],
  );
}
