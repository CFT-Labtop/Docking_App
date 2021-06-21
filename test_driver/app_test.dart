import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('end-to-end test', () {
    testWidgets('First Page',(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await app.main();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5), () async {
        expect(find.text("新司機登記"), findsOneWidget);
      });
    });
  });
}