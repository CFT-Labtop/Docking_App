// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Model/Warehouse.dart';
import 'package:docking_project/Util/Config.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypePullDown.dart';
import 'package:docking_project/Widgets/LicenseStandardTextField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/WarehousePullDown.dart';
import 'package:docking_project/pages/FirstPage.dart';
import 'package:docking_project/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_basecomponent/Util.dart';

import 'package:docking_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:docking_project/main.dart' as app;

void main() {
  testWidgets('WarehousePullDown', (WidgetTester tester) async {
    List<PickerItem> warehouseSelection = [new PickerItem(text: Text("TestCode1"), value: 1), new PickerItem(text: Text("TestCode2"), value: 2)];
    final _warehouseKey = GlobalKey<WarehousePullDownState>();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WarehousePullDown(warehouseSelection: warehouseSelection,key: _warehouseKey, initValue: 2,)))) ;
    final BuildContext context = tester.element(find.byType(WarehousePullDown));
    expect(find.text("TestCode2"),findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, 2);
    expect(_warehouseKey.currentState.selectedLabel, "TestCode2");
    await tester.tap(find.byKey(_warehouseKey));
    await tester.pumpAndSettle();
    expect(find.text("Cancel"),findsOneWidget);
    expect(find.text("Confirm"),findsOneWidget);
    expect(find.text("TestCode1"),findsOneWidget);
    expect(find.text("TestCode2"),findsNWidgets(2));
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();
    expect(find.byKey(_warehouseKey), findsOneWidget);
    expect(find.text("TestCode1"), findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, 1);
    expect(_warehouseKey.currentState.selectedLabel, "TestCode1");
    await tester.tap(find.byKey(_warehouseKey));
    await tester.pumpAndSettle();
    expect(find.text("Cancel"),findsOneWidget);
    expect(find.text("Confirm"),findsOneWidget);
    expect(find.text("TestCode1"),findsNWidgets(2));
    expect(find.text("TestCode2"),findsOneWidget);
    final gesture = await tester.startGesture(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2));
    await gesture.moveTo(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2 -200)); //How much to scroll by
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();
    expect(find.byKey(_warehouseKey), findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, 2);
    expect(_warehouseKey.currentState.selectedLabel, "TestCode2");
    expect(find.text("TestCode2"), findsOneWidget);
  });

  testWidgets('CarTyePullDown', (WidgetTester tester) async {
    List<PickerItem> truckSelection = [new PickerItem(text: Text("TestCode1"), value: "1"), new PickerItem(text: Text("TestCode2"), value: "2")];
    final _warehouseKey = GlobalKey<CarTypePullDownState>();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: CarTypePullDown(truckTypeSelection: truckSelection,key: _warehouseKey, initValue: "2",)))) ;
    final BuildContext context = tester.element(find.byType(CarTypePullDown));
    expect(find.text("TestCode2"),findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, "2");
    expect(_warehouseKey.currentState.selectedLabel, "TestCode2");
    await tester.tap(find.byKey(_warehouseKey));
    await tester.pumpAndSettle();
    expect(find.text("Cancel"),findsOneWidget);
    expect(find.text("Confirm"),findsOneWidget);
    expect(find.text("TestCode1"),findsOneWidget);
    expect(find.text("TestCode2"),findsNWidgets(2));
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();
    expect(find.byKey(_warehouseKey), findsOneWidget);
    expect(find.text("TestCode1"), findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, "1");
    expect(_warehouseKey.currentState.selectedLabel, "TestCode1");
    await tester.tap(find.byKey(_warehouseKey));
    await tester.pumpAndSettle();
    expect(find.text("Cancel"),findsOneWidget);
    expect(find.text("Confirm"),findsOneWidget);
    expect(find.text("TestCode1"),findsNWidgets(2));
    expect(find.text("TestCode2"),findsOneWidget);
    final gesture = await tester.startGesture(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2));
    await gesture.moveTo(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2 -200)); //How much to scroll by
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();
    expect(find.byKey(_warehouseKey), findsOneWidget);
    expect(_warehouseKey.currentState.selectedValue, "2");
    expect(_warehouseKey.currentState.selectedLabel, "TestCode2");
    expect(find.text("TestCode2"), findsOneWidget);
  });

  testWidgets('text TextEditField', (WidgetTester tester) async {
    final _formKey = GlobalKey<FormState>();
    final _mobileTextFieldKey = GlobalKey<MobileStandardTextFieldState>();
    final TextEditingController mobileTextController = TextEditingController();
    final TextEditingController licenseTextController = TextEditingController();
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Form(
      key: _formKey,
      child: Column(
        children: [
          LicenseStandardTextField(textController: licenseTextController,),
          MobileStandardTextField(key: _mobileTextFieldKey, mobileTextController: mobileTextController, onPress: (String countryCode) {  }, initialPrefix: "86",),
        ],
      ),
    )))) ;
    final BuildContext context = tester.element(find.byType(Form));
    expect(find.text("86"), findsOneWidget);
    expect(_mobileTextFieldKey.currentState.countryCode, "86");
    await tester.tap(find.text("86"));
    await tester.pumpAndSettle();
    expect(find.text("86"), findsNWidgets(2));
    expect(find.text("852"), findsOneWidget);
    final gesture = await tester.startGesture(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2));
    await gesture.moveTo(Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2 + 200)); //How much to scroll by
    await tester.pumpAndSettle();
    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();
    expect(find.text("852"), findsOneWidget);
    expect(_mobileTextFieldKey.currentState.countryCode, "852");
    await tester.enterText(find.byType(MobileStandardTextField), '12958192571927381274891274');
    await tester.enterText(find.byType(LicenseStandardTextField), 'AA124151234151');
    expect(find.text("12958192571927381274891274"), findsOneWidget);
    expect(find.text("AA124151234151"), findsOneWidget);
    _formKey.currentState.validate();
    await tester.pumpAndSettle();
    expect(find.text("License Number Cannot Be Larger Than 10 Characters"), findsOneWidget);
    expect(find.text("Mobile Number Cannot Larger Than 20 Characters"), findsOneWidget);
    mobileTextController.clear();
    await tester.enterText(find.byType(MobileStandardTextField), '');
    _formKey.currentState.validate();
    await tester.pumpAndSettle();
    expect(find.text("Mobile Number Cannot Be Empty"), findsOneWidget);
    await tester.enterText(find.byType(MobileStandardTextField), '124151234');
    _formKey.currentState.validate();
    await tester.pumpAndSettle();
    expect(find.text("Hong Kong Mobile Number Cannot Larger Than 8 Characters"), findsOneWidget);
    await tester.enterText(find.byType(MobileStandardTextField), '12345678');
    await tester.enterText(find.byType(LicenseStandardTextField), 'AA1234');
    expect(find.text("12345678"), findsOneWidget);
    expect(find.text("AA1234"), findsOneWidget);
    expect(_formKey.currentState.validate(), true) ;
    await tester.pumpAndSettle();
  });
}