import 'dart:convert';
import 'dart:ui';

import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

extension UtilExtendsion on Util {
  static const Color mainColor = Color.fromRGBO(202,37,46,1);
  static List<PickerItem> getTruckTypeSelection(Locale locale, List<TruckType> truckTypeList) {
    return truckTypeList.map((e) =>new PickerItem(text: Text(locale.toString() == "en_US" ? e.typeName_En : e.typeName_Ch), value: e.truck_Type)).toList();
  }

  static Future<void> initDriver() async {
    try {
      Driver driver = await Request().getDriver();
      await Util.sharedPreferences.setString("default_Truck_No", driver.default_Truck_No ?? "");
      await Util.sharedPreferences.setString("default_Truck_Type", driver.default_Truck_Type ?? "");
      await Util.sharedPreferences.setString("tel", driver.tel ?? "");
      await Util.sharedPreferences.setString("driver_ID", driver.driver_ID ?? "");
    } catch (error) {
      print(error);
    }
  }

  static Future<void> setPreviousWarehouse(int warehouseID) async {
    await Util.sharedPreferences.setInt("previouse_warehouseID",warehouseID ?? null);
  }

  static int getPreviouseWarehouse() {
    try {
      return Util.sharedPreferences.getInt("previouse_warehouseID");
    }
    catch(error){
      return null;
    }
  }

  static String getDefaultTruckNo() {
    try {
      return Util.sharedPreferences.getString("default_Truck_No");
    } catch (error) {
      return "";
    }
  }

  static String getDefaultTruckType() {
    try {
      return Util.sharedPreferences.getString("default_Truck_Type");
    } catch (error) {
      return "";
    }
  }

  static String getTel() {
    try {
      return Util.sharedPreferences.getString("tel");
    } catch (error) {
      return "";
    }
  }

  static String getDriverID() {
    try {
      return Util.sharedPreferences.getString("driver_ID");
    } catch (error) {
      return "";
    }
  }

  static String getToken() {
    try {
      return Util.sharedPreferences.getString("Authorization");
    } catch (error) {
      return "";
    }
  }

  static Widget CustomFutureBuild(BuildContext context, AsyncSnapshot<dynamic> snapshot, Widget Function() callBack) {
    if (snapshot.hasError) {
      return Center(
          child: Text(
        snapshot.error,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey, fontSize: Util.responsiveSize(context, 24)),
      ));
    } else if (snapshot.connectionState == ConnectionState.done) {
      return callBack();
    } else {
      return Center(child: PlatformCircularProgressIndicator());
    }
  }

  static String localeToLocaleCode(Locale locale){
    switch(locale.toString()){
      case "en_US":
        return "en";
      case "zh_CN":
        return "zhcn";
      case "zh_HK":
        return "zhhk";
    }
    return "zhhk";
  }
}
