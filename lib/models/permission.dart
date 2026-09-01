class PermissionKeys {
  // 1. Projects
  static const String viewProjects = 'view_projects';
  static const String createProject = 'create_project';
  static const String editProject = 'edit_project';
  static const String deleteProject = 'delete_project';

  // 2. Activities
  static const String viewActivities = 'view_activities';
  static const String addActivity = 'add_activity';
  static const String editActivity = 'edit_activity';
  static const String deleteActivity = 'delete_activity';
  static const String updateActivityStatus = 'update_activity_status';

  // 3. Attendance
  static const String viewAttendance = 'view_attendance';
  static const String addAttendance = 'add_attendance';
  static const String editAttendance = 'edit_attendance';
  static const String deleteAttendance = 'delete_attendance';

  // 4. Materials
  static const String viewMaterials = 'view_materials';
  static const String addMaterials = 'add_materials';
  static const String editMaterials = 'edit_materials';
  static const String deleteMaterials = 'delete_materials';
  static const String updateMaterialQuantity = 'update_material_quantity';

  // 5. Expenses / Budget
  static const String viewBudget = 'view_budget';
  static const String addExpense = 'add_expense';
  static const String editExpense = 'edit_expense';
  static const String deleteExpense = 'delete_expense';
  static const String approveExpense = 'approve_expense';

  // 6. Reports / PDF
  static const String viewReports = 'view_reports';
  static const String generateReports = 'generate_reports';
  static const String generatePdf = 'generate_pdf';
  static const String downloadPdf = 'download_pdf';

  // 7. Users
  static const String viewUsers = 'view_users';
  static const String addUsers = 'add_users';
  static const String editUsers = 'edit_users';
  static const String deleteUsers = 'delete_users';

  // 8. Roles & Security
  static const String viewRoles = 'view_roles';
  static const String createCustomRole = 'create_custom_role';
  static const String editRolePermissions = 'edit_role_permissions';
  static const String deleteCustomRole = 'delete_custom_role';
  static const String assignRoleToUser = 'assign_role_to_user';

  static Map<String, List<Map<String, String>>> get categories => {
    'Projects': [
      {'key': viewProjects, 'label': 'View Projects'},
      {'key': createProject, 'label': 'Create Project'},
      {'key': editProject, 'label': 'Edit Project'},
      {'key': deleteProject, 'label': 'Delete Project'},
    ],
    'Activities': [
      {'key': viewActivities, 'label': 'View Activities'},
      {'key': addActivity, 'label': 'Add Activity'},
      {'key': editActivity, 'label': 'Edit Activity'},
      {'key': deleteActivity, 'label': 'Delete Activity'},
      {'key': updateActivityStatus, 'label': 'Update Activity Status'},
    ],
    'Attendance': [
      {'key': viewAttendance, 'label': 'View Attendance'},
      {'key': addAttendance, 'label': 'Add Attendance'},
      {'key': editAttendance, 'label': 'Edit Attendance'},
      {'key': deleteAttendance, 'label': 'Delete Attendance'},
    ],
    'Materials': [
      {'key': viewMaterials, 'label': 'View Materials'},
      {'key': addMaterials, 'label': 'Add Materials'},
      {'key': editMaterials, 'label': 'Edit Materials'},
      {'key': deleteMaterials, 'label': 'Delete Materials'},
      {'key': updateMaterialQuantity, 'label': 'Update Material Quantity'},
    ],
    'Budget & Expenses': [
      {'key': viewBudget, 'label': 'View Budget'},
      {'key': addExpense, 'label': 'Add Expense'},
      {'key': editExpense, 'label': 'Edit Expense'},
      {'key': deleteExpense, 'label': 'Delete Expense'},
      {'key': approveExpense, 'label': 'Approve Expense'},
    ],
    'Reports': [
      {'key': viewReports, 'label': 'View Reports'},
      {'key': generateReports, 'label': 'Generate Reports'},
      {'key': generatePdf, 'label': 'Generate PDF'},
      {'key': downloadPdf, 'label': 'Download PDF'},
    ],
    'Users': [
      {'key': viewUsers, 'label': 'View Users'},
      {'key': addUsers, 'label': 'Add Users'},
      {'key': editUsers, 'label': 'Edit Users'},
      {'key': deleteUsers, 'label': 'Delete Users'},
    ],
    'Roles & Security': [
      {'key': viewRoles, 'label': 'View Roles'},
      {'key': createCustomRole, 'label': 'Create Custom Role'},
      {'key': editRolePermissions, 'label': 'Edit Role Permissions'},
      {'key': deleteCustomRole, 'label': 'Delete Custom Role'},
      {'key': assignRoleToUser, 'label': 'Assign Role to User'},
    ],
  };

  static List<String> get allPermissions {
    final List<String> list = [];
    for (var catList in categories.values) {
      for (var item in catList) {
        list.add(item['key']!);
      }
    }
    return list;
  }
}
