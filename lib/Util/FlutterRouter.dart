import 'dart:convert';

import 'package:docking_project/Enum/VerificationType.dart';
import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/pages/ConfirmBookingPage.dart';
import 'package:docking_project/pages/CreateAccountSuccessPage.dart';
import 'package:docking_project/pages/FirstPage.dart';
import 'package:docking_project/pages/LoginPage.dart';
import 'package:docking_project/pages/MainPage.dart';
import 'package:docking_project/pages/NewBookingPage.dart';
import 'package:docking_project/pages/PhoneSignUpPage.dart';
import 'package:docking_project/pages/ScanQRCodePage.dart';
import 'package:docking_project/pages/VerificationPage.dart';
import 'package:docking_project/pages/BookingDetailPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class FlutterRouter extends BaseRouter {
  static final FlutterRouter _router = FlutterRouter._internal();
  FlutterRouter._internal();
  factory FlutterRouter.initialize() {
    return _router.init(_router) as FlutterRouter;
  }

  factory FlutterRouter() {
    return _router;
  }

  @override
  void configureRoutes() {
    this.fluroRouter.define("/" + Pages("FirstPage").getName(),
        handler: Handler(handlerFunc: (context, params) {
          return FirstPage();
        } ));
    this.fluroRouter.define("/" + Pages("VerificationPage").getName() + "/:tel/:countryCode/:verificationType/:verificationTimeString",
        handler: Handler(handlerFunc: (context, params) {
          return VerficiationPage(tel: params["tel"][0], countryCode: params["countryCode"][0], verificationTimeString: params["verificationTimeString"][0], verificationType: VerificationType.values.firstWhere((e) => e.toString() == params["verificationType"][0]));
        }));
    this.fluroRouter.define("/" + Pages("PhoneSignUpPage").getName(),
        handler: Handler(handlerFunc: (context, params) => PhoneSignUpPage()));
    this.fluroRouter.define("/" + Pages("CreateAccountSuccessPage/:verificationType").getName(),
        handler: Handler(
            handlerFunc: (context, params) {
              return CreateAccountSuccessPage(verificationType: VerificationType.values.firstWhere((e) => e.toString() == params["verificationType"][0]));
            }));
    this.fluroRouter.define("/" + Pages("MainPage").getName(),
        handler: Handler(handlerFunc: (context, params) => MainPage()));
    this.fluroRouter.define("/" + Pages("LoginPage").getName(),
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    this.fluroRouter.define("/" + Pages("BookingDetailPage").getName(),
        handler: Handler(handlerFunc: (context, params){
          final booking = context.settings.arguments as Booking;
          return BookingDetailPage(booking: booking,);
        }));
    this.fluroRouter.define("/" + Pages("NewBookingPage").getName() + "/:warehouse",
        handler: Handler(handlerFunc: (context, params){
          final shipmentList = context.settings.arguments as List<String>;
          return NewBookingPage(warehouseID: int.parse(params["warehouse"][0]), shipmentList:shipmentList,);
        }));
    this.fluroRouter.define("/" + Pages("ScanQRCodePage").getName(),handler: Handler(handlerFunc: (context, params) => ScanQRCodePage()));
    this.fluroRouter.define("/" + Pages("ConfirmBookingPage" + "/:truckTypeName").getName(),handler: Handler(handlerFunc: (context, params) {
      // final Booking booking = context.settings.arguments as Booking;
      final Map<String, dynamic> map = context.settings.arguments;
      return ConfirmBookingPage(booking: map["booking"], truckTypeName: params["truckTypeName"][0],timeSlot: map["timeSlot"],);
    }));
  }
}
