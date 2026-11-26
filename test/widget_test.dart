import 'package:flutter_test/flutter_test.dart';
import 'package:app_tecnologia/main.dart';
import 'package:app_tecnologia/login.dart';

void main() {
  testWidgets('TechStock abre correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const TechStockApp());
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
