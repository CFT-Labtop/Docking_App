import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class SettingFragment extends StatefulWidget {
  const SettingFragment({Key key}) : super(key: key);

  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController licenseTextController = TextEditingController();
  String carType = "車型";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileTextController.text = "12345678";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: Util.responsiveSize(context, 24),
            ),
            Text(
              "Read Only".tr(),
              style: TextStyle(
                  color: Colors.grey, fontSize: Util.responsiveSize(context, 18)),
            ),
            SizedBox(
              height: Util.responsiveSize(context, 24),
            ),
            MobileStandardTextField(
              mobileTextController: mobileTextController,
              enable: false,
            ),
            SizedBox(
              height: Util.responsiveSize(context, 24),
            ),
            Text(
              "Default Car - Optional".tr(),
              style: TextStyle(
                  color: Colors.grey, fontSize: Util.responsiveSize(context, 18)),
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
              },
            ),
            Expanded(
              child: SizedBox(),
            ),
            StandardElevatedButton(
              backgroundColor: UtilExtendsion.mainColor,
              text: "Submit".tr(),
              onPress: () {
                
              },
            ),
            SizedBox(
              height: Util.responsiveSize(context, 12),
            )
          ],
        ),
      ),
    );
  }
}
