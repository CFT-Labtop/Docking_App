import 'dart:convert';

import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_picker/Picker.dart';
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
  void dispose() {
    mobileTextController.dispose();
    licenseTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: 'Sign Up'.tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: Util.responsiveSize(context, 40.0),
                ),
                Text(
                  "Enter Your Phone Number and Licence Number".tr(),
                  style: TextStyle(fontSize: Util.responsiveSize(context, 28)),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 24.0),
                ),
                MobileStandardTextField(
                    mobileTextController: mobileTextController),
                SizedBox(
                  height: Util.responsiveSize(context, 24.0),
                ),
                // ignore: missing_return
                CarTypeStandardField(
                  textController: licenseTextController,
                  carType: carType,
                  onPress: (String selectedCarType) {
                    setState(() {
                      carType = selectedCarType;
                    });
                  },
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                StandardElevatedButton(
                  backgroundColor: UtilExtendsion.mainColor,
                  text: "Next".tr(),
                  onPress: () {
                    FlutterRouter()
                        .goToPage(context, Pages("VerificationPage"));
                  },
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                Text(
                  "You may receive SMS for verification".tr(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: Util.responsiveSize(context, 16)),
                ),
                Spacer(),
                Divider(),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Already have an account?".tr(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: Util.responsiveSize(context, 16))),
                    TextSpan(
                        text: "Sign In".tr(),
                        style: TextStyle(
                            color: UtilExtendsion.mainColor,
                            decoration: TextDecoration.underline,
                            fontSize: Util.responsiveSize(context, 16)))
                  ]),
                )
              ],
            ))),
      ),
    );
  }
}
