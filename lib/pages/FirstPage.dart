import 'dart:io';

import 'package:docking_project/Model/News.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Widgets/IntroductionSwiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_basecomponent/Widgets/StandardOutlinedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Future futureBuilder;
  List<News> newsList = [];
  Widget header() {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: Util.responsiveSize(context, 80),
            ),
            SizedBox(
              height: Util.responsiveSize(context, 10),
            ),
            Text(
              "Dock Booking System",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Util.responsiveSize(context, 25.0),
                  fontWeight: FontWeight.bold,
                  color: UtilExtendsion.mainColor),
            ).tr(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        futureBuilder = getNews();
      });
    });
    super.initState();
    UtilExtendsion.checkForUpdate(context);
  }

  Future<void> getNews() async {
    newsList = await Request().getLatestNews(context, context.locale);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xff94050c), Color(0xfff13e4a)],
          )),
          child: SafeArea(
            bottom: false,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: header()),
                  SizedBox(
                    height: Util.responsiveSize(context, 50),
                  ),
                  Text(
                    "Ready to get stuff done?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Util.responsiveSize(context, 20)),
                  ).tr(),
                  FutureBuilder(
                      future: futureBuilder,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
                          return Expanded(
                            flex: 2,
                            child: Container(
                              child: IntroductionSwiper(listComponents: List<SwiperComponent>.generate(newsList.length, (index) => SwiperComponent(newsList[index])),),
                            ),
                          );
                        },loadingCallBack: (){
                          return Expanded(flex: 2, child: Center(child: PlatformCircularProgressIndicator(),));
                        });
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Util.responsiveSize(
                            context, Util.responsiveSize(context, 32))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StandardOutlinedButton(
                          text: "Sign Up".tr(),
                          onPress: () {
                            FlutterRouter()
                                .goToPage(context, Pages("PhoneSignUpPage"));
                          },
                        ),
                        StandardOutlinedButton(
                          text: "Sign In".tr(),
                          onPress: () {
                            FlutterRouter()
                                .goToPage(context, Pages("LoginPage"));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Util.responsiveSize(context, 24.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Util.responsiveSize(context, 48.0)),
                    child: GestureDetector(
                      onTap: (){
                        launch("https://dkmsweb-prod.sunhinggroup.com/TermsAndConditions");
                      },
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: "By signing up, you agree to our".tr(),
                                style: TextStyle(
                                    fontSize: Util.responsiveSize(context, 14))),
                            TextSpan(text: " "),
                          TextSpan(
                              text: "Terms of Service".tr(),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: Util.responsiveSize(context, 14)),
                            ),
                            TextSpan(text: " "),
                            TextSpan(
                                text: "and".tr(),
                                style: TextStyle(
                                    fontSize: Util.responsiveSize(context, 14))),
                            TextSpan(text: " "),
                            TextSpan(
                                text: "Privacy Policy".tr(),
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: Util.responsiveSize(context, 14))),
                          ])),
                    ),
                  ),
                  SizedBox(height: Util.responsiveSize(context, 8.0)),
                  Text(
                    "Version 1.0.5",
                    style: TextStyle(
                        fontSize: Util.responsiveSize(context, 14),
                        color: Colors.white),
                  ),
                  SizedBox(height: Util.responsiveSize(context, 32.0)),
                ]),
          )),
    );
  }
}
