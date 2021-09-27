import 'dart:convert';
import 'dart:ui';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckClient.dart';
import 'package:docking_project/Model/TruckCompany.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:new_version/new_version.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

extension UtilExtendsion on Util {
  static const Color mainColor = Color.fromRGBO(202,37,46,1);
  static List<PickerItem> getTruckCompanySelection(List<TruckCompany> truckCompanyList) {
    return truckCompanyList.map((e) =>new PickerItem(text: Text(e.companyName), value: e.companyID)).toList();
  }
  static List<PickerItem> getTruckTypeSelection(List<TruckType> truckTypeList) {
    return truckTypeList.map((e) =>new PickerItem(text: Text(e.typeName), value: e.truck_Type)).toList();
  }
  static List<PickerItem> getTruckClientSelection(List<TruckClient> truckClientList) {
    return truckClientList.map((e) =>new PickerItem(text: Text(e.clientName), value: e.clientID)).toList();
  }

  static Future<bool> getIsNeedShipment(BuildContext context) async{
    Response response = await Request().getConfig(context);
    List<Map<String, dynamic>> data = (response.data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == "MustInputShipmentNo", orElse: () => null);
    if(keyMap == null)
      return false;
    String value = keyMap["configValue"];
    return value.toLowerCase() == "true" ? true : false;
  }

  static bool _isCurrentVersionLessThanMinVersion(String localVersion, String minVersion){
    List<String> localVersionList = localVersion.split(".");
    List<String> minVersionList = minVersion.split(".");
    if(int.parse(localVersionList[0]) < int.parse(minVersionList[0]))
      return true;
    else if(int.parse(localVersionList[1]) < int.parse(minVersionList[1]))
      return true;
    else if (int.parse(localVersionList[2]) < int.parse(minVersionList[2]))
      return true;
    return false;
  }

  static Future<Map<String, dynamic>> getConfigItem(BuildContext context, String configKey) async{
    Response response = await Request().getConfig(context);
    List<Map<String, dynamic>> data = (response.data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == configKey, orElse: () => null);
    return keyMap;
  }

  // static Future<void> checkForUpdate(BuildContext context) async{
  //   bool isLessThanMinVersion = false;
  //   Response response = await Request().getConfigVersion(context);
  //   String minVersion = "1.0.0";
  //   List<Map<String, dynamic>> data = (response.data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
  //   if(Platform.isIOS){
  //     Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == "IOSMinVersion", orElse: () => null);
  //     minVersion = keyMap["configValue"];
  //   }else if(Platform.isAndroid){
  //     Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == "AndroidMinVersion", orElse: () => null);
  //     minVersion = keyMap["configValue"];
  //   }
  //   final newVersion = NewVersion(iOSId: 'com.cft.docking',androidId: 'com.cft.docking_project',);
  //   final status = await newVersion.getVersionStatus();
  //   isLessThanMinVersion = _isCurrentVersionLessThanMinVersion(status.localVersion, minVersion);
  //   if(status.canUpdate && status.storeVersion != "Varies with device" && isLessThanMinVersion)
  //     newVersion.showUpdateDialog(
  //     context: context, 
  //     versionStatus: status,
  //     dialogTitle: "Update Available".tr(),
  //     dialogText: 'You Can Now Update This App'.tr(),
  //     updateButtonText: 'Update'.tr(),
  //     dismissButtonText: 'Dismiss'.tr(),
  //     dismissAction: () => {
  //       exit(0)
  //     },
  //   );
  // }

  static Future<void> checkForUpdate(BuildContext context) async{
    bool isLessThanMinVersion = false;
    Response response = await Request().getConfigVersion(context);
    String minVersion = "1.0.0";
    List<Map<String, dynamic>> data = (response.data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    if(Platform.isIOS){
      Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == "IOSMinVersion", orElse: () => null);
      minVersion = keyMap["configValue"];
    }else if(Platform.isAndroid){
      Map<String, dynamic> keyMap = data.firstWhere((element) => element["configKey"] == "AndroidMinVersion", orElse: () => null);
      minVersion = keyMap["configValue"];
    }
    final newVersion = NewVersion(iOSId: 'com.cft.docking',androidId: 'com.cft.docking_project',);
    final status = await newVersion.getVersionStatus();
    isLessThanMinVersion = _isCurrentVersionLessThanMinVersion(status.localVersion, minVersion);
    if(isLessThanMinVersion)
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text("Update Available".tr()).tr(),
              actions: <Widget>[
                PlatformDialogAction(
                  child: PlatformText('Confirm'.tr()),
                  onPressed: () {
                    launch("https://dkmsweb-prod.sunhinggroup.com/support");
                  },
                ),
              ],
            ));
    // if(status.canUpdate && status.storeVersion != "Varies with device" && isLessThanMinVersion)
    //   newVersion.showUpdateDialog(
    //   context: context, 
    //   versionStatus: status,
    //   dialogTitle: "Update Available".tr(),
    //   dialogText: 'You Can Now Update This App'.tr(),
    //   updateButtonText: 'Update'.tr(),
    //   dismissButtonText: 'Dismiss'.tr(),
    //   dismissAction: () => {
    //     exit(0)
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
