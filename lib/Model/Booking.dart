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
  String bookingRef;
  String bookingDate;
  String bookingStatus;
  String driverID;
  String driverTel;
  String driverCountryCode;
  String timeSlot;
  String truckNo;
  String truckType;
  String truckCompanyName;
  bool deleted;
  List<String> shipmentList;
  String qrCodeString;
  String clientName;
  String bookingRemark;
  String bookingInternalRemark;

  Booking({
    this.warehouse,
    this.bookingRef,
    this.bookingDate,
    this.bookingStatus,
    this.driverID,
    this.driverTel,
    this.driverCountryCode,
    this.timeSlot,
    this.truckNo,
    this.truckType,
    this.truckCompanyName,
    this.deleted,
    this.shipmentList,
    this.qrCodeString,
    this.clientName,
    this.bookingRemark,
    this.bookingInternalRemark
  });

  Booking.fromJson(Map json){
    this.warehouse = json["warehouse"] ?? null;
    this.bookingRef = json ["bookingRef"] ?? null;
    this.bookingDate = json ["bookingDate"] ?? null;
    this.bookingStatus = json ["bookingStatus"] ?? null;
    this.driverID = json ["driverID"] ?? null;
    this.driverTel = json ["driverTel"] ?? null;
    this.driverCountryCode = json ["driverCountryCode"] ?? null;
    this.timeSlot = json ["timeSlot"] ?? null;
    this.truckNo = json ["truckNo"] ?? null;
    this.truckType = json ["truckType"] ?? null;
    this.truckCompanyName = json ["truckCompanyName"] ?? null;
    this.deleted = json ["deleted"] ?? true;
    this.shipmentList = json ["shipmentList"] ?? [];
    this.qrCodeString = json ["qrCodeString"] ?? null;
    this.clientName = json ["clientName"] ?? null;
    this.bookingRemark = json ["bookingRemark"] ?? null;
    this.bookingInternalRemark = json ["bookingInternalRemark"] ?? null;
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