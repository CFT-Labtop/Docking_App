import 'package:docking_project/Enum/VerificationType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = "852";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(fontColor: Colors.white, text: "Sign In".tr(), backgroundColor: UtilExtendsion.mainColor,),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: Util.responsiveSize(context, 40.0),
                  ),
                  Text(
                    "Enter Your Phone Number".tr(),
                    style: TextStyle(fontSize: Util.responsiveSize(context, 28)),
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 24.0),
                  ),
                  MobileStandardTextField(
                    countryCode: _countryCode,
                      mobileTextController: mobileTextController, onPress: (String countryCode) { 
                        setState(() {
                          _countryCode = countryCode;
                        });
                       },),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  Spacer(),
                  StandardElevatedButton(
                    backgroundColor: UtilExtendsion.mainColor,
                    text: "Next".tr(),
                    onPress: () async {
                      if (_formKey.currentState.validate()) {
                        try{
                          Util.showLoadingDialog(context);
                          await Request().login(countryCode: _countryCode, tel: mobileTextController.text);
                          Navigator.pop(context);
                          FlutterRouter().goToPage(context, Pages("VerificationPage"), parameters: "/" + mobileTextController.text + "/" + _countryCode + "/" + VerificationType.LOGIN.toString());
                        }catch(error){
                          Navigator.pop(context);
                          Util.showAlertDialog(context, error.toString());
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 48),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
