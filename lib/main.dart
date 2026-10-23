import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'firebase_options.dart';
import 'auth/auth_service.dart';
import 'auth/auth_wrapper.dart';
import 'models/user.dart';
import 'models/activity.dart';
import 'models/sub_activity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }
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
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7700),
          primary: const Color(0xFF14213D),
          secondary: const Color(0xFFFF7700),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 2,
          centerTitle: false,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F9FC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7700), width: 1.5),
          ),
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF14213D),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 1,
          space: 24,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
      ),
      home: const AuthWrapper(),
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'photoUrl': photoUrl,
    'uploadDate': uploadDate,
  };

  factory DocPhotoItem.fromJson(Map<String, dynamic> json) => DocPhotoItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    category: json['category'] ?? 'Site Photos',
    photoUrl: json['photoUrl'] ?? '',
    uploadDate: json['uploadDate'] ?? '',
  );
}

class SavedPdfReport {
  final String id;
  final String title;
  final String date;
  final String time;
  final int sizeBytes;
  final Uint8List? pdfBytes;
  final String totalCost;

  SavedPdfReport({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.sizeBytes,
    this.pdfBytes,
    required this.totalCost,
  });
}

// ------------------- MAIN SCREEN STATE -------------------

class MainConstructionScreen extends StatefulWidget {
  final fb_auth.User? firebaseUser;
  final String? initialUserName;
  final String? initialUserEmail;
  final String? initialUserRole;

  const MainConstructionScreen({
    super.key,
    this.firebaseUser,
    this.initialUserName,
    this.initialUserEmail,
    this.initialUserRole,
  });

  @override
  State<MainConstructionScreen> createState() => _MainConstructionScreenState();
}

class _MainConstructionScreenState extends State<MainConstructionScreen> {
  final List<User> _users = [
    User(id: 'u-1', name: 'Admin', email: 'admin@inframate.com', password: 'admin123', role: 'admin', avatarAsset: 'assets/images/active_profile_avatar.png'),
    User(id: 'u-2', name: 'Mentor', email: 'mentor@inframate.com', password: 'mentor123', role: 'mentor'),
    User(id: 'u-3', name: 'Executive Admin', email: 'executive.admin@inframate.com', password: 'exec123', role: 'executive_admin'),
    User(id: 'u-4', name: 'Project Manager & Engineer', email: 'pm.engineer@inframate.com', password: 'pmeng123', role: 'project_manager_engineer'),
    User(id: 'u-5', name: 'Viewer 1', email: 'viewer1@inframate.com', password: 'view123', role: 'viewer_1'),
    User(id: 'u-6', name: 'Viewer 2', email: 'viewer2@inframate.com', password: 'view123', role: 'viewer_2'),
    User(id: 'u-7', name: 'Viewer 3', email: 'viewer3@inframate.com', password: 'view123', role: 'viewer_3'),
    User(id: 'u-8', name: 'Viewer 4', email: 'viewer4@inframate.com', password: 'view123', role: 'viewer_4'),
  ];

