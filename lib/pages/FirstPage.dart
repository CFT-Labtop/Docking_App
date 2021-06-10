import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Widgets/IntroductionSwiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_basecomponent/Widgets/StandardOutlinedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Widget header() {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        color: Colors.white,
        child: Center(
            child: Text(
          "Dock Booking System",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: Util.responsiveSize(context, 40.0),
              fontWeight: FontWeight.bold,
              color: UtilExtendsion.mainColor),
        ).tr()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: UtilExtendsion.mainColor,
          width: double.infinity,
          child: SafeArea(
            bottom: false,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: header()),
                  SizedBox(
                    height: Util.responsiveSize(context, 34),
                  ),
                  Text(
                    "Ready to get stuff done?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: Util.responsiveSize(context, 20)),
                  ).tr(),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: IntroductionSwiper(listComponents: [
                        SwiperComponent(
                            "Introduction Script".tr(), Icons.aod_outlined),
                        SwiperComponent("Introduction Script".tr(),
                            Icons.account_circle_outlined),
                        SwiperComponent("Introduction Script".tr(),
                            Icons.add_comment_outlined)
                      ]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Util.responsiveSize(context,Util.responsiveSize(context, 48))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StandardOutlinedButton(
                          text: "Sign Up".tr(),
                          onPress: (){
                            FlutterRouter().goToPage(context, Pages("PhoneSignUpPage"));
                          },
                        ),
                        StandardOutlinedButton(
                          text: "Sign In".tr(),
                          onPress: (){
                            FlutterRouter().goToPage(context, Pages("LoginPage"));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Util.responsiveSize(context, 24.0)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Util.responsiveSize(context, 48.0)),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "By signing up, you agree to our".tr(), style: TextStyle(fontSize: Util.responsiveSize(context, 14))),
                          TextSpan(text: " "),
                          TextSpan(
                            text: "Terms of Service".tr(),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: Util.responsiveSize(context, 14)
                            ),
                          ),
                          TextSpan(text: " "),
                          TextSpan(text: "and".tr() ,style: TextStyle(fontSize: Util.responsiveSize(context, 14))),
                          TextSpan(text: " "),
                          TextSpan(
                              text: "Privacy Policy".tr(),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: Util.responsiveSize(context, 14)
                              )),
                        ])),
                  ),
                  SizedBox(height: Util.responsiveSize(context, 48.0))
                ]),
          )),
    );
  }
}
