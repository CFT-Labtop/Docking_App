import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/pages/PhoneSignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/main.dart' as app;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    group('end-to-end test', () {
    testWidgets('App Integration Test',(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await app.main();
      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));
      await tester.pumpAndSettle();
      checkFirstPage(tester);
      await tester.tap(find.text("Sign Up".tr()));
      await tester.pumpAndSettle();
      await checkPhoneSignUpPage(tester);
      await testMobileStandardField(tester);
    });
  });
}

void checkFirstPage(WidgetTester tester){
  expect(find.text("Sign Up".tr()), findsOneWidget);
  expect(find.text("Sign In".tr()), findsOneWidget);
  expect(find.text("Ready to get stuff done?".tr()), findsOneWidget);
  expect(find.text("Dock Booking System".tr()), findsOneWidget);
}

void checkPhoneSignUpPage(WidgetTester tester) async {
  expect(find.text("Enter Your Phone Number and Licence Number".tr()), findsOneWidget);
  // expect(find.text("Sign In".tr()), findsOneWidget);
  expect(find.text("Please select your car type".tr()), findsOneWidget);
  expect(find.text("852".tr()), findsOneWidget);
  expect(find.byType(MobileStandardTextField), findsOneWidget);
  await testMobileStandardField(tester);
}

void testMobileStandardField(WidgetTester tester)async{
 await tester.tap(find.text("852"));
 await tester.pumpAndSettle();
  expect(find.text("852"),findsNWidgets(2));
  expect(find.text("86"),findsOneWidget);
  final BuildContext context = tester.element(find.byType(PhoneSignUpPage));
  final gesture = await tester.startGesture(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2));
}