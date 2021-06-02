import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:flutter_basecomponent/BaseRouter.dart';

class CreateAccountSuccessPage extends StatefulWidget {
  const CreateAccountSuccessPage({Key key}) : super(key: key);

  @override
  _CreateAccountSuccessPageState createState() =>
      _CreateAccountSuccessPageState();
}

class _CreateAccountSuccessPageState extends State<CreateAccountSuccessPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      FlutterRouter().goToPage(context, Pages("MainPage"), clear: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UtilExtendsion.mainColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              color: Colors.white,
              size: Util.responsiveSize(context, 100),
            ),
            SizedBox(
              height: Util.responsiveSize(context, 48),
            ),
            Text("Account Created Successfully".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Util.responsiveSize(context, 32)))
          ],
        ),
      ),
    );
  }
}