  late User _currentUser;
  int _bottomNavIndex = 0;
  String _activeTab = 'ACTIVITIES';
  String _selectedFilter = 'ALL';
  String _projectName = 'Skyline Residency';
  String _projectLocation = 'Pune, Maharashtra';
  final List<SavedPdfReport> _savedReports = [];

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

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialUserName != null && widget.initialUserName!.trim().isNotEmpty) {
      _currentUser = User(
        id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        name: widget.initialUserName!.trim(),
        email: widget.initialUserEmail ?? 'admin@inframate.com',
        password: '',
        role: (widget.initialUserRole ?? 'admin').toLowerCase().replaceAll(' ', '_'),
        avatarAsset: 'assets/images/active_profile_avatar.png',
      );
    } else if (widget.firebaseUser != null) {
      final fb = widget.firebaseUser!;
      final name = (fb.displayName != null && fb.displayName!.trim().isNotEmpty)
          ? fb.displayName!.trim()
          : (fb.email?.split('@').first ?? 'Admin');
      _currentUser = User(
        id: fb.uid,
        name: name,
        email: fb.email ?? 'admin@inframate.com',
        password: '',
        role: 'admin',
        avatarAsset: 'assets/images/active_profile_avatar.png',
      );
    } else {
      _currentUser = _users[0];
    }
    _loadSavedProjectDetails();
    _loadSavedDocsPhotos();
  }

  Future<void> _loadSavedDocsPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDocsJson = prefs.getString('inframate_saved_docs_photos');
      if (savedDocsJson != null && savedDocsJson.isNotEmpty) {
        final List decoded = jsonDecode(savedDocsJson);
        final loaded = decoded.map((e) => DocPhotoItem.fromJson(Map<String, dynamic>.from(e))).toList();
        if (mounted && loaded.isNotEmpty) {
          setState(() {
            _docsPhotos.clear();
            _docsPhotos.addAll(loaded);
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading saved docs photos: $e');
    }
  }

  Future<void> _saveDocsPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final docsJson = jsonEncode(_docsPhotos.map((d) => d.toJson()).toList());
      await prefs.setString('inframate_saved_docs_photos', docsJson);
    } catch (e) {
      debugPrint('Error saving docs photos: $e');
    }
  }

  Future<void> _loadSavedProjectDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('inframate_project_name');
      final savedLoc = prefs.getString('inframate_project_location');
      if (mounted) {
        setState(() {
          if (savedName != null && savedName.trim().isNotEmpty) {
            _projectName = savedName.trim();
          }
          if (savedLoc != null && savedLoc.trim().isNotEmpty) {
            _projectLocation = savedLoc.trim();
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading project details: $e');
    }
  }

  Future<void> _saveProjectName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('inframate_project_name', name);
    } catch (e) {
      debugPrint('Error saving project name: $e');
    }
  }

  Future<void> _saveProjectLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('inframate_project_location', location);
    } catch (e) {
      debugPrint('Error saving project location: $e');
    }
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

  // ------------------- ACTIVE PROFILE AVATAR -------------------

  Widget _buildActiveProfileAvatar({double size = 40}) {
    return GestureDetector(
      onTap: _showUserSwitchDialog,
      child: _buildUserAvatar(_currentUser, size: size, showBorder: true),
    );
  }

  Widget _buildUserAvatar(User user, {double size = 40, bool showBorder = true, bool isSelected = false}) {
    final assetPath = (user.avatarAsset != null && user.avatarAsset!.isNotEmpty)
        ? user.avatarAsset!
        : 'assets/images/active_profile_avatar.png';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: const Color(0xFFC8956C), width: 1.6)
            : null,
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: const Color(0xFFC8956C).withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(user, size, isSelected),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(User user, double size, [bool isSelected = false]) {
    String initials = '';
    final parts = user.name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    } else {
      initials = 'U';
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFFC8956C), Color(0xFFDEB887)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFC8956C), Color(0xFFB8860B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ------------------- USER SWITCH DIALOG -------------------

  void _showUserSwitchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8956C).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.switch_account_rounded, color: Color(0xFFC8956C), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Switch Active Profile',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
                          ),
                          Text(
                            'Select user profile to manage project',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF141414)),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: _users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final u = _users[index];
                    final isSelected = _currentUser.id == u.id;

                    return InkWell(
                      onTap: () {
                        setState(() => _currentUser = u);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Switched active profile to: ${u.name}'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFF14213D),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFDFBF7) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFC8956C) : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: const Color(0xFFC8956C).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 3))]
                              : null,
                        ),
                        child: Row(
                          children: [
                            _buildUserAvatar(u, size: 44, showBorder: isSelected, isSelected: isSelected),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Text(
                                        u.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isSelected ? const Color(0xFF141414) : const Color(0xFF2C2C2C),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFFC8956C).withOpacity(0.15)
                                              : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          u.role.replaceAll('_', ' ').toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected ? const Color(0xFFC8956C) : Colors.grey.shade600,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    u.email,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC8956C),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                              ),
                          ],
                        ),
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

  // ------------------- PDF REPORT GENERATOR & STORAGE -------------------
  Future<Uint8List> _generatePdfBytes({Activity? activity}) async {
    final pdf = pw.Document();
    final isSingle = activity != null;
    final profActivities = isSingle ? [activity] : _activities.where((a) => a.type != 'PROCUREMENT').toList();
    final totalCostReport = profActivities.fold(0.0, (sum, a) => sum + a.totalCost);
    final dateStr = DateFormat('dd MMM yyyy').format(DateTime.now());
    final timeStr = DateFormat('hh:mm a').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('INFRAMATE CONSTRUCTION', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                    pw.Text('PROJECT MANAGEMENT & SITE REPORT', style: pw.TextStyle(fontSize: 9, color: PdfColors.orange800, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 4),
                    pw.Text('Location: $_projectLocation | Date: $dateStr, $timeStr', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(color: PdfColors.blueGrey900, borderRadius: pw.BorderRadius.circular(4)),
                  child: pw.Text('OFFICIAL REPORT', style: pw.TextStyle(color: PdfColors.white, fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            pw.Divider(thickness: 1.5, color: PdfColors.orange800),
            pw.SizedBox(height: 12),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('REPORT: ${isSingle ? activity.title.toUpperCase() : "COMPLETE PROJECT ACTIVITIES"}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                      pw.Text('Generated by: ${_currentUser.name} (${_currentUser.role.replaceAll("_", " ").toUpperCase()})', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('TOTAL WORK COST', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                      pw.Text(formatRupee(totalCostReport), style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text('ACTIVITIES & WORK BREAKDOWN', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
            pw.SizedBox(height: 8),
            ...profActivities.map((act) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(act.title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text(formatRupee(act.totalCost), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Assigned to: ${act.assignedTo} | Duration: ${act.durationDays} Days | Dates: ${act.startDate} to ${act.dueDate} | Status: ${act.status.toUpperCase()}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  if (act.notes.isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text('Notes: ${act.notes}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  ],
                  if (act.subActivities.isNotEmpty) ...[
                    pw.SizedBox(height: 6),
                    pw.Text('Sub-Activities (${act.subActivities.length}):', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                    ...act.subActivities.map((sub) => pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 8, top: 2),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('- ${sub.title} (${sub.assignedTo})', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                          pw.Text(formatRupee(sub.directCost), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800)),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            )),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(width: 120, height: 1, color: PdfColors.grey500),
                    pw.SizedBox(height: 4),
                    pw.Text('Project Engineer Signature', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(width: 120, height: 1, color: PdfColors.grey500),
                    pw.SizedBox(height: 4),
                    pw.Text('Auditor Verification', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  void _savePdfReportToApp(String title, Uint8List bytes, double totalCost) {
    final now = DateTime.now();
    final dateStr = DateFormat('dd MMM yyyy').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);

    final report = SavedPdfReport(
      id: 'rep-${now.millisecondsSinceEpoch}',
      title: title,
      date: dateStr,
      time: timeStr,
      sizeBytes: bytes.length,
      pdfBytes: bytes,
      totalCost: formatRupee(totalCost),
    );

    setState(() {
      _savedReports.insert(0, report);
      _docsPhotos.insert(0, DocPhotoItem(
        id: report.id,
        title: '$title ($dateStr)',
        category: 'Report PDF',
        photoUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=500',
        uploadDate: dateStr,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('"$title" saved in app!')),
          ],
        ),
        backgroundColor: const Color(0xFF14213D),
        action: SnackBarAction(
          label: 'View Reports',
          textColor: const Color(0xFFC8956C),
          onPressed: () => _showSavedReportsDialog(),
        ),
      ),
    );
  }

  Future<void> _sharePdfViaWhatsApp(String filename, Uint8List bytes) async {
    await Printing.sharePdf(
      bytes: bytes,
      filename: filename,
      subject: 'Inframate Construction Report',
      body: 'Here is the construction report from Inframate for $_projectLocation.',
    );
  }

  void _showSavedReportsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          height: MediaQuery.of(ctx).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFC8956C).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.folder_shared_rounded, color: Color(0xFFC8956C), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Saved PDF Reports', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF141414))),
                          Text('${_savedReports.length} reports stored in app', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(height: 24),
              if (_savedReports.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, size: 54, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text('No reports saved in app yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey)),
                        const SizedBox(height: 6),
                        const Text('Generate a report and tap "Save in App"', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _savedReports.length,
                    itemBuilder: (ctx, index) {
                      final r = _savedReports[index];
                      final sizeKb = (r.sizeBytes / 1024).toStringAsFixed(1);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBFBFA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                                  child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red.shade700, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(r.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF141414))),
                                      const SizedBox(height: 2),
                                      Text('${r.date}, ${r.time} • $sizeKb KB', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF141926), borderRadius: BorderRadius.circular(6)),
                                  child: Text(r.totalCost, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // WhatsApp Share button
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () async {
                                      if (r.pdfBytes != null) {
                                        await _sharePdfViaWhatsApp('${r.title.replaceAll(" ", "_")}.pdf', r.pdfBytes!);
                                      } else {
                                        final bytes = await _generatePdfBytes();
                                        await _sharePdfViaWhatsApp('${r.title.replaceAll(" ", "_")}.pdf', bytes);
                                      }
                                    },
                                    icon: const Icon(Icons.share_rounded, size: 16),
                                    label: const Text('Share via WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Preview / Print button
                                Container(
                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: const Icon(Icons.print_rounded, size: 20, color: Color(0xFF141414)),
                                    tooltip: 'Print / View',
                                    onPressed: () async {
                                      final bytes = r.pdfBytes ?? await _generatePdfBytes();
                                      await Printing.layoutPdf(onLayout: (format) async => bytes);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                // Delete button
                                Container(
                                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red.shade400),
                                    tooltip: 'Delete',
                                    onPressed: () {
                                      setState(() => _savedReports.remove(r));
                                      setModalState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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
          height: MediaQuery.of(context).size.height * 0.88,
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
                  Row(
                    children: [
                      if (_savedReports.isNotEmpty)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSavedReportsDialog();
                          },
                          icon: const Icon(Icons.folder_open_rounded, size: 16, color: Color(0xFFC8956C)),
                          label: Text('Saved (${_savedReports.length})', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                        ),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
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
              // Action Buttons Row: Save in App & Share via WhatsApp
              Row(
                children: [
                  // Button 1: Save in App
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFF141926), width: 1.5),
                      ),
                      onPressed: () async {
                        final bytes = await _generatePdfBytes(activity: activity);
                        _savePdfReportToApp(
                          isSingle ? '${activity?.title ?? "Activity"} Report' : 'Inframate Full Project Report',
                          bytes,
                          totalCostReport,
                        );
                      },
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18, color: Color(0xFF141926)),
                      label: const Text('Save in App', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF141926))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Button 2: Share via WhatsApp
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final bytes = await _generatePdfBytes(activity: activity);
                        final filename = isSingle ? '${(activity?.title ?? "Activity").replaceAll(" ", "_")}_Report.pdf' : 'Inframate_Project_Report.pdf';
                        // Auto-save in app as well
                        _savePdfReportToApp(
                          isSingle ? '${activity?.title ?? "Activity"} Report' : 'Inframate Full Project Report',
                          bytes,
                          totalCostReport,
                        );
                        await _sharePdfViaWhatsApp(filename, bytes);
                      },
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text('Share to WhatsApp', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Secondary Print / Layout Preview button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    final bytes = await _generatePdfBytes(activity: activity);
                    await Printing.layoutPdf(onLayout: (format) async => bytes);
                  },
                  icon: const Icon(Icons.print_outlined, size: 16, color: Colors.grey),
                  label: const Text('Print or Export PDF to Files', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                ),
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
      backgroundColor: const Color(0xFFF7F6F2),
      body: _bottomNavIndex == 0
          ? _buildHomeScreen()
          : _bottomNavIndex == 1
              ? _buildProjectsScreen()
              : _bottomNavIndex == 2
                  ? _buildUpdatesScreen()
                  : _buildProfileScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.business_rounded, Icons.business_outlined, 'Projects'),
                _buildNavItem(2, Icons.update_rounded, Icons.update_outlined, 'Updates'),
                _buildNavItem(3, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = _bottomNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _bottomNavIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFC8956C).withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : inactiveIcon, size: 24, color: isActive ? const Color(0xFFC8956C) : Colors.grey.shade400),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? const Color(0xFFC8956C) : Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }

  // ------------------- HOME SCREEN (BuildPro Reference Style) -------------------
  Widget _buildHomeScreen() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }
    final activeUserName = _currentUser.name.split(' ')[0];

    // Calculate progress
    final totalActs = _activities.length + _activities.fold(0, (sum, a) => sum + a.subActivities.length);
    final completedActs = _activities.where((a) => a.status == 'completed').length +
        _activities.fold(0, (sum, a) => sum + a.subActivities.where((s) => s.status == 'completed').length);
    final progressPercent = totalActs > 0 ? ((completedActs / totalActs) * 100).round() : 72;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Top Bar (Inframate style) ---
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFC8956C), width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.apartment_rounded, color: Color(0xFFC8956C), size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Inframate',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF141414),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF141414), size: 20),
                            onPressed: () => _showPdfReportModal(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildActiveProfileAvatar(),
                      ],
                    ),
                  ],
                ),
              ),

              // --- Hero Section (Text on Left, Beautiful Architecture on Right) ---
              SizedBox(
                height: 350,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Right architectural building image (fades seamlessly)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: MediaQuery.of(context).size.width * 0.64,
                      child: Image.asset(
                        'assets/images/hero_building.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topRight,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/skyscraper.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topRight,
                        ),
                      ),
                    ),

                    // Left Hero Content
                    Positioned(
                      left: 20,
                      top: 16,
                      bottom: 16,
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$greeting,', style: const TextStyle(fontSize: 13, color: Color(0xFF8E8E93), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(activeUserName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF141414))),
                              const SizedBox(width: 4),
                              const Text('👋', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 1.12,
                                fontFamily: 'Roboto',
                              ),
                              children: [
                                TextSpan(text: 'Build.\n', style: TextStyle(color: Color(0xFF141414))),
                                TextSpan(text: 'Manage.\n', style: TextStyle(color: Color(0xFF141414))),
                                TextSpan(text: 'Deliver.', style: TextStyle(color: Color(0xFFC8956C))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Manage your construction\nprojects in one place.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF71717A), height: 1.4, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => setState(() => _bottomNavIndex = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141926),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [BoxShadow(color: const Color(0xFF141926).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('View Projects', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFFC8956C)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // --- CURRENT PROJECT Card (BuildPro style with dark 72% badge) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFEFEFEF)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT PROJECT',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFC8956C), letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final controller = TextEditingController(text: _projectName);
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text('Edit Project Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        content: TextField(
                                          controller: controller,
                                          autofocus: true,
                                          decoration: const InputDecoration(
                                            hintText: 'e.g. Skyline Residency',
                                            prefixIcon: Icon(Icons.business_rounded, size: 18),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                          ElevatedButton(
                                            onPressed: () {
                                              final newName = controller.text.trim();
                                              if (newName.isNotEmpty) {
                                                setState(() => _projectName = newName);
                                                _saveProjectName(newName);
                                              }
                                              Navigator.pop(ctx);
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _projectName,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.edit_rounded, size: 14, color: Color(0xFFC8956C)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF8E8E93)),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        final controller = TextEditingController(text: _projectLocation);
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            title: const Text('Edit Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                            content: TextField(
                                              controller: controller,
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                hintText: 'e.g. Pune, Maharashtra',
                                                prefixIcon: Icon(Icons.location_on_outlined, size: 18),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final newLoc = controller.text.trim();
                                                  if (newLoc.isNotEmpty) {
                                                    setState(() => _projectLocation = newLoc);
                                                    _saveProjectLocation(newLoc);
                                                  }
                                                  Navigator.pop(ctx);
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_projectLocation, style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93), fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit_rounded, size: 12, color: Color(0xFFC8956C)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Dark 72% Complete Badge
                          Container(
                            width: 68,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141926),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$progressPercent', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFFC8956C))),
                                    const Text('%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text('Complete', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Color(0xFF8E8E93))),
                                const SizedBox(height: 4),
                                const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFFC8956C)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Gold Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progressPercent / 100,
                          minHeight: 5,
                          backgroundColor: const Color(0xFFF0EDE6),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC8956C)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 13, color: Color(0xFFC8956C)),
                          const SizedBox(width: 6),
                          const Text('Expected completion: 28 Aug 2025', style: TextStyle(fontSize: 11, color: Color(0xFF71717A), fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(formatRupee(totalProjectCost), style: const TextStyle(fontSize: 11, color: Color(0xFF141414), fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // --- Quick Actions ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quick Actions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF141414))),
                    const SizedBox(height: 4),
                    Container(width: 22, height: 2.5, decoration: BoxDecoration(color: const Color(0xFFC8956C), borderRadius: BorderRadius.circular(2))),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildQuickAction(Icons.apartment_rounded, 'Projects', 'View and manage\nall projects', () => setState(() => _bottomNavIndex = 1)),
                    _buildQuickAction(Icons.architecture_rounded, 'Site Updates', 'Check real-time\nupdates from sites', () {
                      setState(() { _bottomNavIndex = 1; _activeTab = 'DAILY_REPORTS'; });
                    }),
                    _buildQuickAction(Icons.article_outlined, 'Documents', 'Access blueprints,\ncontracts & more', () {
                      setState(() { _bottomNavIndex = 1; _activeTab = 'DOCS'; });
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8956C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: const Color(0xFFC8956C)),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF14213D))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.4)),
              const SizedBox(height: 10),
              Icon(Icons.arrow_forward, size: 16, color: const Color(0xFFC8956C)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  // ------------------- PROJECTS SCREEN (clean & premium) -------------------
  Widget _buildProjectsScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFA),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar matching Home Screen style
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC8956C), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.apartment_rounded, color: Color(0xFFC8956C), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF141414),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFC8956C), size: 20),
                          onPressed: () => _showPdfReportModal(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildActiveProfileAvatar(),
                    ],
                  ),
                ],
              ),
            ),
            // Clean horizontal sub-tabs
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildTabChip('ACTIVITIES', 'Activities', Icons.assignment_rounded),
                  _buildTabChip('ATTENDANCE', 'Attendance', Icons.badge_rounded),
                  _buildTabChip('MATERIALS', 'Materials', Icons.inventory_2_rounded),
                  _buildTabChip('EQUIPMENTS', 'Equipments', Icons.precision_manufacturing_rounded),
                  _buildTabChip('DAILY_REPORTS', 'Daily Logs', Icons.rate_review_rounded),
                  _buildTabChip('EXPENSES', 'Expenses', Icons.account_balance_wallet_rounded),
                  _buildTabChip('SAFETY', 'Safety Logs', Icons.health_and_safety_rounded),
                  _buildTabChip('DOCS', 'Docs & Photos', Icons.photo_library_rounded),
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
      ),
    );
  }

  // ------------------- UPDATES SCREEN (clean & premium) -------------------
  Widget _buildUpdatesScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC8956C), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.architecture_rounded, color: Color(0xFFC8956C), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Site Updates',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF141414),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add_rounded, color: Color(0xFF141414), size: 22),
                          onPressed: () => _showAddEditDailyReportModal(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildActiveProfileAvatar(),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEBE8E1)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._dailyReports.map((report) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFC8956C).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                child: Text('${report.day}, ${report.date}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFFF7F6F2), borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  children: [
                                    const Icon(Icons.wb_sunny_outlined, size: 12, color: Color(0xFFC8956C)),
                                    const SizedBox(width: 4),
                                    Text(report.weather, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(report.workSummary, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: Color(0xFF141414), height: 1.5)),
                          if (report.issuesEncountered.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red.shade50.withOpacity(0.8), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.shade100)),
                              child: Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red.shade700),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(report.issuesEncountered, style: TextStyle(fontSize: 11, color: Colors.red.shade800, fontWeight: FontWeight.w500))),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Supervisor: ${report.supervisorName}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => _showAddEditDailyReportModal(report: report),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                      child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => setState(() => _dailyReports.remove(report)),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                                      child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    if (_dailyReports.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(Icons.update_rounded, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text('No site updates yet', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- PROFILE SCREEN (clean & premium) -------------------
  Widget _buildProfileScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Avatar with luxury warm bronze styling
              _buildUserAvatar(_currentUser, size: 84, showBorder: true),
              const SizedBox(height: 16),
              Text(
                _currentUser.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
              ),
              const SizedBox(height: 4),
              Text(_currentUser.email, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8956C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentUser.role.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFFC8956C), letterSpacing: 0.6),
                ),
              ),
              const SizedBox(height: 28),
              _buildProfileTile(Icons.switch_account_rounded, 'Switch Account', 'Change active user profile', _showUserSwitchDialog),
              _buildProfileTile(Icons.picture_as_pdf_rounded, 'Generate New Report', 'Create official project PDF report', () => _showPdfReportModal()),
              _buildProfileTile(Icons.folder_shared_rounded, 'Saved PDF Reports (${_savedReports.length})', 'View & share saved reports with WhatsApp', _showSavedReportsDialog),
              _buildProfileTile(Icons.info_outline_rounded, 'About Inframate', 'Version 2.0.0 • Clean & Premium Edition', () {}),
              const SizedBox(height: 6),
              _buildProfileTile(
                Icons.logout_rounded,
                'Sign Out',
                'Securely log out of your session',
                _confirmSignOut,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDestructive ? const Color(0xFFFEF2F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDestructive ? const Color(0xFFFECACA) : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isDestructive ? const Color(0xFFFEE2E2) : const Color(0xFFC8956C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFFC8956C)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDestructive ? const Color(0xFFDC2626) : const Color(0xFF141414),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isDestructive ? const Color(0xFFEF4444) : Colors.grey.shade500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDestructive ? const Color(0xFFDC2626) : Colors.grey.shade400,
          size: 20,
        ),
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF14213D)),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to sign out of Inframate? You will be returned to the login portal.',
            style: TextStyle(fontSize: 13.5, color: Color(0xFF4B5563), height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await AuthService.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabChip(String tabKey, String label, IconData icon) {
    final isSelected = _activeTab == tabKey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: InkWell(
        onTap: () => setState(() => _activeTab = tabKey),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC8956C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFC8956C) : Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: const Color(0xFFC8956C).withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: isSelected ? Colors.white : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF141414),
                ),
              ),
            ],
          ),
        ),
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

  // ------------------- ACTIVITIES VIEW (clean & premium) -------------------

  Widget _buildActivitiesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Clean Project Header ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8956C).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.apartment_rounded, color: Color(0xFFC8956C), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_projectName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF141414))),
                        const SizedBox(height: 2),
                        Text(_projectLocation.toUpperCase(), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.8)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // --- Cost Summary Grid (clean, minimal) ---
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = 'ALL'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'ALL' ? const Color(0xFFFDFBF7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFilter == 'ALL' ? const Color(0xFFC8956C) : Colors.grey.shade200,
                            width: _selectedFilter == 'ALL' ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TOTAL PROJECT COST', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            Text(formatRupee(totalProjectCost), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF141414))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedFilter = 'PROFESSIONAL WORK'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'PROFESSIONAL WORK' ? const Color(0xFFFDFBF7) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFilter == 'PROFESSIONAL WORK' ? const Color(0xFFC8956C) : Colors.grey.shade200,
                            width: _selectedFilter == 'PROFESSIONAL WORK' ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PROFESSIONAL WORK', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            Text(formatRupee(professionalWorkCost), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFFC8956C))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => setState(() => _selectedFilter = 'PROCUREMENT'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _selectedFilter == 'PROCUREMENT' ? const Color(0xFFFDFBF7) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedFilter == 'PROCUREMENT' ? const Color(0xFFC8956C) : Colors.grey.shade200,
                      width: _selectedFilter == 'PROCUREMENT' ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROCUREMENT COST', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      Text(formatRupee(procurementCost), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF7B1FA2))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // --- Clean Add Buttons (luxury buttons) ---
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF141926),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() => _selectedFilter = 'PROFESSIONAL WORK');
                  _showAddEditActivityModal(isProcurement: false);
                },
                icon: const Icon(Icons.construction_rounded, size: 16, color: Color(0xFFC8956C)),
                label: const Text('+ Professional Work', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF141414),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFC8956C), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() => _selectedFilter = 'PROCUREMENT');
                  _showAddEditActivityModal(isProcurement: true);
                },
                icon: const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFFC8956C)),
                label: const Text('+ Procurement', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // --- Activity Cards (clean, minimal) ---
        if (filteredActivities.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
            child: Column(
              children: [
                Icon(Icons.construction_outlined, size: 40, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No activities yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade400)),
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
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: null,
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: isProc ? const Color(0xFF7B1FA2).withOpacity(0.1) : const Color(0xFFC8956C).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isProc ? '📦 PROCUREMENT' : '⛑️ PROFESSIONAL WORK',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: isProc ? const Color(0xFF7B1FA2) : const Color(0xFFC8956C),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            act.title,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF141414)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey.shade400),
                      onPressed: () => setState(() => _activities.remove(act)),
                    ),
                    children: [
                      // Cost row
                      _buildCleanField(Icons.currency_rupee, '${formatRupee(act.totalCost)} (sum of sub-activities)'),
                      _buildCleanField(Icons.schedule_rounded, '${act.durationDays} Days  •  ${act.startDate} → ${act.dueDate}'),
                      _buildCleanField(Icons.person_outline_rounded, act.assignedTo),
                      _buildCleanField(Icons.sticky_note_2_outlined, act.notes.isNotEmpty ? act.notes : 'No notes'),
                      const SizedBox(height: 6),
                      // Edit button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _showAddEditActivityModal(isProcurement: isProc, activity: act),
                          icon: const Icon(Icons.edit_rounded, size: 14, color: Color(0xFFC8956C)),
                          label: const Text('Edit Activity', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFC8956C))),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: Colors.grey.shade200),
                      const SizedBox(height: 12),
                      // Sub-activities header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SUB-ACTIVITIES (${act.subActivities.length})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.5)),
                          InkWell(
                            onTap: () => _showAddEditSubActivityModal(parentActivity: act),
                            child: const Text('+ Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...act.subActivities.map((sub) => Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(sub.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF141414)))),
                                Text(formatRupee(sub.directCost), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF141414))),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => _showAddEditSubActivityModal(parentActivity: act, subActivity: sub),
                                  child: Icon(Icons.edit_rounded, size: 16, color: Colors.grey.shade500),
                                ),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () => setState(() => act.subActivities.remove(sub)),
                                  child: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('${sub.assignedTo}  •  ${sub.durationDays} Days  •  ${sub.startDate} → ${sub.dueDate}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  /// Clean minimal field row — matches reference image style
  Widget _buildCleanField(IconData icon, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  // ------------------- OTHER MODULE VIEWS (clean & premium) -------------------

  Widget _buildBadge(String text, {Color? color, Color? bg}) {
    final c = color ?? const Color(0xFF141414);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFF7F6F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: c),
      ),
    );
  }

  Widget _buildAttendanceView() {
    final totalWorkers = _attendanceLogs.fold(0, (sum, a) => sum + a.totalWorkers);
    final totalLaborCost = _attendanceLogs.fold(0.0, (sum, a) => sum + a.totalWages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daily Site Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddEditAttendanceModal(),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Log Attendance', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _buildSummaryBox('TOTAL WORKERS ON SITE', totalWorkers.toString(), const Color(0xFF141414))),
            const SizedBox(width: 10),
            Expanded(child: _buildSummaryBox('EST. DAILY WAGES', formatRupee(totalLaborCost), const Color(0xFF2E7D32))),
          ],
        ),
        const SizedBox(height: 16),
        ..._attendanceLogs.map((log) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFC8956C).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text(log.date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF4F3EF), borderRadius: BorderRadius.circular(8)),
                        child: Text(log.shift, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF141414))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(formatRupee(log.totalWages), style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2E7D32), fontSize: 14)),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _showAddEditAttendanceModal(record: log),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _attendanceLogs.remove(log)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildBadge('👷 ${log.laborersCount} Laborers'),
                  _buildBadge('🧱 ${log.masonsCount} Masons'),
                  _buildBadge('📐 ${log.engineersCount} Engineers'),
                  if (log.overtimeHours > 0)
                    _buildBadge('⏱️ ${log.overtimeHours}h OT', color: const Color(0xFFC8956C)),
                ],
              ),
              if (log.notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(log.notes, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ],
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
            const Text(
              'Material Procurement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddEditMaterialModal(),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Add Material', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildSummaryBox('TOTAL MATERIAL COST', formatRupee(totalMaterialCost), const Color(0xFF7B1FA2)),
        const SizedBox(height: 16),
        ..._materials.map((mat) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF7B1FA2), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mat.materialName,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF141414)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mat.quantity} ${mat.unit} • Supplier: ${mat.supplier}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: mat.status == 'Delivered' ? Colors.green.shade50 : const Color(0xFFF7F6F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        mat.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: mat.status == 'Delivered' ? Colors.green.shade700 : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupee(mat.totalCost),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF7B1FA2), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _showAddEditMaterialModal(material: mat),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _materials.remove(mat)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
            const Text(
              'Fleet & Equipments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddEditEquipmentModal(),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Add Equipment', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._equipments.map((eq) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8956C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.precision_manufacturing_rounded, color: Color(0xFFC8956C), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eq.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF141414)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Operator: ${eq.operatorName} • Status: ${eq.status}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${eq.hourlyRate.toInt()}/hr • ${eq.hoursUsedToday} hrs logged today',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupee(eq.dailyCost),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF141414), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _showAddEditEquipmentModal(equipment: eq),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _equipments.remove(eq)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
            const Text(
              'Daily Site Logs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddEditDailyReportModal(),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Add Daily Log', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._dailyReports.map((rep) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFC8956C).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                        child: Text('${rep.day}, ${rep.date}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFC8956C))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF7F6F2), borderRadius: BorderRadius.circular(8)),
                        child: Text(rep.weather, style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showAddEditDailyReportModal(report: rep),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _dailyReports.remove(rep)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                rep.workSummary,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF141414), height: 1.4),
              ),
              if (rep.issuesEncountered.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.red.shade50.withOpacity(0.8), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade100)),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 15, color: Colors.red.shade700),
                      const SizedBox(width: 6),
                      Expanded(child: Text(rep.issuesEncountered, style: TextStyle(fontSize: 11, color: Colors.red.shade800, fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text('Supervisor: ${rep.supervisorName}', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
            ],
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
            const Text(
              'Site Expenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showAddEditExpenseModal(),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Add Expense', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildSummaryBox('TOTAL MISCELLANEOUS EXPENSES', formatRupee(totalExpenses), const Color(0xFF00897B)),
        const SizedBox(height: 16),
        ..._expenses.map((exp) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: Color(0xFF00897B), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.category,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF141414)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Spent By: ${exp.spentBy} • ${exp.paymentMethod}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 2),
                    Text('${exp.date} • ${exp.notes}', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupee(exp.amount),
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF00897B), fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => _showAddEditExpenseModal(expense: exp),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                          child: const Icon(Icons.edit_outlined, size: 14, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => setState(() => _expenses.remove(exp)),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
            const Text(
              'Safety Audits',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Log Audit', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._safetyLogs.map((saf) {
          final isPassed = saf.status == 'Passed';
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPassed ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
                    color: isPassed ? Colors.green.shade700 : Colors.red.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        saf.auditTopic,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF141414)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Inspector: ${saf.inspectorName} • ${saf.date}',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${saf.incidentCount} incidents reported',
                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        saf.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isPassed ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => setState(() => _safetyLogs.remove(saf)),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ------------------- DOCS & PHOTOS (Camera & Gallery) -------------------

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC8956C).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_a_photo_rounded, color: Color(0xFFC8956C), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Upload Site Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF141414))),
                            SizedBox(height: 2),
                            Text('Take a picture or choose from gallery', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF141414)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Camera Option
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(ImageSource.camera);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFC8956C), Color(0xFFDEB887)]),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Take Photo with Camera', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF141414))),
                              const SizedBox(height: 3),
                              Text('Capture real-time site progress directly', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Gallery Option
                InkWell(
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(ImageSource.gallery);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141926),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.photo_library_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Choose from Gallery', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF141414))),
                              const SizedBox(height: 3),
                              Text('Select existing photo, receipt, or blueprint', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (file == null) return;
      if (!mounted) return;
      _showPhotoDetailsDialog(file);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not access image: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800,
        ),
      );
    }
  }

  void _showPhotoDetailsDialog(XFile file) {
    final titleController = TextEditingController(text: 'Site Photo ${DateFormat('dd MMM HH:mm').format(DateTime.now())}');
    String selectedCategory = 'Site Photo';
    final categories = ['Site Photo', 'Blueprint', 'Material Receipt', 'Inspection', 'Safety', 'Progress'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8956C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_rounded, color: Color(0xFFC8956C), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Photo Details', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF141414))),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(file.path),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Photo / Doc Title',
                    hintText: 'e.g. Slab casting check',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedCategory = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC8956C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final title = titleController.text.trim().isNotEmpty
                    ? titleController.text.trim()
                    : 'Site Photo';
                final newDoc = DocPhotoItem(
                  id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  category: selectedCategory,
                  photoUrl: file.path,
                  uploadDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
                setState(() {
                  _docsPhotos.insert(0, newDoc);
                });
                _saveDocsPhotos();
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo uploaded successfully!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFF14213D),
                  ),
                );
              },
              child: const Text('Save Photo', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoViewModal(DocPhotoItem doc) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF141414))),
                    Text('${doc.category} • ${doc.uploadDate}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF141414)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.55,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: InteractiveViewer(
                    child: doc.photoUrl.startsWith('http')
                        ? Image.network(
                            doc.photoUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey.shade100,
                              child: const Center(child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey)),
                            ),
                          )
                        : Image.file(
                            File(doc.photoUrl),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: Colors.grey.shade100,
                              child: const Center(child: Icon(Icons.broken_image_rounded, size: 48, color: Colors.grey)),
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8956C).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doc.category.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFC8956C)),
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                      onPressed: () {
                        setState(() {
                          _docsPhotos.remove(doc);
                        });
                        _saveDocsPhotos();
                        Navigator.pop(ctx);
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 16),
                      label: const Text('Delete Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocsPhotosView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Docs & Photos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF141414)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141926),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_a_photo_rounded, size: 16, color: Color(0xFFC8956C)),
              label: const Text('Upload Photo', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red.shade700, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saved PDF Reports', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Color(0xFF141414))),
                    const SizedBox(height: 2),
                    Text('${_savedReports.length} reports stored in app', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF141926),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _showSavedReportsDialog,
                icon: const Icon(Icons.folder_open_rounded, size: 14, color: Color(0xFFC8956C)),
                label: const Text('View All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
        if (_docsPhotos.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            child: Column(
              children: [
                Icon(Icons.photo_library_outlined, size: 48, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No photos uploaded yet', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                const SizedBox(height: 6),
                Text('Tap "Upload Photo" to take a picture or choose from gallery', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _docsPhotos.length,
            itemBuilder: (context, index) {
              final doc = _docsPhotos[index];
              return InkWell(
                onTap: () => _showPhotoViewModal(doc),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: doc.photoUrl.startsWith('http')
                              ? Image.network(
                                  doc.photoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF14213D),
                                    child: const Center(child: Icon(Icons.broken_image_rounded, color: Color(0xFFC8956C), size: 40)),
                                  ),
                                )
                              : Image.file(
                                  File(doc.photoUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF14213D),
                                    child: const Center(child: Icon(Icons.broken_image_rounded, color: Color(0xFFC8956C), size: 40)),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF141414)),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    doc.category,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() => _docsPhotos.remove(doc));
                                    _saveDocsPhotos();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                                    child: Icon(Icons.delete_outline_rounded, size: 12, color: Colors.red.shade400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.6)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: color)),
        ],
      ),
    );
  }
}
