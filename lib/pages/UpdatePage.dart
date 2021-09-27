import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({ Key key }) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  void initState() {
    UtilExtendsion.checkForUpdate(context, true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StandardElevatedButton(backgroundColor: UtilExtendsion.mainColor, text: "Version Update".tr(), onPress: (){
          launch("https://dkmsweb-prod.sunhinggroup.com/support");
        },
      ),
    ));
  }
}