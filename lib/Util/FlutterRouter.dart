import 'package:docking_project/pages/CreateAccountSuccessPage.dart';
import 'package:docking_project/pages/FirstPage.dart';
import 'package:docking_project/pages/LoginPage.dart';
import 'package:docking_project/pages/MainPage.dart';
import 'package:docking_project/pages/PhoneSignUpPage.dart';
import 'package:docking_project/pages/VerificationPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class FlutterRouter extends BaseRouter{
  static final FlutterRouter _router = FlutterRouter._internal();
  FlutterRouter._internal();
  factory FlutterRouter.initialize(){
    return _router.init(_router) as FlutterRouter;
  }

  factory FlutterRouter() {
    return _router;
  }

  @override
  void configureRoutes() {
    this.fluroRouter.define("/" + Pages("FirstPage").getName(),
        handler: Handler(handlerFunc: (context, params) => FirstPage()));
    this.fluroRouter.define("/" + Pages("VerificationPage").getName(),
        handler: Handler(handlerFunc: (context, params) => VerficiationPage()));
    this.fluroRouter.define("/" + Pages("PhoneSignUpPage").getName(),
        handler: Handler(handlerFunc: (context, params) => PhoneSignUpPage()));
    this.fluroRouter.define("/" + Pages("CreateAccountSuccessPage").getName(),
      handler: Handler(handlerFunc: (context, params) => CreateAccountSuccessPage()));
    this.fluroRouter.define("/" + Pages("MainPage").getName(),
      handler: Handler(handlerFunc: (context, params) => MainPage()));
    this.fluroRouter.define("/" + Pages("LoginPage").getName(),
      handler: Handler(handlerFunc: (context, params) => LoginPage()));
    }
}