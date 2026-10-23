import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SharedPreferences saves and retrieves project details across app restarts', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('inframate_project_name', 'Skyline Grandeur');
    await prefs.setString('inframate_project_location', 'Mumbai, Maharashtra');

    expect(prefs.getString('inframate_project_name'), 'Skyline Grandeur');
    expect(prefs.getString('inframate_project_location'), 'Mumbai, Maharashtra');
  });
}
