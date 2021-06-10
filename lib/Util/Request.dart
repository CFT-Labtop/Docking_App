import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Model/Warehouse.dart';
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
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }

  Future<List<Warehouse>> getWarehouse()async {
    try {
      this.dio.options.headers["Authorization"] = Util.sharedPreferences.getString("Authorization");
      Response response = await this.dio.get(this.baseURL + "Master/Warehouse");
      return (response.data as List<dynamic>).map((f) => Warehouse.fromJson(f)).toList();
    } on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> driverRegister({String mobileNumber, String countryCode , String carType, String license})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver", data: {
        "tel": mobileNumber,
        "countryCode": countryCode,
        "default_Truck_Type": carType ?? null,
        "default_Truck_No": license ?? null,
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      print("Verifiy Code " + response.data["rstData"]);
    }on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> verify({String countryCode, String tel , String verificationCode})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver/Verify", data: {
        "countryCode": countryCode,
        "tel": tel,
        "verificationCode": verificationCode,
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      await Util.sharedPreferences.setString("sharedPreferences", response.data["rstData"]);
    }on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }

  Future<void> login({String countryCode, String tel})async {
    try {
      Response response = await this.dio.post(this.baseURL + "Driver/Login", data: {
        "countryCode": countryCode,
        "tel": tel,
      });
      if(response.data["rstCode"] != 0)
        throw response.data["rstMsg"];
      print("Verifiy Code " + response.data["rstData"]);
    }on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }
}