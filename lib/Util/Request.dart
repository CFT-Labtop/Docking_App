import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/News.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Model/Warehouse.dart';
import 'package:docking_project/Util/BaseError.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/BaseRequest.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';


class Request extends BaseRequest {
  static final Request _request = Request._internal();
  Request._internal();
  factory Request() => _request;
  factory Request.initialize(String baseUrl) {
    return _request.init(baseUrl, _request) as Request;
  }

  Future<List<TruckType>> getTrunckType(BuildContext context, Locale lang) async {
    return await _run<List<TruckType>>(context: context, callback: () async {
      clearToken();
      Response response = await this.dio.get(this.baseURL + "Master/TruckType", queryParameters: {"lang": UtilExtendsion.localeToLocaleCode(lang)} );
      return (response.data as List<dynamic>)
          .map((f) => TruckType.fromJson(f))
          .toList();
    });
  }

  Future<List<TruckType>> getTrunckTypeByWarehouseID(BuildContext context, int warehouseID) async {
    return await _run<List<TruckType>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Master/TruckType/" + warehouseID.toString());
      return (response.data as List<dynamic>)
          .map((f) => TruckType.fromJson(f))
          .toList();
    });
  }

  Future<List<Warehouse>> getWarehouse(BuildContext context) async {
    return await _run<List<Warehouse>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      // _setFakeToken();
      Response response = await this.dio.get(this.baseURL + "Master/Warehouse");
      return (response.data as List<dynamic>)
          .map((f) => Warehouse.fromJson(f))
          .toList();
    });
  }

  Future<Map<String, dynamic>> driverRegister(BuildContext context,
      {String mobileNumber,
      String countryCode,
      String carType,
      String license,
      Locale lang}) async {
    return await _run<Map<String, dynamic>>(context: context, callback: () async {
      clearToken();
      Response response = await this.dio.post(this.baseURL + "Driver", data: {
        "tel": mobileNumber,
        "countryCode": countryCode,
        "default_Truck_Type": carType ?? null,
        "default_Truck_No": license ?? null,
        "lang": UtilExtendsion.localeToLocaleCode(lang)
      });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);

      return response.data["rstData"] as Map<String, dynamic>;
    });
  }

  Future<void> verify(
    BuildContext context,
      {String countryCode,
      String tel,
      String verificationCode,
      Locale lang}) async {
    await _run<void>(context: context, callback: () async {
      clearToken();
      Response response =
          await this.dio.post(this.baseURL + "Driver/Verify", data: {
        "countryCode": countryCode,
        "tel": tel,
        "verificationCode": verificationCode,
        "lang": UtilExtendsion.localeToLocaleCode(lang)
      });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      await Util.sharedPreferences
          .setString("Authorization", response.data["rstData"]);
    });
  }

  Future<Map<String, dynamic>> login(BuildContext context, {String countryCode, String tel, Locale lang}) async {
    return await _run<Map<String, dynamic>>(context: context, callback: () async {
      clearToken();
      Response response =
          await this.dio.post(this.baseURL + "Driver/Login", data: {
        "countryCode": countryCode,
        "tel": tel,
        "lang":UtilExtendsion.localeToLocaleCode(lang)
      });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      return response.data["rstData"] as Map<String, dynamic>;
    });
  }

  Future<void> updateSetting(
    BuildContext context,
      {String countryCode,
      String tel,
      String default_Truck_No,
      String default_Truck_Type}) async {
    await _run<void>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.put(this.baseURL + "Driver", data: {
        "countryCode": countryCode,
        "tel": tel,
        "default_Truck_No": default_Truck_No,
        "default_Truck_Type": default_Truck_Type
      });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
    });
  }

  Future<Driver> getDriver({BuildContext context}) async {
    return await _run<Driver>(context: context ?? null, callback:  () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "User/username");
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      String driverID = response.data["rstData"];
      response = await this.dio.get(this.baseURL + "Driver/" + driverID);
      return Driver(
          driver_ID: response.data["driver_ID"],
          tel: response.data["tel"],
          default_Truck_No: response.data["default_Truck_No"],
          default_Truck_Type: response.data["default_Truck_Type"],
          countryCode: response.data["countryCode"]);
    });
  }

  Future<List<dynamic>> getTimeSlot(BuildContext context,int warehouseID, String truckType) async {
    return await _run<List<dynamic>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this
          .dio
          .get(this.baseURL + "Booking/TimeSlot/" + warehouseID.toString() + "/" + truckType);
      return response.data;
    });
  }

  Future<T> _run<T>({BuildContext context, @required dynamic callback}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.none){
        throw new Exception("Unstable Network".tr());
      }
      var response = await callback();
      return response as T;
    } on DioError catch (e) {
      if(e.response.statusCode == 401){
         Util.showAlertDialog(context, "", title: "Another User Has Been Login".tr(), onPress: (){
          Util.sharedPreferences.clear();
          FlutterRouter().goToPage(context, Pages("FirstPage"), clear: true);
        });
      }else{
        Util.showAlertDialog(context, "", title: "Unstable Network".tr());
      }
    } on BaseError catch (e) {
      throw e;
    }catch (e) {
      Util.showAlertDialog(context, "", title: "Unstable Network".tr());
      // throw e;
    }
  }

  Future<Booking> createBooking(
    BuildContext context,
      {int warehouseID,
      List<String> shipmentList,
      String driverID,
      String driverTel,
      String driverCountryCode,
      String truckNo,
      String truckType,
      String bookingDate,
      String timeSlotId,
      bool isChHKTruck,
      String bookingRemark,
      int timeSlotUsage}) async {
        return await _run<Booking>(context: context, callback: ()async {
          clearToken();
      _setHeader();
      Response response = await this.dio.post(this.baseURL + "Booking", data: {
        "warehouseId": warehouseID.toString(),
        "shipmentList": shipmentList,
        "driverID": driverID,
        "driverTel": driverTel,
        "driverCountryCode": driverCountryCode,
        "truckNo": truckNo,
        "truckType": truckType,
        "bookingDate": bookingDate,
        "timeSlotId": timeSlotId,
        "isChHKTruck": isChHKTruck,
        "bookingRemark": bookingRemark ?? "",
        "timeSlotUsage": timeSlotUsage
      });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      return new Booking.fromJson(response.data["rstData"]);
        });
  }

  Future<List<Booking>> getBookingList(BuildContext context, String driverID) async {
    return await _run<List<Booking>>(context: context, callback: () async{
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Booking/",
          queryParameters: {"driverID": driverID});
      if (response.data == "") return <Booking>[];
      return (response.data as List<dynamic>).map((f) => Booking.fromJson(f)).toList();
    });
  }

  Future<void> deleteBooking(BuildContext context, String bookingRef) async {
    await _run<void>(context: context, callback: ()async {
      clearToken();
      _setHeader();
      Response response =
          await this.dio.delete(this.baseURL + "Booking/" + bookingRef);
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
    });
  }

  Future<void> truckArrive(BuildContext context, String bookingRef) async {
    await _run<void>(context: context, callback: () async{
      clearToken();
      _setHeader();
      Response response = await this
          .dio
          .put(this.baseURL + "Booking/TruckArrive/" + bookingRef);
      if (response.data["rstCode"] != 0) throw response.data["rstMsg"];
    });
  }

  Future<void> renewToken(BuildContext context) async {
    await _run<void>(context: context,callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.post(this.baseURL + "User/RenewToken");
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      await Util.sharedPreferences.setString("Authorization", response.data["rstData"]);
      return response.data["rstData"];
    });
  }

  Future<List<News>> getLatestNews(BuildContext context,Locale lang) async {
    return await _run<List<News>>(context: context, callback: () async{
      clearToken();
      // _setHeader();
      Response response = await this.dio.get(this.baseURL + "LatestNews" + "/" + UtilExtendsion.localeToLocaleCode(lang));
      if (response.data == "") return <News>[];
      return (response.data as List<dynamic>)
          .map((f) => News.fromJson(f))
          .toList();
    });
  }

  Future<void> changeLanguage(BuildContext context, Locale lang) async {
    await _run<void>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.post(this.baseURL + "User/ChangeLanguage", queryParameters: {'lang': UtilExtendsion.localeToLocaleCode(lang)});;
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
      await Util.sharedPreferences.setString("Authorization", response.data["rstData"]);
    });
  }

  Future<void> logout(BuildContext context, String token) async {
    await _run<void>(context: context, callback: () async {
      clearToken();
      this.dio.options.headers["Authorization"] = "bearer " + token;
      Response response = await this.dio.post(this.baseURL + "User/Logout");
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
    });
  }

  void _setHeader() {
    this.dio.options.headers["Authorization"] =
        "bearer " + Util.sharedPreferences.getString("Authorization");
  }

  void _setFakeToken() {
    this.dio.options.headers["Authorization"] = "bearer " +
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiRDAwMDAxMzIiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJEcml2ZXIiLCJMYW5nIjoiemhoayIsIm5iZiI6MTYyNDUyNDY4OSwiZXhwIjoxNjI1MTI5NDg5LCJpc3MiOiJTVU5ISU5HR1JPVVAiLCJhdWQiOiJTVU5ISU5HR1JPVVAifQ.WveLwlNq0LIXsVSWke4JOZs_7wxD8nlLACvMAMsaia0";
  }

  void clearToken() {
    this.dio.options.headers["Authorization"] = null;
  }
}
