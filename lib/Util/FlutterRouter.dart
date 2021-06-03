import 'package:docking_project/pages/LoginPage.dart';
import 'package:docking_project/pages/PhoneSignUpPage.dart';
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
    this.fluroRouter.define("/" + Pages("LoginPage").getName(),
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    this.fluroRouter.define("/" + Pages("VerificationPage").getName(),
        handler: Handler(handlerFunc: (context, params) => VerficiationPage()));
    this.fluroRouter.define("/" + Pages("PhoneSignUpPage").getName(),
        handler: Handler(handlerFunc: (context, params) => PhoneSignUpPage()));
    this.fluroRouter.define("/" + Pages("BookingDetailPage").getName(),
        handler:
            Handler(handlerFunc: (context, params) => BookingDetailPage()));
  }
}
