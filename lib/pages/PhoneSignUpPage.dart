import 'package:docking_project/Enum/VerificationType.dart';
import 'package:docking_project/Model/TruckClient.dart';
import 'package:docking_project/Model/TruckCompany.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CHHKSwitch.dart';
import 'package:docking_project/Widgets/CarTypePullDown.dart';
import 'package:docking_project/Widgets/ClientTypePullDown.dart';
import 'package:docking_project/Widgets/LicenseStandardTextField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/TruckCompanyPullDown.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _carTypeKey = GlobalKey<CarTypePullDownState>();
  final _chhkTypeKey = GlobalKey<CHHKSwitchState>();
  final _mobileTextFieldKey = GlobalKey<MobileStandardTextFieldState>();
  final _truckCompanyKey = GlobalKey<TruckCompanyPullDownState>();
  final _truckClientKey = GlobalKey<ClientTypePullDownState>();
  List<PickerItem> truckTypeSelection = [];
  List<PickerItem> truckCompanySelection = [];
  List<PickerItem> truckClientSelection = [];
  bool isCHHK = false;

  @override
  void dispose() {
    mobileTextController.dispose();
    licenseTextController.dispose();
    super.dispose();
  }

  Future<void> getTruckType() async {
    try {
      List<TruckType> truckTypeList =await Request().getTrunckType(context, context.locale);
      List<TruckCompany> truckCompanyList = await Request().getTruckCompany(context, context.locale);
      List<TruckClient> truckClientList = await Request().getTruckClient(context, context.locale);
      this.truckTypeSelection =UtilExtendsion.getTruckTypeSelection(truckTypeList);
      this.truckCompanySelection =UtilExtendsion.getTruckCompanySelection(truckCompanyList);
      this.truckClientSelection =UtilExtendsion.getTruckClientSelection(truckClientList);
    } catch (e) {
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
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: getTruckType(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                  color: Colors.white,
                  child: SafeArea(
                      child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            // reverse: true,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Util.responsiveSize(context, 40.0),
                                ),
                                Text(
                                  "Enter Your Phone Number and Licence Number"
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          Util.responsiveSize(context, 28)),
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24.0),
                                ),
                                MobileStandardTextField(
                                  key: _mobileTextFieldKey,
                                  mobileTextController: mobileTextController,
                                  onPress: (String countryCode) {},
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24.0),
                                ),
                                Text(
                                  "Default Car - Optional".tr(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          Util.responsiveSize(context, 18)),
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 12),
                                ),
                                CarTypePullDown(
                                  truckTypeSelection: truckTypeSelection,
                                  key: _carTypeKey,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                ClientTypePullDown(clientTypeSelection: truckClientSelection, key: _truckClientKey,),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                TruckCompanyPullDown(truckCompanySelection: truckCompanySelection, key: _truckCompanyKey,),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: LicenseStandardTextField(
                                    textController: licenseTextController,
                                  ),
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 18),
                                ),
                                CHHKSwitch(
                                  initValue: false,
                                  key: _chhkTypeKey,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 32),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            StandardElevatedButton(
                              backgroundColor: UtilExtendsion.mainColor,
                              text: "Next".tr(),
                              onPress: () async {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    Util.showLoadingDialog(context);
                                    Map<String, dynamic> result =
                                        await Request().driverRegister(context,
                                            countryCode: _mobileTextFieldKey.currentState.countryCode,
                                            mobileNumber:mobileTextController.text,
                                            license: licenseTextController.text,
                                            carType: _carTypeKey.currentState.selectedValue,
                                            lang: context.locale,
                                            isChHKTruck: _chhkTypeKey.currentState.value,
                                            clientID: _truckClientKey.currentState.selectedValue,
                                            companyID: _truckCompanyKey.currentState.selectedValue
                                          );
                                    Navigator.pop(context);
                                    if (result
                                            .containsKey("verificationCode") &&
                                        result["verificationCode"] != null)
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Verification Code is " +
                                                      result[
                                                          "verificationCode"])));
                                    FlutterRouter().goToPage(
                                        context, Pages("VerificationPage"),
                                        parameters: "/" +
                                            mobileTextController.text +
                                            "/" +
                                            _mobileTextFieldKey
                                                .currentState.countryCode +
                                            "/" +
                                            VerificationType.REGISTER
                                                .toString() +
                                            "/" +
                                            result["issueTimeString"]);
                                  } catch (error) {
                                    Navigator.pop(context);
                                    Util.showAlertDialog(
                                        context, error.toString());
                                  }
                                }
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
                            Divider(),
                            GestureDetector(
                              onTap: () {
                                FlutterRouter()
                                    .goToPage(context, Pages("LoginPage"));
                              },
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Already have an account?".tr(),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: Util.responsiveSize(
                                              context, 16))),
                                  TextSpan(
                                      text: "Sign In".tr(),
                                      style: TextStyle(
                                          color: UtilExtendsion.mainColor,
                                          decoration: TextDecoration.underline,
                                          fontSize:
                                              Util.responsiveSize(context, 16)))
                                ]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ))),
            );
          });
        },
      ),
    );
  }
}
