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
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/WarehousePullDown.dart';
import 'package:docking_project/pages/FirstPage.dart';
import 'package:docking_project/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_basecomponent/Util.dart';

import 'package:docking_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:docking_project/main.dart' as app;
void main() {
  test("test Api", () async {
    String countryCode = "86";
    String mobileNumber = "99999967";
    String licenseNumber = "AA123451";
    Request.initialize(Config.baseURL);
    SharedPreferences.setMockInitialValues({});
    Util.sharedPreferences = await SharedPreferences.getInstance();
    List<TruckType> truckList = await Request().getTrunckType();
    String selectedTruckType = truckList.first.truck_Type;
    // String verificationCode = await Request().driverRegister(mobileNumber: mobileNumber, countryCode: countryCode);
    // await Request().verify(
    //     countryCode: countryCode,
    //     tel: mobileNumber,
    //     verificationCode: verificationCode);
    await Request().updateSetting(
        countryCode: countryCode,
        tel: mobileNumber,
        default_Truck_Type: selectedTruckType,
        default_Truck_No: licenseNumber);
    Driver driver = await Request().getDriver();
    expect(driver.default_Truck_No, licenseNumber);
    expect(driver.default_Truck_Type, selectedTruckType);
    await Util.sharedPreferences.clear();
    await Future.delayed(
      Duration(seconds: 2),
      () async {
        // String verificationCode =await Request().login(countryCode: countryCode, tel: mobileNumber);
        // await Request().verify(
        //     countryCode: countryCode,
        //     tel: mobileNumber,
        //     verificationCode: verificationCode);
        await UtilExtendsion.initDriver();
        Driver driver = await Request().getDriver();
        List<Warehouse> warehouseList = await Request().getWarehouse();
        int selectedWarehouseID = warehouseList.first.warehouse_ID;
        List<dynamic> dateList = await Request().getTimeSlot(selectedWarehouseID.toString());
        List<dynamic> timeSlotList = dateList.first["bookingTimeSlots"] as List<dynamic>;
        Map<String, dynamic> timeSlot = timeSlotList.firstWhere((element) => element["isAvailable"] == true, orElse: ()=>null);
        await Request().createBooking(warehouseID: selectedWarehouseID.toString(), shipmentList: [], driverID: driver.driver_ID, driverTel: driver.tel, driverCountryCode: driver.countryCode, truckNo: driver.default_Truck_No, truckType: driver.default_Truck_Type, bookingDate: dateList.first["bookingDate"], timeSlotId: timeSlot["timeSlotId"], isChHKTruck: false);
      },
    );
  });

  // testWidgets('WarehousePullDown', (WidgetTester tester) async {
  //   await login(countryCode, mobileNumber);
  //   await tester.pumpWidget(MaterialApp(home: Scaffold(body: WarehousePullDown())));
  //   // final titleFinder = find.text("Sign Up".tr());
  //   // expect(titleFinder, findsOneWidget);
  // });
}

Future<Driver> login(String countryCode, String mobileNumber) async {
  Request.initialize(Config.baseURL);
  print(countryCode);
  print(mobileNumber);
        // String verificationCode =await Request().login(countryCode: countryCode, tel: mobileNumber);
        print("1");
        // await Request().verify(
        //     countryCode: countryCode,
        //     tel: mobileNumber,
        //     verificationCode: verificationCode);
            print("2");
        await UtilExtendsion.initDriver();
        print("3");
        Driver driver = await Request().getDriver();
        print("Get Driver");
        return driver;
}