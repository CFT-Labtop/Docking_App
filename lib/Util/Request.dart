import 'package:dio/dio.dart';
import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/News.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Model/Warehouse.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/BaseRequest.dart';
import 'package:flutter_basecomponent/Util.dart';

class Request extends BaseRequest{
  static final Request _request = Request._internal();
  Request._internal();
  factory Request() => _request;
  factory Request.initialize(String baseUrl) {
    return _request.init(baseUrl, _request) as Request;
  }

  Future<List<TruckType>> getTrunckType()async {
    try {
      Response response = await this.dio.get(this.baseURL + "Master/TruckType");
      return (response.data as List<dynamic>).map((f) => TruckType.fromJson(f)).toList();
    } on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<List<Warehouse>> getWarehouse()async {
    try {
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Master/Warehouse");
      return (response.data as List<dynamic>).map((f) => Warehouse.fromJson(f)).toList();
    } on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<Map<String, dynamic>> driverRegister({String mobileNumber, String countryCode , String carType, String license})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver", data: {
        "tel": mobileNumber,
        "countryCode": countryCode,
        "default_Truck_Type": carType ?? null,
        "default_Truck_No": license ?? null,
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      print("Verifiy Code " + response.data["rstData"]["verificationCode"]);
      return response.data["rstData"] as Map<String, dynamic>;
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> verify({String countryCode, String tel , String verificationCode, Locale lang})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver/Verify", data: {
        "countryCode": countryCode,
        "tel": tel,
        "verificationCode": verificationCode,
        "lang": UtilExtendsion.localeToLocaleCode(lang)
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      await Util.sharedPreferences.setString("Authorization", response.data["rstData"]);
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<Map<String, dynamic>> login({String countryCode, String tel})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver/Login", data: {
        "countryCode": countryCode,
        "tel": tel,
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      print("Verifiy Code " + response.data["rstData"]["verificationCode"]);
      return response.data["rstData"] as Map<String, dynamic>;
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> updateSetting({String countryCode, String tel, String default_Truck_No, String default_Truck_Type})async {
    try {
      _setHeader();
      Response response = await this.dio.put(this.baseURL + "Driver", data: {
        "countryCode": countryCode,
        "tel": tel,
        "default_Truck_No": default_Truck_No,
        "default_Truck_Type": default_Truck_Type
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<Driver> getDriver()async {
    try {
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "User/username");
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      String driverID = response.data["rstData"];
      response = await this.dio.get(this.baseURL + "Driver/" + driverID);
      return Driver(driver_ID: response.data["driver_ID"], tel: response.data["tel"], default_Truck_No: response.data["default_Truck_No"], default_Truck_Type: response.data["default_Truck_Type"], countryCode: response.data["countryCode"]);
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<List<dynamic>> getTimeSlot(String warehouseID)async {
    try{
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Booking/TimeSlot/" + warehouseID.toString());
      return response.data;
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<Booking> createBooking({String warehouseID, List<String> shipmentList, String driverID, String driverTel, String driverCountryCode, String truckNo, String truckType, String bookingDate, String timeSlotId, bool isChHKTruck, String bookingRemark})async {
    try{
      _setHeader();
      Response response = await this.dio.post(this.baseURL + "Booking",data: {
        "warehouseID": warehouseID,
        "shipmentList": shipmentList,
        "driverID": driverID,
        "driverTel": driverTel,
        "driverCountryCode": driverCountryCode,
        "truckNo": truckNo,
        "truckType": truckType,
        "bookingDate": bookingDate,
        "timeSlotId": timeSlotId,
        "isChHKTruck": isChHKTruck,
        "bookingRemark": bookingRemark?? "",
        "timeSlotUsage": 1
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      return new Booking.fromJson(response.data["rstData"]);
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }
  Future<List<Booking>> getBookingList(String driverID)async {
    try{
      _setHeader();
      Response response = await this.dio.get(this.baseURL + "Booking/", queryParameters: {"driverID": driverID});
      if(response.data == "") return [];
      return (response.data as List<dynamic>).map((f) => Booking.fromJson(f)).toList();
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> deleteBooking(String bookingRef)async {
    try{
      _setHeader();
      Response response = await this.dio.delete(this.baseURL + "Booking/" + bookingRef);
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }
  Future<void> truckArrive(String bookingRef)async {
    try{
      _setHeader();
      Response response = await this.dio.put(this.baseURL + "Booking/TruckArrive/" + bookingRef);
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<String> renewToken()async {
    _setHeader();
    Response response = await this.dio.post(this.baseURL + "User/RenewToken");
    if(response.data["rstCode"] != 0)
      throw response.data["rstMsg"];
    await Util.sharedPreferences.setString("Authorization", response.data["rstData"]);
    return response.data["rstData"];
  }

  Future<List<News>> getLatestNews()async {
    try{
    _setHeader();
    Response response = await this.dio.get(this.baseURL + "LatestNews");
    if(response.data == "") return [];
      return (response.data as List<dynamic>).map((f) => News.fromJson(f)).toList();
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  Future<List<News>> logout()async {
    try{
    _setHeader();
    Response response = await this.dio.post(this.baseURL + "User/Logout");
    if(response.data["rstCode"] != 0)
      throw response.data["rstMsg"];
    }on DioError catch(e){
      throw e.message;
    }catch(e){
      throw e;
    }
  }

  void _setHeader(){
    this.dio.options.headers["Authorization"] = "bearer " + Util.sharedPreferences.getString("Authorization");
  }
}