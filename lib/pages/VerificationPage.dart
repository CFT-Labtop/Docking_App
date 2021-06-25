import 'dart:async';

import 'package:docking_project/Enum/VerificationType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:quiver/async.dart';

class VerficiationPage extends StatefulWidget {
  String tel;
  String countryCode;
  VerificationType verificationType;
  String verificationTimeString;

  VerficiationPage({Key key, this.tel, this.countryCode, this.verificationType, this.verificationTimeString})
      : super(key: key);

  @override
  _VerficiationPageState createState() => _VerficiationPageState();
}

class _VerficiationPageState extends State<VerficiationPage> {
  int _current = 60;
  String _verifiyCode = "";
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

  void submit() async {
    if (_current != 0) {
      try{
        Util.showLoadingDialog(context);
      if (_verifiyCode.length != 6) throw "Please Enter Verification Code".tr();
      await Request().verify(context,
          countryCode: widget.countryCode,
          tel: widget.tel,
          verificationCode: _verifiyCode,
          lang: context.locale);
      await UtilExtendsion.initDriver();
      Navigator.pop(context);
      FlutterRouter().goToPage(context, Pages("CreateAccountSuccessPage"),parameters: "/" + widget.verificationType.toString());
      }catch(error){
        Navigator.pop(context);
        Util.showAlertDialog(context, error.toString());
      }
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: "Verification".tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
      ),
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
                // Text(widget.verificationType.toString()),
                SizedBox(
                  height: Util.responsiveSize(context, 48),
                ),
                Icon(
                  Icons.verified_outlined,
                  color: UtilExtendsion.mainColor,
                  size: Util.responsiveSize(context, 120),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 36),
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
                  height: Util.responsiveSize(context, 12)
                ),
                Text("Sent Time".tr() + " " +widget.verificationTimeString, style: TextStyle(fontSize: Util.responsiveSize(context, 12), color: Colors.grey)),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                VerificationCode(
                  textStyle: TextStyle(
                      fontSize: Util.responsiveSize(context, 20),
                      color: UtilExtendsion.mainColor),
                  underlineColor: UtilExtendsion.mainColor,
                  keyboardType: TextInputType.number,
                  itemSize: Util.responsiveSize(context, 50),
                  length: 6,
                  onCompleted: (String value) {
                    setState(() {
                      _verifiyCode = value;
                      submit();
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
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: Util.responsiveSize(context, 20)),
                      ),
                      TextSpan(
                          text: _current.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: Util.responsiveSize(context, 20))),
                      TextSpan(
                          text: "second".tr(),
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: Util.responsiveSize(context, 20))),
                    ])),
                SizedBox(
                  height: Util.responsiveSize(context, 12),
                ),
                _current == 0
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Can't receive the SMS?".tr(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: Util.responsiveSize(context, 16))),
                          TextSpan(text: " "),
                          TextSpan(
                              text: "Click here to resend SMS".tr(),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  try {
                                    Util.showLoadingDialog(context);
                                    Map<String, dynamic> result = await Request().login(context, countryCode: widget.countryCode,tel: widget.tel);
                                    startTimer();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification Code is " +result["verificationCode"])));
                                    setState(() {
                                      widget.verificationTimeString = result["issueTimeString"];
                                    });
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Navigator.pop(context);
                                    Util.showAlertDialog(
                                        context, error.toString());
                                  }
                                },
                              style: TextStyle(
                                  color: UtilExtendsion.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Util.responsiveSize(context, 16),
                                  decoration: TextDecoration.underline)),
                        ]))
                    : SizedBox(),
                SizedBox(
                  height: Util.responsiveSize(context, 38),
                ),
                StandardElevatedButton(
                  backgroundColor:
                      _current == 0 ? Colors.grey : UtilExtendsion.mainColor,
                  text: _current == 0
                      ? "Please Resend Verification Code".tr()
                      : "Next".tr(),
                  onPress: () async {
                    submit();
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
