import 'package:flutter_test/flutter_test.dart';
import 'package:riverside_flutter_app/main.dart';

void main() {
  testWidgets('Inframate App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InframateApp());
    expect(find.text('Inframate'), findsWidgets);
  });
}
