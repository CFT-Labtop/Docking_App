// class Booking{
//   final DateTime bookingTime;
//   final String warehouse;
//   final String license;
//   final String carType;
//   final BookingStatus status;

//   const Booking({
//     this.bookingTime,
//     this.warehouse,
//     this.license,
//     this.carType,
//     this.status,
//   });

// }
 
// enum BookingStatus{
//   ARRIVED,
//   PENDING,
//   EXPIRED
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Booking{
  String warehouse;
  int warehouseID;
  String bookingRef;
  String bookingDate;
  String bookingStatus;
  String driverID;
  String driverTel;
  String driverCountryCode;
  String timeSlotID;
  String timeSlot;
  String truckNo;
  String truckType;
  int truckCompanyID;
  String truckCompanyName;
  bool deleted;
  List<String> shipmentList;
  String qrCodeString;
  int clientID;
  String clientName;
  String bookingRemark;
  String bookingInternalRemark;
  bool isNegative;
  bool isChHKTruck;
  int timeSlotUsage;
  String bookingStatusCode;
  String truckTypeName;
  String updatedDate;
  String updatedBy;
  int recID;
  bool unloading;
  double latitude;
  double longitude;
  String bookingMsg;
  bool priorityOrder;

  Booking({
    this.warehouse,
    this.warehouseID,
    this.bookingRef,
    this.bookingDate,
    this.bookingStatus,
    this.driverID,
    this.driverTel,
    this.driverCountryCode,
    this.timeSlotID,
    this.timeSlot,
    this.truckNo,
    this.truckType,
    this.truckCompanyID,
    this.truckCompanyName,
    this.deleted,
    this.shipmentList,
    this.qrCodeString,
    this.clientID,
    this.clientName,
    this.bookingRemark,
    this.bookingInternalRemark,
    this.isNegative,
    this.isChHKTruck,
    this.timeSlotUsage,
    this.bookingStatusCode,
    this.truckTypeName,
    this.updatedDate,
    this.updatedBy,
    this.recID,
    this.unloading,
    this.latitude,
    this.longitude,
    this.bookingMsg,
    this.priorityOrder
  });

  Booking.fromJson(Map json){
    this.warehouse = json["warehouse"] ?? null;
    this.warehouseID = json["warehouseID"] ?? null;
    this.bookingRef = json ["bookingRef"] ?? null;
    this.bookingDate = json ["bookingDate"] ?? null;
    this.bookingStatus = json ["bookingStatus"] ?? null;
    this.driverID = json ["driverID"] ?? null;
    this.driverTel = json ["driverTel"] ?? null;
    this.driverCountryCode = json ["driverCountryCode"] ?? null;
    this.timeSlotID = json ["timeSlotID"] ?? null;
    this.timeSlot = json ["timeSlot"] ?? null;
    this.truckNo = json ["truckNo"] ?? null;
    this.truckType = json ["truckType"] ?? null;
    this.truckCompanyID = json ["truckCompanyID"] ?? null;
    this.truckCompanyName = json ["truckCompanyName"] ?? null;
    this.deleted = _convertIntToBool(json ["deleted"]);
    List<dynamic> shipmentList = json ["shipmentList"] as List<dynamic> ?? [];
    this.shipmentList = shipmentList.map((e) => e.toString()).toList();
    this.qrCodeString = json ["qrCodeString"] ?? null;
    this.clientID = json ["clientID"] ?? null;
    this.clientName = json ["clientName"] ?? null;
    this.bookingRemark = json ["bookingRemark"] ?? null;
    this.bookingInternalRemark = json ["bookingInternalRemark"] ?? null;
    this.isNegative = json ["isNegative"];
    this.isChHKTruck = json ["isChHKTruck"];
    this.timeSlotUsage = json ["timeSlotUsage"] ?? 0;
    this.bookingStatusCode = json ["bookingStatusCode"] ?? null;
    this.truckTypeName = json ["truckTypeName"] ?? null;
    this.updatedDate = json ["updatedDate"] ?? null;
    this.updatedBy = json ["updatedBy"] ?? null;
    this.recID = json ["recID"] ?? null;
    this.unloading = json ["unloading"] ?? null;
    this.latitude = json["latitude"].toDouble() ?? null;
    this.longitude = json["longitude"].toDouble() ?? null;
    this.bookingMsg = json["bookingMsg"] ?? null;
    this.priorityOrder = json ["priorityOrder"];
  }

  bool _convertIntToBool(int value){
    if(value == null) return false;
    return value == 1;
  }

  String displayBookingDate(){
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(bookingDate));
  }

  String showTruckAndLicense(){
    return this.truckType +"(" +this.truckNo +")";
  }

}
 
enum BookingStatus{
  ARRIVED,
  PENDING
}