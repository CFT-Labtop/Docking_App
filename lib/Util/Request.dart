import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/News.dart';
import 'package:docking_project/Model/TruckClient.dart';
import 'package:docking_project/Model/TruckCompany.dart';
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

  Future<List<TruckClient>> getTruckClient(BuildContext context, Locale lang) async {
    return await _run<List<TruckClient>>(context: context, callback: () async {
      clearToken();
      Response response = await this.dio.get(this.baseURL + "Master/TruckClient", queryParameters: {"lang": UtilExtendsion.localeToLocaleCode(lang)} );
      return (response.data as List<dynamic>)
          .map((f) => TruckClient.fromJson(f))
          .toList();
    });
  }

  Future<List<TruckCompany>> getTruckCompany(BuildContext context, Locale lang) async {
    return await _run<List<TruckCompany>>(context: context, callback: () async {
      clearToken();
      Response response = await this.dio.get(this.baseURL + "Master/TruckCompany", queryParameters: {"lang": UtilExtendsion.localeToLocaleCode(lang)} );
      return (response.data as List<dynamic>)
          .map((f) => TruckCompany.fromJson(f))
          .toList();
    });
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

  Future<List<TruckClient>> getTruckClientByWarehouseID(BuildContext context, int warehouseID) async {
    return await _run<List<TruckClient>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Master/TruckClient/" + warehouseID.toString());
      return (response.data as List<dynamic>)
          .map((f) => TruckClient.fromJson(f))
          .toList();
    });
  }

  Future<List<TruckCompany>> getTruckCompanyByWarehouseID(BuildContext context, int warehouseID) async {
    return await _run<List<TruckCompany>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Master/TruckCompany/" + warehouseID.toString());
      return (response.data as List<dynamic>)
          .map((f) => TruckCompany.fromJson(f))
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
      bool isChHKTruck,
      int clientID,
      int companyID,
      Locale lang}) async {
    return await _run<Map<String, dynamic>>(context: context, callback: () async {
      clearToken();
      Response response = await this.dio.post(this.baseURL + "Driver", data: {
        "tel": mobileNumber,
        "countryCode": countryCode,
        "default_Truck_Type": carType ?? null,
        "default_Truck_No": license ?? null,
        "default_Is_CH_HK_Truck": isChHKTruck ?? false,
        "default_Client_ID": clientID ?? null,
        "default_Company_ID": companyID ?? null,
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
      String default_Truck_Type,
      String default_,
      bool default_Is_CH_HK_Truck,
      int default_Client_ID,
      int default_Company_ID}) async {
    await _run<void>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.put(this.baseURL + "Driver", data: {
        "countryCode": countryCode,
        "tel": tel,
        "default_Truck_No": default_Truck_No ?? null,
        "default_Truck_Type": default_Truck_Type ?? null,
        "default_Is_CH_HK_Truck": default_Is_CH_HK_Truck ?? null,
        "default_Client_ID": default_Client_ID ?? null,
        "default_Company_ID": default_Company_ID ?? null,
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
      Response driverResponse = await this.dio.get(this.baseURL + "Driver/" + driverID);
      return Driver(
          driver_ID: driverResponse.data["driver_ID"],
          tel: driverResponse.data["tel"],
          default_Truck_No: driverResponse.data["default_Truck_No"],
          default_Truck_Type: driverResponse.data["default_Truck_Type"],
          default_Is_CH_HK_Truck: driverResponse.data["default_Is_CH_HK_Truck"],
          default_Client_ID: driverResponse.data["default_Client_ID"],
          default_Company_ID: driverResponse.data["default_Company_ID"],
          countryCode: driverResponse.data["countryCode"]);
    });
  }

  Future<List<dynamic>> getTimeSlot(BuildContext context,int warehouseID, String truckType, int clientID) async {
    return await _run<List<dynamic>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this
          .dio
          .get(this.baseURL + "Booking/TimeSlot/" + warehouseID.toString() + "/" + truckType + "/" + clientID.toString());
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
      int clientID,
      int companyID,
      bool isChHKTruck,
      bool unloading,
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
        "clientID": clientID,
        "companyID": companyID,
        "isChHKTruck": isChHKTruck,
        "unloading": unloading,
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
      Response response = await this.dio.get(this.baseURL + "Booking/",queryParameters: {"driverID": driverID});
      if (response.data == "") return <Booking>[];
      return (response.data as List<dynamic>).map((f) => Booking.fromJson(f)).toList();
    });
  }

  Future<Booking> getBooking(BuildContext context, String bookingRef) async {
    return await _run<Booking>(context: context, callback: () async{
      Response response = await this.dio.get(this.baseURL + "Booking/" + bookingRef);
      if (response.data == "") return null;
      return Booking.fromJson(response.data);
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

  Future<void> deleteBookingWithReason(BuildContext context, String bookingRef, String reason) async {
    await _run<void>(context: context, callback: ()async {
      clearToken();
      _setHeader();
      Response response =
          await this.dio.delete(this.baseURL + "Booking", data: {
            "bookingRef": bookingRef,
            "cancelReason": reason
          });
      if (response.data["rstCode"] != 0) throw BaseError(response.data["rstMsg"]);
    });
  }

  Future<void> truckArrive(BuildContext context, String bookingRef, double latitude, double longitude) async {
    await _run<void>(context: context, callback: () async{
      clearToken();
      _setHeader();
      Response response = await this
          .dio
          .put(this.baseURL + "Booking/TruckArrive", data: {"bookingRef": bookingRef ,"latitude": latitude, "longitude": longitude});
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

  Future<Response> getConfig(BuildContext context) async {
    return await _run<Response>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Config");
      return response;
    });
  }

  Future<Response> getConfigVersion(BuildContext context) async {
    return await _run<Response>(context: context, callback: () async {
      // clearToken();
      // _setHeader();
      Response response = await this.dio.get(this.baseURL + "Config/Version");
      return response;
    });
  }

  Future<List<Map<String, dynamic>>> getCancelReasons(BuildContext context) async {
    return await _run<List<Map<String, dynamic>>>(context: context, callback: () async {
      clearToken();
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "CancelReason");
      List<Map<String, dynamic>> data = (response.data as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
      return data;
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
