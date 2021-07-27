import 'dart:convert';
import 'dart:ui';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:new_version/new_version.dart';
import 'package:easy_localization/easy_localization.dart';

extension UtilExtendsion on Util {
  static const Color mainColor = Color.fromRGBO(202,37,46,1);
  static List<PickerItem> getTruckTypeSelection(List<TruckType> truckTypeList) {
    return truckTypeList.map((e) =>new PickerItem(text: Text(e.typeName), value: e.truck_Type)).toList();
  }


  static Future<void> checkForUpdate(BuildContext context) async{
    // final newVersion = NewVersion(
    //   iOSId: 'com.cft.docking',
    //   androidId: 'com.cft.docking_project',
    // );
    // final status = await newVersion.getVersionStatus();
    // if(status.canUpdate)
    //   newVersion.showUpdateDialog(
    //   context: context, 
    //   versionStatus: status,
    //   dialogTitle: "Update Available".tr(),
    //   dialogText: 'You Can Now Update This App'.tr(),
    //   updateButtonText: 'Update'.tr(),
    //   dismissButtonText: 'Dismiss'.tr(),
    //   dismissAction: () => {
    //     Navigator.pop(context)
    //   },
    // );
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

  static Widget CustomFutureBuild(BuildContext context, AsyncSnapshot<dynamic> snapshot, Widget Function() callBack, {Widget Function() loadingCallBack}) {
    if (snapshot.hasError) {
      // if(snapshot.error == "Http status error [401]"){
      //   Util.showAlertDialog(context, "", title: "Another User Has Been Login".tr(), onPress: (){
      //     Util.sharedPreferences.clear();
      //     FlutterRouter().goToPage(context, Pages("FirstPage"), clear: true);
      //   });
      // }
      return Center(
          child: Text(
        "Unstable Network".tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey, fontSize: Util.responsiveSize(context, 24)),
      ));
    } else if (snapshot.connectionState == ConnectionState.done) {
      return callBack();
    } else {
      if(loadingCallBack != null)
        return loadingCallBack();
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
