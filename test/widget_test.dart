// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:docking_project/main.dart';

void main() {
  testWidgets('Login Page test', (WidgetTester tester) async {
    final TextEditingController mobileTextController = TextEditingController();
    final _mobileTextFieldKey = GlobalKey<MobileStandardTextFieldState>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MobileStandardTextField(
            key: _mobileTextFieldKey,
            initialPrefix: "86",
            onPress: (String value) {},
            mobileTextController: mobileTextController),
      ),
    ));
    tester.tap(find.byKey(_mobileTextFieldKey));
  });
}
