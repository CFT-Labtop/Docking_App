import 'dart:convert';

import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
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
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PhoneSignUpPage extends StatefulWidget {
  @override
  _PhoneSignUpPageState createState() => _PhoneSignUpPageState();
}

class _PhoneSignUpPageState extends State<PhoneSignUpPage> {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController licenseTextController = TextEditingController();
  List<PickerItem> truckTypeSelection;
  String carType = "車型";

  @override
  void dispose() {
    mobileTextController.dispose();
    licenseTextController.dispose();
    super.dispose();
  }

  Future<void> getTruckType() async{
    try{
      List<TruckType> truckTypeList = await Request().getTrunckType();
      this.truckTypeSelection = truckTypeList.map((e) => new PickerItem(text: Text(e.typeName_Ch), value: e.typeName_Ch)).toList();
    }catch(e){
      throw e;
    }
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
      body: FutureBuilder(
        future: getTruckType(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: Util.responsiveSize(context, 24)),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
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
                        style: TextStyle(
                            fontSize: Util.responsiveSize(context, 28)),
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 24.0),
                      ),
                      MobileStandardTextField(
                          mobileTextController: mobileTextController),
                      SizedBox(
                        height: Util.responsiveSize(context, 24.0),
                      ),
                      Text(
                        "Default Car - Optional".tr(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: Util.responsiveSize(context, 18)),
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 12),
                      ),
                      CarTypeStandardField(
                        textController: licenseTextController,
                        carType: carType,
                        onPress: (String selectedCarType) {
                          setState(() {
                            carType = selectedCarType;
                          });
                        }, truckTypeSelection: this.truckTypeSelection,
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
            );
          } else {
            return Center(child: PlatformCircularProgressIndicator());
          }
        },
      ),
    );
  }
}
