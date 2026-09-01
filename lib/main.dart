import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/user.dart';
import 'models/activity.dart';
import 'models/sub_activity.dart';

void main() {
  runApp(const InframateApp());
}

class InframateApp extends StatelessWidget {
  const InframateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inframate — Construction Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF9F8F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7700),
          primary: const Color(0xFF14213D),
          secondary: const Color(0xFFFF7700),
        ),
      ),
      home: const MainConstructionScreen(),
    );
  }
}

// ------------------- DATA MODELS -------------------

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
}

class MaterialItem {
  String id;
  String materialName;
  double quantity;
  String unit;
  String supplier;
  double totalCost;
  String status;

  MaterialItem({
    required this.id,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.supplier,
    required this.totalCost,
    required this.status,
  });
}

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
}

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
}

class ExpenseRecord {
  String id;
  String category;
  double amount;
  String paymentMethod;
  String spentBy;
  String date;
  String notes;

  ExpenseRecord({
    required this.id,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.spentBy,
    required this.date,
    required this.notes,
  });
}

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
}

class DocPhotoItem {
  String id;
  String title;
  String category;
  String photoUrl;
  String uploadDate;

  DocPhotoItem({
    required this.id,
    required this.title,
    required this.category,
    required this.photoUrl,
    required this.uploadDate,
  });
}

// ------------------- MAIN SCREEN STATE -------------------

class MainConstructionScreen extends StatefulWidget {
  const MainConstructionScreen({super.key});

  @override
  State<MainConstructionScreen> createState() => _MainConstructionScreenState();
}

class _MainConstructionScreenState extends State<MainConstructionScreen> {
  final List<User> _users = [
    User(id: 'u-1', name: 'Admin User', email: 'admin@inframate.com', password: 'admin123', role: 'admin'),
    User(id: 'u-2', name: 'Mentor', email: 'mentor@inframate.com', password: 'mentor123', role: 'mentor'),
    User(id: 'u-3', name: 'Executive Admin', email: 'executive.admin@inframate.com', password: 'exec123', role: 'executive_admin'),
    User(id: 'u-4', name: 'Project Manager & Engineer', email: 'pm.engineer@inframate.com', password: 'pmeng123', role: 'project_manager_engineer'),
    User(id: 'u-5', name: 'Viewer 1', email: 'viewer1@inframate.com', password: 'view123', role: 'viewer_1'),
    User(id: 'u-6', name: 'Viewer 2', email: 'viewer2@inframate.com', password: 'view123', role: 'viewer_2'),
    User(id: 'u-7', name: 'Viewer 3', email: 'viewer3@inframate.com', password: 'view123', role: 'viewer_3'),
    User(id: 'u-8', name: 'Viewer 4', email: 'viewer4@inframate.com', password: 'view123', role: 'viewer_4'),
  ];

  late User _currentUser;
  String _activeTab = 'ACTIVITIES';
  String _selectedFilter = 'ALL';

  final List<Activity> _activities = [
    Activity(
      id: 'act-1',
      title: 'Site Preparation & Excavation',
      type: 'PROFESSIONAL WORK',
      directCost: 0,
      durationDays: 15,
      assignedTo: 'Project Manager & Engineer',
      notes: 'Initial site preparation and excavation activity.',
      status: 'in_progress',
      createdDate: '2026-07-01T10:00:00.000Z',
      lastUpdatedDate: '2026-07-24T10:00:00.000Z',
      startDate: '2026-07-01',
      dueDate: '2026-07-15',
      subActivities: [
        SubActivity(
          id: 'sub-1-1',
          parentId: 'act-1',
          title: 'Land Survey & Soil Testing',
          directCost: 0,
          durationDays: 5,
          assignedTo: 'Project Manager & Engineer',
          notes: 'Soil test and site survey.',
          status: 'completed',
          createdDate: '2026-07-01T10:05:00.000Z',
          lastUpdatedDate: '2026-07-05T11:00:00.000Z',
          startDate: '2026-07-01',
          dueDate: '2026-07-05',
        ),
      ],
    ),
  ];

  final List<AttendanceRecord> _attendanceLogs = [
    AttendanceRecord(
      id: 'att-1',
      date: '2026-07-24',
      laborersCount: 18,
      masonsCount: 6,
      engineersCount: 2,
      overtimeHours: 4.0,
      dailyWageRate: 850,
      shift: 'Day Shift',
      notes: 'Excavation and column shuttering shift.',
    ),
  ];

  final List<MaterialItem> _materials = [
    MaterialItem(
      id: 'mat-1',
      materialName: 'TMT Reinforcement Steel 20mm',
      quantity: 15.0,
      unit: 'Tons',
      supplier: 'Tata Tiscon Dealer',
      totalCost: 850000,
      status: 'Delivered',
    ),
  ];

  final List<EquipmentItem> _equipments = [
    EquipmentItem(
      id: 'eq-1',
      name: 'JCB 3DX Heavy Excavator',
      operatorName: 'Ramesh Kumar',
      status: 'Active',
      hourlyRate: 1500,
      hoursUsedToday: 7.5,
    ),
  ];

  final List<DailyReportItem> _dailyReports = [
    DailyReportItem(
      id: 'rep-1',
      date: '2026-07-24',
      day: 'Friday',
      weather: 'Sunny (32°C)',
      workSummary: 'Column shuttering completed for Grid A1-A4. Soil compaction test verified.',
      issuesEncountered: 'Minor delay due to cement transit truck traffic.',
      supervisorName: 'Project Manager & Engineer',
      photoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b2?w=500',
    ),
  ];

