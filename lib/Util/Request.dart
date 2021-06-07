import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Model/Warehouse.dart';
import 'package:flutter_basecomponent/BaseRequest.dart';
class Request extends BaseRequest{
  static final Request _request = Request._internal();
  Request._internal();
  factory Request() => _request;
  factory Request.initialize(String baseUrl) {
    return _request.init(baseUrl, _request) as Request;
  }

  Future<List<TruckType>> getTrunckType()async {
    try {
      this.dio.options.headers["Authorization"] = "64033357d7f1337b2b6de4a46694ffa15e550d8582e4e25cd3905cdfc61c449a10f33c2ed9e5cbb3540ade4b8a21fc4f1cb1b4b6a33e0213378c93ab26880930";
      Response response = await this.dio.get(this.baseURL + "TruckType");
      return (response.data as List<dynamic>).map((f) => TruckType.fromJson(f)).toList();
    } on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }

  Future<List<Warehouse>> getWarehouse()async {
    try {
      this.dio.options.headers["Authorization"] = "64033357d7f1337b2b6de4a46694ffa15e550d8582e4e25cd3905cdfc61c449a10f33c2ed9e5cbb3540ade4b8a21fc4f1cb1b4b6a33e0213378c93ab26880930";
      Response response = await this.dio.get(this.baseURL + "Warehouse");
      return (response.data as List<dynamic>).map((f) => Warehouse.fromJson(f)).toList();
    } on DioError catch(e){
      throw e.error.message;
    }catch(e){
      throw e;
    }
  }
}