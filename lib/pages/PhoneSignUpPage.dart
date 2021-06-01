import 'dart:convert';

import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class PhoneSignUpPage extends StatefulWidget {
  @override
  _PhoneSignUpPageState createState() => _PhoneSignUpPageState();
}

class _PhoneSignUpPageState extends State<PhoneSignUpPage> {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController licenseTextController = TextEditingController();
  String carType = "車型";
  //TODO Picker Should Have Label and Value And Clear Function
  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata:
                new JsonDecoder().convert("[[\"小型車輛\",\"中型車輛\",\"大型車輛\"]]"),
            isArray: true),
        hideHeader: true,
        title: new Text("Please select your car type").tr(),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          setState(() {
            carType = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
                child: Column(
              children: [
                PlatformAppBar(
                  title: Text(
                    "Sign Up".tr(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 40.0),
                ),
                Text(
                  "Enter Your Phone Number and Licence Number".tr(),
                  style: TextStyle(fontSize: 28.0),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 24.0),
                ),
                StandardTextField(
                  textController: mobileTextController,
                  hintText: "Enter Your Phone Number".tr(),
                  textInputType: TextInputType.phone,
                  fontSize: 18.0,
                  prefixWidget: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(color: Colors.grey, width: 1.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "HK +852",
                            style: TextStyle(color: UtilExtendsion.mainColor, fontSize: 18.0),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 24.0),
                ),
                StandardTextField(
                  textController: licenseTextController,
                  hintText: "Enter Your Car Licence Number".tr(),
                  fontSize: 18.0,
                  prefixOnPress: () {
                    showPickerArray(context);
                  },
                  prefixWidget: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(color: Colors.grey, width: 1.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            carType,
                            style: TextStyle(color: UtilExtendsion.mainColor, fontSize: 18.0),
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                StandardElevatedButton(
                  backgroundColor: UtilExtendsion.mainColor,
                  text: "Next".tr(),
                  onPress: (){
                    FlutterRouter().goToPage(context, Pages("VerificationPage"));
                  },
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                Text(
                  "You may receive SMS for verification".tr(),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Spacer(),
                Divider(),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Already have an account?".tr(),
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                    TextSpan(
                      text: "Sign In".tr(),
                      style: TextStyle(color: UtilExtendsion.mainColor, decoration: TextDecoration.underline,fontSize: 16)
                    )
                  ]),
                )
              ],
            ))),
      ),
    );
  }
}