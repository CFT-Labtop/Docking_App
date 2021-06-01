import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';

class VerficiationPage extends StatefulWidget {
  @override
  _VerficiationPageState createState() => _VerficiationPageState();
}

class _VerficiationPageState extends State<VerficiationPage> {
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
                  "Verification".tr(),
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SizedBox(height: Util.responsiveSize(context, 48),),
              Icon(
                Icons.verified_outlined,
                color: UtilExtendsion.mainColor,
                size: Util.responsiveSize(context, 120),
              ),
              SizedBox(height: Util.responsiveSize(context, 24),),
              Text("Verification".tr(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              SizedBox(height: Util.responsiveSize(context, 24),),
              
              Text("We will send you an".tr(), style: TextStyle(fontSize: 20, color: Colors.grey)),
            ],
          )),
        ),
      ),
    );
  }
}
