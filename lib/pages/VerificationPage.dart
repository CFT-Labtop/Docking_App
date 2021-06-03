import 'dart:async';

import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:quiver/async.dart';

class VerficiationPage extends StatefulWidget {
  @override
  _VerficiationPageState createState() => _VerficiationPageState();
}

class _VerficiationPageState extends State<VerficiationPage> {
  int _current = 60;
  StreamSubscription sub;
  void startTimer() {
    if (sub != null) sub.cancel();
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: 60),
      new Duration(seconds: 1),
    );
    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = 60 - duration.elapsed.inSeconds;
      });
    });
    sub.onDone(() {
      sub.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: StandardAppBar( text: "Verification".tr(),backgroundColor: UtilExtendsion.mainColor, fontColor: Colors.white,),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: Util.responsiveSize(context, 48),
                ),
                Icon(
                  Icons.verified_outlined,
                  color: UtilExtendsion.mainColor,
                  size: Util.responsiveSize(context, 120),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 24),
                ),
                Text(
                  "Verification".tr(),
                  style: TextStyle(
                      fontSize: Util.responsiveSize(context, 32),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 12),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "We will send you an".tr(),
                          style: TextStyle(
                              fontSize: Util.responsiveSize(context, 20),
                              color: Colors.grey)),
                      TextSpan(
                          text: "One-time SMS".tr(),
                          style: TextStyle(
                              fontSize: Util.responsiveSize(context, 20),
                              color: UtilExtendsion.mainColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "on this mobile number".tr(),
                          style: TextStyle(
                              fontSize: Util.responsiveSize(context, 20),
                              color: Colors.grey))
                    ]),
                    // Text("We will send you an".tr(), style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 48),
                ),
                VerificationCode(
                  textStyle: TextStyle(
                      fontSize: Util.responsiveSize(context, 20), color: UtilExtendsion.mainColor),
                  underlineColor: UtilExtendsion.mainColor,
                  keyboardType: TextInputType.number,
                  itemSize: Util.responsiveSize(context, 50),
                  length: 6,
                  onCompleted: (String value) {
                    setState(() {
                      // _code = value;
                    });
                  },
                  onEditing: (bool value) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Code expires in:".tr(),
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                          text: _current.toString(),
                          style: TextStyle(color: Colors.red)),
                      TextSpan(
                          text: "second".tr(),
                          style: TextStyle(color: Colors.red)),
                    ])),
                SizedBox(
                  height: Util.responsiveSize(context, 12),
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Can't receive the SMS?".tr(),
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(text: " "),
                      TextSpan(
                          text: "Click here to resend SMS".tr(),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              startTimer();
                            },
                          style: TextStyle(
                              color: UtilExtendsion.mainColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ])),
                SizedBox(
                  height: Util.responsiveSize(context, 38),
                ),
                StandardElevatedButton(
                  backgroundColor: UtilExtendsion.mainColor,
                  text: "Next".tr(),
                  onPress: () {
                    FlutterRouter().goToPage(context, Pages("CreateAccountSuccessPage"));
                  },
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}