  final List<ExpenseRecord> _expenses = [
    ExpenseRecord(
      id: 'exp-1',
      category: 'Diesel Fuel for Generator',
      amount: 14500,
      paymentMethod: 'UPI',
      spentBy: 'Project Manager & Engineer',
      date: '2026-07-24',
      notes: 'Fuel tank refilled 150L.',
    ),
  ];

  final List<SafetyLogItem> _safetyLogs = [
    SafetyLogItem(
      id: 'saf-1',
      date: '2026-07-24',
      auditTopic: 'Toolbox Talk: Safety Harness & Helmet Check',
      incidentCount: 0,
      inspectorName: 'Mentor',
      status: 'Passed',
    ),
  ];

  final List<DocPhotoItem> _docsPhotos = [
    DocPhotoItem(
      id: 'doc-1',
      title: 'Ground Floor Structural Blueprint',
      category: 'Blueprint',
      photoUrl: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=500',
      uploadDate: '2026-07-24',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentUser = _users[0];
  }

  String formatRupee(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(amount);
  }

  double get totalProjectCost => _activities.fold(0.0, (sum, a) => sum + a.totalCost) +
      _materials.fold(0.0, (sum, m) => sum + m.totalCost) +
      _expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get professionalWorkCost => _activities.where((a) => a.type != 'PROCUREMENT').fold(0.0, (sum, a) => sum + a.totalCost);
  double get procurementCost => _activities.where((a) => a.type == 'PROCUREMENT').fold(0.0, (sum, a) => sum + a.totalCost) + _materials.fold(0.0, (sum, m) => sum + m.totalCost);

  List<Activity> get filteredActivities {
    if (_selectedFilter == 'PROFESSIONAL WORK') {
      return _activities.where((a) => a.type != 'PROCUREMENT').toList();
    } else if (_selectedFilter == 'PROCUREMENT') {
      return _activities.where((a) => a.type == 'PROCUREMENT').toList();
    }
    return _activities;
  }

  // ------------------- USER SWITCH DIALOG -------------------

  void _showUserSwitchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.switch_account, color: Color(0xFFFF7700), size: 24),
                      SizedBox(width: 10),
                      Text('Switch Active User Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final u = _users[index];
                    final isSelected = _currentUser.id == u.id;

                    return Card(
                      elevation: isSelected ? 2 : 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: isSelected ? const Color(0xFFFF7700) : Colors.grey.shade200, width: isSelected ? 2 : 1),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? const Color(0xFFFF7700) : Colors.grey.shade300,
                          child: Icon(Icons.person, color: isSelected ? Colors.white : Colors.black54, size: 20),
                        ),
                        title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('${u.role.replaceAll('_', ' ').toUpperCase()} | ${u.email}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFFF7700), size: 20) : null,
                        onTap: () {
                          setState(() => _currentUser = u);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Switched user session to: ${u.name}')));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------- MODALS -------------------

  void _showDashboardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF14213D), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.dashboard_customize, color: Color(0xFFFF7700), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Inframate Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Project Overview & Management', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF14213D), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL PROJECT COST', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(formatRupee(totalProjectCost), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('PROFESSIONAL WORK', style: TextStyle(color: Color(0xFFFF7700), fontSize: 9, fontWeight: FontWeight.bold)),
                          Text(formatRupee(professionalWorkCost), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ])),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('PROCUREMENT', style: TextStyle(color: Colors.purpleAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                          Text(formatRupee(procurementCost), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ])),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.pop(context);
                    _showPdfReportModal();
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('Generate Professional Work PDF Report', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAddEditDailyReportModal({DailyReportItem? report}) {
    final dateController = TextEditingController(text: report?.date ?? DateTime.now().toString().split(' ')[0]);
    final dayController = TextEditingController(text: report?.day ?? DateFormat('EEEE').format(DateTime.now()));
    final summaryController = TextEditingController(text: report?.workSummary ?? '');
    final weatherController = TextEditingController(text: report?.weather ?? 'Sunny (32°C)');
    final issuesController = TextEditingController(text: report?.issuesEncountered ?? '');

    Future<void> selectDate(BuildContext ctx) async {
      final DateTime? picked = await showDatePicker(
        context: ctx,
        initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
        firstDate: DateTime(2025),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        dayController.text = DateFormat('EEEE').format(picked);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(report == null ? '📝 Add Daily Site Progress Log' : '✏️ Edit Daily Log (Date & Day)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text('📅 Editable Date & Day of Week:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF14213D))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context);
                          setModalState(() {});
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: dateController,
                            decoration: const InputDecoration(labelText: 'Log Date 📅', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: dayController,
                        decoration: const InputDecoration(labelText: 'Day (e.g. Friday / Day 14)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.today)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  children: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((d) => ActionChip(
                    label: Text(d, style: const TextStyle(fontSize: 9)),
                    onPressed: () {
                      setModalState(() => dayController.text = d);
                    },
                  )).toList(),
                ),
                const SizedBox(height: 12),
                TextField(controller: weatherController, decoration: const InputDecoration(labelText: 'Weather Conditions', border: OutlineInputBorder(), prefixIcon: Icon(Icons.wb_sunny))),
                const SizedBox(height: 10),
                TextField(controller: summaryController, maxLines: 3, decoration: const InputDecoration(labelText: 'Work Done Summary', border: OutlineInputBorder(), prefixIcon: Icon(Icons.rate_review))),
                const SizedBox(height: 10),
                TextField(controller: issuesController, maxLines: 2, decoration: const InputDecoration(labelText: 'Site Issues / Delays (if any)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.warning))),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      setState(() {
                        if (report == null) {
                          _dailyReports.insert(0, DailyReportItem(
                            id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
                            date: dateController.text,
                            day: dayController.text,
                            weather: weatherController.text,
                            workSummary: summaryController.text,
                            issuesEncountered: issuesController.text,
                            supervisorName: _currentUser.name,
                            photoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b2?w=500',
                          ));
                        } else {
                          report.date = dateController.text;
                          report.day = dayController.text;
                          report.weather = weatherController.text;
                          report.workSummary = summaryController.text;
                          report.issuesEncountered = issuesController.text;
                        }
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Daily Log saved successfully!'), backgroundColor: Colors.green));
                    },
                    child: const Text('Save Daily Log Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEditActivityModal({required bool isProcurement, Activity? activity}) {
    final titleController = TextEditingController(text: activity?.title ?? '');
    final durationController = TextEditingController(text: (activity?.durationDays ?? 15).toString());
    final assignedToController = TextEditingController(text: activity?.assignedTo ?? 'Project Manager & Engineer');
    final startDateController = TextEditingController(text: activity?.startDate ?? DateTime.now().toString().split(' ')[0]);
    final dueDateController = TextEditingController(text: activity?.dueDate ?? DateTime.now().add(const Duration(days: 15)).toString().split(' ')[0]);
    final costController = TextEditingController(text: (activity?.directCost ?? 0).toString());
    final notesController = TextEditingController(text: activity?.notes ?? '');

    Future<void> selectDate(BuildContext ctx, TextEditingController targetCtrl) async {
      final DateTime? picked = await showDatePicker(
        context: ctx,
        initialDate: DateTime.tryParse(targetCtrl.text) ?? DateTime.now(),
        firstDate: DateTime(2025),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        targetCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(activity == null ? (isProcurement ? '📦 Add Procurement Order' : '⛑️ Add Professional Work') : '✏️ Edit Activity Details', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: isProcurement ? 'Procurement Item Title' : 'Professional Work Title', border: const OutlineInputBorder(), prefixIcon: Icon(isProcurement ? Icons.inventory_2 : Icons.construction)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Duration (Days)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.timer)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 4,
                      children: [10, 15, 30, 45].map((days) => ChoiceChip(
                        label: Text('${days}d', style: const TextStyle(fontSize: 10)),
                        selected: durationController.text == days.toString(),
                        onSelected: (val) {
                          setModalState(() => durationController.text = days.toString());
                        },
                      )).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: assignedToController,
                  decoration: const InputDecoration(labelText: 'Assigner / Supervisor Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  children: ['Project Manager & Engineer', 'Site Engineer', 'Civil Engineer', 'Supervisor', 'Mentor'].map((role) => ActionChip(
                    label: Text(role, style: const TextStyle(fontSize: 9)),
                    onPressed: () {
                      setModalState(() => assignedToController.text = role);
                    },
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context, startDateController);
                          setModalState(() {});
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: startDateController,
                            decoration: const InputDecoration(labelText: 'Start Date 📅', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context, dueDateController);
                          setModalState(() {});
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: dueDateController,
                            decoration: const InputDecoration(labelText: 'Due Date 📅', border: OutlineInputBorder(), prefixIcon: Icon(Icons.event)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Direct Cost (₹)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.currency_rupee)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notes / Specifications', border: OutlineInputBorder(), prefixIcon: Icon(Icons.notes)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      final now = DateTime.now().toIso8601String();
                      setState(() {
                        if (activity == null) {
                          _activities.insert(0, Activity(
                            id: 'act-${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim().isNotEmpty ? titleController.text.trim() : (isProcurement ? 'Steel & Cement Supply Order' : 'Site Preparation & Excavation'),
                            type: isProcurement ? 'PROCUREMENT' : 'PROFESSIONAL WORK',
                            directCost: double.tryParse(costController.text) ?? 0,
                            durationDays: int.tryParse(durationController.text) ?? 15,
                            assignedTo: assignedToController.text.trim().isNotEmpty ? assignedToController.text.trim() : 'Project Manager & Engineer',
                            notes: notesController.text,
                            status: 'in_progress',
                            createdDate: now,
                            lastUpdatedDate: now,
                            startDate: startDateController.text,
                            dueDate: dueDateController.text,
                            subActivities: [],
                          ));
                        } else {
                          activity.title = titleController.text.trim().isNotEmpty ? titleController.text.trim() : activity.title;
                          activity.durationDays = int.tryParse(durationController.text) ?? 15;
                          activity.assignedTo = assignedToController.text.trim().isNotEmpty ? assignedToController.text.trim() : 'Project Manager & Engineer';
                          activity.startDate = startDateController.text;
                          activity.dueDate = dueDateController.text;
                          activity.directCost = double.tryParse(costController.text) ?? 0;
                          activity.notes = notesController.text;
                          activity.lastUpdatedDate = now;
                        }
                        _selectedFilter = isProcurement ? 'PROCUREMENT' : 'PROFESSIONAL WORK';
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isProcurement ? 'Procurement order saved!' : 'Professional Work activity saved!'), backgroundColor: Colors.green));
                    },
                    child: Text(isProcurement ? 'Save Procurement Order' : 'Save Professional Work', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEditSubActivityModal({required Activity parentActivity, SubActivity? subActivity}) {
    final titleController = TextEditingController(text: subActivity?.title ?? '');
    final durationController = TextEditingController(text: (subActivity?.durationDays ?? 5).toString());
    final assignedToController = TextEditingController(text: subActivity?.assignedTo ?? parentActivity.assignedTo);
    final startDateController = TextEditingController(text: subActivity?.startDate ?? parentActivity.startDate);
    final dueDateController = TextEditingController(text: subActivity?.dueDate ?? parentActivity.dueDate);
    final costController = TextEditingController(text: (subActivity?.directCost ?? 0).toString());
    final notesController = TextEditingController(text: subActivity?.notes ?? '');

    Future<void> selectDate(BuildContext ctx, TextEditingController targetCtrl) async {
      final DateTime? picked = await showDatePicker(
        context: ctx,
        initialDate: DateTime.tryParse(targetCtrl.text) ?? DateTime.now(),
        firstDate: DateTime(2025),
        lastDate: DateTime(2030),
      );
      if (picked != null) {
        targetCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subActivity == null ? '↳ Add Sub-Activity' : '✏️ Edit Sub-Activity Details', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Sub-Activity Title', border: OutlineInputBorder(), prefixIcon: Icon(Icons.subdirectory_arrow_right)),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Duration (Days)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.timer)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: assignedToController,
                        decoration: const InputDecoration(labelText: 'Assigned Engineer', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context, startDateController);
                          setModalState(() {});
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: startDateController,
                            decoration: const InputDecoration(labelText: 'Start Date 📅', border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context, dueDateController);
                          setModalState(() {});
                        },
                        child: IgnorePointer(
                          child: TextField(
                            controller: dueDateController,
                            decoration: const InputDecoration(labelText: 'Due Date 📅', border: OutlineInputBorder(), prefixIcon: Icon(Icons.event)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Direct Cost (₹)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.currency_rupee)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder(), prefixIcon: Icon(Icons.notes)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      final now = DateTime.now().toIso8601String();
                      setState(() {
                        if (subActivity == null) {
                          parentActivity.subActivities.add(SubActivity(
                            id: 'sub-${DateTime.now().millisecondsSinceEpoch}',
                            parentId: parentActivity.id,
                            title: titleController.text,
                            directCost: double.tryParse(costController.text) ?? 0,
                            durationDays: int.tryParse(durationController.text) ?? 5,
                            assignedTo: assignedToController.text.trim().isNotEmpty ? assignedToController.text.trim() : parentActivity.assignedTo,
                            notes: notesController.text,
                            status: 'in_progress',
                            createdDate: now,
                            lastUpdatedDate: now,
                            startDate: startDateController.text,
                            dueDate: dueDateController.text,
                          ));
                        } else {
                          subActivity.title = titleController.text;
                          subActivity.durationDays = int.tryParse(durationController.text) ?? 5;
                          subActivity.assignedTo = assignedToController.text.trim().isNotEmpty ? assignedToController.text.trim() : parentActivity.assignedTo;
                          subActivity.startDate = startDateController.text;
                          subActivity.dueDate = dueDateController.text;
                          subActivity.directCost = double.tryParse(costController.text) ?? 0;
                          subActivity.notes = notesController.text;
                          subActivity.lastUpdatedDate = now;
                        }
                        parentActivity.lastUpdatedDate = now;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sub-activity saved!'), backgroundColor: Colors.green));
                    },
                    child: const Text('Save Sub-Activity Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEditAttendanceModal({AttendanceRecord? record}) {
    final dateController = TextEditingController(text: record?.date ?? DateTime.now().toString().split(' ')[0]);
    final laborersController = TextEditingController(text: (record?.laborersCount ?? 15).toString());
    final masonsController = TextEditingController(text: (record?.masonsCount ?? 5).toString());
    final engineersController = TextEditingController(text: (record?.engineersCount ?? 2).toString());
    final wageRateController = TextEditingController(text: (record?.dailyWageRate ?? 850).toString());
    final notesController = TextEditingController(text: record?.notes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(record == null ? '📋 Add Daily Attendance Log' : '✏️ Edit Attendance Record', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: laborersController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Laborers', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: masonsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Masons', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: engineersController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Engineers', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: wageRateController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Avg Daily Wage Rate (₹)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: notesController, maxLines: 2, decoration: const InputDecoration(labelText: 'Shift Notes', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    if (record == null) {
                      _attendanceLogs.insert(0, AttendanceRecord(
                        id: 'att-${DateTime.now().millisecondsSinceEpoch}',
                        date: dateController.text,
                        laborersCount: int.tryParse(laborersController.text) ?? 0,
                        masonsCount: int.tryParse(masonsController.text) ?? 0,
                        engineersCount: int.tryParse(engineersController.text) ?? 0,
                        overtimeHours: 0,
                        dailyWageRate: double.tryParse(wageRateController.text) ?? 800,
                        shift: 'Day Shift',
                        notes: notesController.text,
                      ));
                    } else {
                      record.date = dateController.text;
                      record.laborersCount = int.tryParse(laborersController.text) ?? 0;
                      record.masonsCount = int.tryParse(masonsController.text) ?? 0;
                      record.engineersCount = int.tryParse(engineersController.text) ?? 0;
                      record.dailyWageRate = double.tryParse(wageRateController.text) ?? 800;
                      record.notes = notesController.text;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Attendance Record', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditMaterialModal({MaterialItem? material}) {
    final nameController = TextEditingController(text: material?.materialName ?? '');
    final qtyController = TextEditingController(text: (material?.quantity ?? 10).toString());
    final unitController = TextEditingController(text: material?.unit ?? 'Bags');
    final supplierController = TextEditingController(text: material?.supplier ?? '');
    final costController = TextEditingController(text: (material?.totalCost ?? 0).toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(material == null ? '📦 Add Material Procurement' : '✏️ Edit Material Order', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Material Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit (Tons, Bags...)', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: supplierController, decoration: const InputDecoration(labelText: 'Supplier Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: costController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Cost (₹)', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    if (material == null) {
                      _materials.insert(0, MaterialItem(
                        id: 'mat-${DateTime.now().millisecondsSinceEpoch}',
                        materialName: nameController.text,
                        quantity: double.tryParse(qtyController.text) ?? 1,
                        unit: unitController.text,
                        supplier: supplierController.text,
                        totalCost: double.tryParse(costController.text) ?? 0,
                        status: 'Ordered',
                      ));
                    } else {
                      material.materialName = nameController.text;
                      material.quantity = double.tryParse(qtyController.text) ?? 1;
                      material.unit = unitController.text;
                      material.supplier = supplierController.text;
                      material.totalCost = double.tryParse(costController.text) ?? 0;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Material Record', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditEquipmentModal({EquipmentItem? equipment}) {
    final nameController = TextEditingController(text: equipment?.name ?? '');
    final opController = TextEditingController(text: equipment?.operatorName ?? '');
    final rateController = TextEditingController(text: (equipment?.hourlyRate ?? 1500).toString());
    final hoursController = TextEditingController(text: (equipment?.hoursUsedToday ?? 8).toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(equipment == null ? '🚜 Add Equipment Fleet' : '✏️ Edit Equipment Record', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Equipment Name (JCB, Crane...)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: opController, decoration: const InputDecoration(labelText: 'Operator Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: rateController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Hourly Rate (₹)', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: hoursController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Hours Used Today', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    if (equipment == null) {
                      _equipments.insert(0, EquipmentItem(
                        id: 'eq-${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text,
                        operatorName: opController.text,
                        status: 'Active',
                        hourlyRate: double.tryParse(rateController.text) ?? 1000,
                        hoursUsedToday: double.tryParse(hoursController.text) ?? 8,
                      ));
                    } else {
                      equipment.name = nameController.text;
                      equipment.operatorName = opController.text;
                      equipment.hourlyRate = double.tryParse(rateController.text) ?? 1000;
                      equipment.hoursUsedToday = double.tryParse(hoursController.text) ?? 8;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Equipment Record', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditExpenseModal({ExpenseRecord? expense}) {
    final catController = TextEditingController(text: expense?.category ?? '');
    final amountController = TextEditingController(text: (expense?.amount ?? 0).toString());
    final notesController = TextEditingController(text: expense?.notes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense == null ? '💳 Add Site Expense' : '✏️ Edit Expense Record', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(controller: catController, decoration: const InputDecoration(labelText: 'Expense Category (Fuel, Food, Tools...)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: notesController, maxLines: 2, decoration: const InputDecoration(labelText: 'Payment Notes', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  setState(() {
                    if (expense == null) {
                      _expenses.insert(0, ExpenseRecord(
                        id: 'exp-${DateTime.now().millisecondsSinceEpoch}',
                        category: catController.text,
                        amount: double.tryParse(amountController.text) ?? 0,
                        paymentMethod: 'UPI / Cash',
                        spentBy: _currentUser.name,
                        date: DateTime.now().toString().split(' ')[0],
                        notes: notesController.text,
                      ));
                    } else {
                      expense.category = catController.text;
                      expense.amount = double.tryParse(amountController.text) ?? 0;
                      expense.notes = notesController.text;
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save Expense Entry', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- PDF REPORT GENERATOR -------------------
  void _showPdfReportModal({Activity? activity}) {
    final isSingle = activity != null;
    final profActivities = isSingle ? [activity] : _activities.where((a) => a.type != 'PROCUREMENT').toList();
    final totalCostReport = profActivities.fold(0.0, (sum, a) => sum + a.totalCost);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.picture_as_pdf, color: Colors.red.shade700, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isSingle ? 'Activity PDF Report' : 'Professional Work PDF Report', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Text('Official Document Format', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))], borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('INFRAMATE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF14213D))),
                                  const Text('CONSTRUCTION PROJECT MANAGEMENT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFFF7700))),
                                  Text('Date: ${DateTime.now().toString().split(' ')[0]}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFF14213D), borderRadius: BorderRadius.circular(6)),
                                child: const Text('OFFICIAL REPORT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1.5),
                          Text(isSingle ? 'PROFESSIONAL WORK ACTIVITY REPORT' : 'ALL PROFESSIONAL WORK SUMMARY REPORT', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF14213D))),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Work Cost:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                Text(formatRupee(totalCostReport), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF14213D))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...profActivities.map((act) => Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('⛑️ ${act.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                    Text(formatRupee(act.totalCost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Assigned To: ${act.assignedTo} | Duration: ${act.durationDays} Days | Dates: ${act.startDate} to ${act.dueDate}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 16), label: const Text('Close'))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF Report generated!'), backgroundColor: Colors.green));
                      },
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Save PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------- MAIN BUILD METHOD -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14213D),
        foregroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(color: const Color(0xFFFF7700), borderRadius: BorderRadius.circular(6)),
              child: const Icon(Icons.home, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text('Inframate', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'PDF Report',
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            onPressed: () => _showPdfReportModal(),
          ),
          IconButton(
            tooltip: 'Switch User Profile',
            icon: const Icon(Icons.account_circle),
            onPressed: _showUserSwitchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF14213D),
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildTabChip('ACTIVITIES', '📊 Activities', Icons.assignment),
                _buildTabChip('ATTENDANCE', '📋 Attendance', Icons.badge),
                _buildTabChip('MATERIALS', '📦 Materials', Icons.inventory),
                _buildTabChip('EQUIPMENTS', '🚜 Equipments', Icons.precision_manufacturing),
                _buildTabChip('DAILY_REPORTS', '📝 Daily Logs', Icons.rate_review),
                _buildTabChip('EXPENSES', '💳 Expenses', Icons.account_balance_wallet),
                _buildTabChip('SAFETY', '🦺 Safety Logs', Icons.health_and_safety),
                _buildTabChip('DOCS', '📁 Docs & Photos', Icons.photo_library),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildActiveTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(String tabKey, String label, IconData icon) {
    final isSelected = _activeTab == tabKey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 14, color: isSelected ? Colors.white : Colors.grey.shade400),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade300,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFFFF7700),
        backgroundColor: const Color(0xFF1C2C4E),
        onSelected: (selected) {
          if (selected) {
            setState(() => _activeTab = tabKey);
          }
        },
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 'ATTENDANCE': return _buildAttendanceView();
      case 'MATERIALS': return _buildMaterialsView();
      case 'EQUIPMENTS': return _buildEquipmentsView();
      case 'DAILY_REPORTS': return _buildDailyReportsView();
      case 'EXPENSES': return _buildExpensesView();
      case 'SAFETY': return _buildSafetyLogsView();
      case 'DOCS': return _buildDocsPhotosView();
      case 'ACTIVITIES':
      default: return _buildActivitiesView();
    }
  }

  // ------------------- ACTIVITIES VIEW -------------------

  Widget _buildActivitiesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: _showDashboardModal,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(color: const Color(0xFF14213D), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.dashboard_customize, color: Color(0xFFFF7700), size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Inframate — Construction Project', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('CURRENT USER: ${_currentUser.name} (${_currentUser.role.replaceAll('_', ' ').toUpperCase()})', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFFFF7700))),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Generate All Professional PDF',
                    icon: const Icon(Icons.picture_as_pdf, size: 18, color: Colors.red),
                    onPressed: () => _showPdfReportModal(),
                  ),
                  IconButton(
                    tooltip: 'Switch Active User',
                    icon: const Icon(Icons.switch_account, size: 20, color: Color(0xFFFF7700)),
                    onPressed: _showUserSwitchDialog,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = 'ALL'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'ALL' ? const Color(0xFF14213D) : const Color(0xFFF9F8F6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _selectedFilter == 'ALL' ? const Color(0xFF14213D) : Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL COST', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _selectedFilter == 'ALL' ? Colors.white70 : Colors.grey)),
                            const SizedBox(height: 4),
                            Text(formatRupee(totalProjectCost), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: _selectedFilter == 'ALL' ? Colors.white : Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = 'PROFESSIONAL WORK'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'PROFESSIONAL WORK' ? Colors.blue.shade800 : const Color(0xFFF9F8F6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _selectedFilter == 'PROFESSIONAL WORK' ? Colors.blue.shade800 : Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PROFESSIONAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _selectedFilter == 'PROFESSIONAL WORK' ? Colors.white70 : Colors.blue.shade700)),
                            const SizedBox(height: 4),
                            Text(formatRupee(professionalWorkCost), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: _selectedFilter == 'PROFESSIONAL WORK' ? Colors.white : Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = 'PROCUREMENT'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'PROCUREMENT' ? Colors.purple.shade800 : const Color(0xFFF9F8F6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _selectedFilter == 'PROCUREMENT' ? Colors.purple.shade800 : Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PROCUREMENT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _selectedFilter == 'PROCUREMENT' ? Colors.white70 : Colors.purple.shade700)),
                            const SizedBox(height: 4),
                            Text(formatRupee(procurementCost), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: _selectedFilter == 'PROCUREMENT' ? Colors.white : Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('🌟 Show All', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                selected: _selectedFilter == 'ALL',
                selectedColor: const Color(0xFF14213D),
                labelStyle: TextStyle(color: _selectedFilter == 'ALL' ? Colors.white : Colors.black87),
                onSelected: (val) {
                  if (val) setState(() => _selectedFilter = 'ALL');
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('⛑️ Professional Only', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                selected: _selectedFilter == 'PROFESSIONAL WORK',
                selectedColor: Colors.blue.shade700,
                labelStyle: TextStyle(color: _selectedFilter == 'PROFESSIONAL WORK' ? Colors.white : Colors.blue.shade900),
                onSelected: (val) {
                  if (val) setState(() => _selectedFilter = 'PROFESSIONAL WORK');
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('📦 Procurement Only', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                selected: _selectedFilter == 'PROCUREMENT',
                selectedColor: Colors.purple.shade700,
                labelStyle: TextStyle(color: _selectedFilter == 'PROCUREMENT' ? Colors.white : Colors.purple.shade900),
                onSelected: (val) {
                  if (val) setState(() => _selectedFilter = 'PROCUREMENT');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() => _selectedFilter = 'PROFESSIONAL WORK');
                  _showAddEditActivityModal(isProcurement: false);
                },
                icon: const Icon(Icons.add_circle, size: 16),
                label: const Text('Add Professional Work', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() => _selectedFilter = 'PROCUREMENT');
                  _showAddEditActivityModal(isProcurement: true);
                },
                icon: const Icon(Icons.add_circle, size: 16),
                label: const Text('Add Procurement', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedFilter == 'PROFESSIONAL WORK'
                    ? 'Showing ONLY Professional Work Activities (${filteredActivities.length})'
                    : (_selectedFilter == 'PROCUREMENT'
                        ? 'Showing ONLY Procurement Orders (${filteredActivities.length})'
                        : 'Showing ALL Activities (${filteredActivities.length})'),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF14213D)),
              ),
              if (_selectedFilter != 'ALL')
                GestureDetector(
                  onTap: () => setState(() => _selectedFilter = 'ALL'),
                  child: const Text('Show All ✖', style: TextStyle(fontSize: 10, color: Color(0xFFFF7700), fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        if (filteredActivities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              children: [
                Icon(_selectedFilter == 'PROCUREMENT' ? Icons.inventory_2_outlined : Icons.construction_outlined, size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  _selectedFilter == 'PROCUREMENT'
                      ? 'No Procurement orders recorded yet.'
                      : 'No Professional Work activities recorded yet.',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
                  onPressed: () => _showAddEditActivityModal(isProcurement: _selectedFilter == 'PROCUREMENT'),
                  child: Text(_selectedFilter == 'PROCUREMENT' ? '+ Add Procurement Order' : '+ Add Professional Work'),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              final act = filteredActivities[index];
              final isProc = act.type == 'PROCUREMENT';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isProc ? Colors.purple.shade50 : Colors.blue.shade50,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        border: Border(left: BorderSide(color: isProc ? Colors.purple : Colors.blue, width: 4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: isProc ? Colors.purple.shade100 : Colors.blue.shade100, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  isProc ? '📦 PROCUREMENT' : '⛑️ PROFESSIONAL WORK',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isProc ? Colors.purple.shade900 : Colors.blue.shade900),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.picture_as_pdf, size: 20, color: Colors.red),
                                    onPressed: () => _showPdfReportModal(activity: act),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    tooltip: 'Edit Activity',
                                    icon: const Icon(Icons.edit, size: 20, color: Color(0xFFFF7700)),
                                    onPressed: () => _showAddEditActivityModal(isProcurement: isProc, activity: act),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    tooltip: 'Delete Activity',
                                    icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade400),
                                    onPressed: () => setState(() => _activities.remove(act)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            act.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF14213D)),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatRupee(act.totalCost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const Text('(sum of sub-activities)', style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _showAddEditActivityModal(isProcurement: isProc, activity: act),
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade100)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
                                                Text('DURATION', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                                                Icon(Icons.edit, size: 10, color: Color(0xFFFF7700)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text('🕒 ${act.durationDays} Days', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade100)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
                                                Text('ASSIGNER / SUPERVISOR', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                                                Icon(Icons.edit, size: 10, color: Color(0xFFFF7700)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text('👤 ${act.assignedTo}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.orange.shade100)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('📅 Start & Due Dates: ${act.startDate} to ${act.dueDate}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF14213D))),
                                      const Row(
                                        children: [
                                          Text('Tap to Edit ', style: TextStyle(fontSize: 9, color: Color(0xFFFF7700), fontWeight: FontWeight.bold)),
                                          Icon(Icons.edit, size: 12, color: Color(0xFFFF7700)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFF7700)),
                                foregroundColor: const Color(0xFFFF7700),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onPressed: () => _showAddEditActivityModal(isProcurement: isProc, activity: act),
                              icon: const Icon(Icons.edit_calendar, size: 14),
                              label: const Text('✏️ Edit Dates, Duration & Supervisor Name', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFF9F8F6), borderRadius: BorderRadius.circular(8)),
                            child: Text('📄 Notes: ${act.notes}', style: const TextStyle(fontSize: 11, color: Colors.black87)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SUB-ACTIVITIES (${act.subActivities.length})', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              TextButton(
                                onPressed: () => _showAddEditSubActivityModal(parentActivity: act),
                                child: const Text('+ Add Sub Activity', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...act.subActivities.map((sub) => Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('↳ ${sub.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                    Row(
                                      children: [
                                        Text(formatRupee(sub.directCost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: const Icon(Icons.edit, size: 14, color: Color(0xFFFF7700)),
                                          onPressed: () => _showAddEditSubActivityModal(parentActivity: act, subActivity: sub),
                                        ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          icon: Icon(Icons.delete_outline, size: 16, color: Colors.red.shade400),
                                          onPressed: () => setState(() => act.subActivities.remove(sub)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('👤 ${sub.assignedTo} | 🕒 ${sub.durationDays} Days | 📅 ${sub.startDate} to ${sub.dueDate}', style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ------------------- OTHER MODULE VIEWS -------------------

  Widget _buildAttendanceView() {
    final totalWorkers = _attendanceLogs.fold(0, (sum, a) => sum + a.totalWorkers);
    final totalLaborCost = _attendanceLogs.fold(0.0, (sum, a) => sum + a.totalWages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📋 Daily Site Attendance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () => _showAddEditAttendanceModal(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Log Attendance', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSummaryBox('TOTAL WORKERS ON SITE', totalWorkers.toString(), Colors.blue)),
            const SizedBox(width: 8),
            Expanded(child: _buildSummaryBox('EST. DAILY WAGES', formatRupee(totalLaborCost), Colors.green)),
          ],
        ),
        const SizedBox(height: 16),
        ..._attendanceLogs.map((log) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text('📅 Date: ${log.date} (${log.shift})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Workers: ${log.laborersCount} Laborers, ${log.masonsCount} Masons, ${log.engineersCount} Engineers\nNotes: ${log.notes}', style: const TextStyle(fontSize: 11)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRupee(log.totalWages), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 14), onPressed: () => _showAddEditAttendanceModal(record: log)),
                    IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.red), onPressed: () => setState(() => _attendanceLogs.remove(log))),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildMaterialsView() {
    final totalMaterialCost = _materials.fold(0.0, (sum, m) => sum + m.totalCost);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📦 Material Procurement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () => _showAddEditMaterialModal(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Material', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryBox('TOTAL MATERIAL COST', formatRupee(totalMaterialCost), Colors.purple),
        const SizedBox(height: 16),
        ..._materials.map((mat) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(mat.materialName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Qty: ${mat.quantity} ${mat.unit} | Supplier: ${mat.supplier}\nStatus: ${mat.status}', style: const TextStyle(fontSize: 11)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRupee(mat.totalCost), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 13)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 14), onPressed: () => _showAddEditMaterialModal(material: mat)),
                    IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.red), onPressed: () => setState(() => _materials.remove(mat))),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildEquipmentsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('🚜 Fleet & Equipment Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () => _showAddEditEquipmentModal(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Equipment', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._equipments.map((eq) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.orange.shade100, child: const Icon(Icons.precision_manufacturing, color: Color(0xFFFF7700))),
            title: Text(eq.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Operator: ${eq.operatorName} | Status: ${eq.status}\nRate: ₹${eq.hourlyRate}/hr (${eq.hoursUsedToday} hrs today)', style: const TextStyle(fontSize: 11)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRupee(eq.dailyCost), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 14), onPressed: () => _showAddEditEquipmentModal(equipment: eq)),
                    IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.red), onPressed: () => setState(() => _equipments.remove(eq))),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildDailyReportsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📝 Daily Site Progress Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () => _showAddEditDailyReportModal(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Daily Log', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._dailyReports.map((rep) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('📅 Date: ${rep.date} (${rep.day}) | 🌤️ ${rep.weather}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(tooltip: 'Edit Log Day & Date', icon: const Icon(Icons.edit, size: 18, color: Color(0xFFFF7700)), onPressed: () => _showAddEditDailyReportModal(report: rep)),
                        IconButton(tooltip: 'Delete Log', icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => setState(() => _dailyReports.remove(rep))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Supervisor: ${rep.supervisorName}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 6),
                Text('Summary: ${rep.workSummary}', style: const TextStyle(fontSize: 11)),
                if (rep.issuesEncountered.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('⚠️ Issues: ${rep.issuesEncountered}', style: const TextStyle(fontSize: 10, color: Colors.redAccent)),
                ],
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildExpensesView() {
    final totalExpenses = _expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('💳 Site Miscellaneous Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () => _showAddEditExpenseModal(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Expense', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryBox('TOTAL MISCELLANEOUS EXPENSES', formatRupee(totalExpenses), Colors.teal),
        const SizedBox(height: 16),
        ..._expenses.map((exp) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(exp.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Spent By: ${exp.spentBy} | Method: ${exp.paymentMethod}\nDate: ${exp.date} | Notes: ${exp.notes}', style: const TextStyle(fontSize: 11)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatRupee(exp.amount), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 14), onPressed: () => _showAddEditExpenseModal(expense: exp)),
                    IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.red), onPressed: () => setState(() => _expenses.remove(exp))),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSafetyLogsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('🦺 Site Safety Audits & Compliance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _safetyLogs.insert(0, SafetyLogItem(
                    id: 'saf-${DateTime.now().millisecondsSinceEpoch}',
                    date: DateTime.now().toString().split(' ')[0],
                    auditTopic: 'Routine Excavation PPE & Trench Safety Audit',
                    incidentCount: 0,
                    inspectorName: _currentUser.name,
                    status: 'Passed',
                  ));
                });
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Log Audit', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._safetyLogs.map((saf) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: saf.status == 'Passed' ? Colors.green.shade100 : Colors.red.shade100,
              child: Icon(saf.status == 'Passed' ? Icons.check_circle : Icons.warning, color: saf.status == 'Passed' ? Colors.green : Colors.red),
            ),
            title: Text(saf.auditTopic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('Inspector: ${saf.inspectorName} | Date: ${saf.date}\nIncidents Reported: ${saf.incidentCount}', style: const TextStyle(fontSize: 11)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(label: Text(saf.status), backgroundColor: saf.status == 'Passed' ? Colors.green.shade100 : Colors.red.shade100),
                IconButton(icon: const Icon(Icons.delete, size: 14, color: Colors.red), onPressed: () => setState(() => _safetyLogs.remove(saf))),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildDocsPhotosView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📁 Documents & Site Photos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14213D), foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _docsPhotos.insert(0, DocPhotoItem(
                    id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                    title: 'Column Reinforcement Inspection Photo',
                    category: 'Site Photo',
                    photoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b2?w=500',
                    uploadDate: DateTime.now().toString().split(' ')[0],
                  ));
                });
              },
              icon: const Icon(Icons.cloud_upload, size: 16),
              label: const Text('Upload Photo / Doc', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: _docsPhotos.length,
          itemBuilder: (context, index) {
            final doc = _docsPhotos[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Image.network(
                        doc.photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF14213D),
                          child: const Center(child: Icon(Icons.insert_drive_file, color: Color(0xFFFF7700), size: 40)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(doc.category, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete, size: 14, color: Colors.red),
                              onPressed: () => setState(() => _docsPhotos.remove(doc)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryBox(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ],
      ),
    );
  }
}
