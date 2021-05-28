import 'package:docking_project/pages/LoginPage.dart';
import 'package:docking_project/pages/VerificationPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class FlutterRouter extends BaseRouter{
  static final FlutterRouter _router = FlutterRouter._internal();
  FlutterRouter._internal();
  factory FlutterRouter() {
    return _router.init(_router) as FlutterRouter;
  }
  @override
  void configureRoutes() {
    fluroRouter.define("/" + Pages.LoginPage.toString(),
        handler: Handler(handlerFunc: (context, params) => LoginPage()));
    fluroRouter.define("/" + Pages.VerificationPage.toString(),
        handler: Handler(handlerFunc: (context, params) => VerficiationPage()));
    }
}

enum Pages {
  LoginPage,
  VerificationPage
}