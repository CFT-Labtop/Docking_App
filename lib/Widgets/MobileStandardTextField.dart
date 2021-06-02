import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';

class MobileStandardTextField extends StatelessWidget {
  const MobileStandardTextField({
    Key key,
    @required this.mobileTextController,
  }) : super(key: key);

  final TextEditingController mobileTextController;

  @override
  Widget build(BuildContext context) {
    return StandardTextField(
      textController: mobileTextController,
      hintText: "Enter Your Phone Number".tr(),
      textInputType: TextInputType.phone,
      fontSize: Util.responsiveSize(context, 18),
      prefixWidget: Padding(
        padding:
            EdgeInsets.only(right: Util.responsiveSize(context, 12)),
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    right:
                        BorderSide(color: Colors.grey, width: 1.0))),
            child: Padding(
              padding:
                  EdgeInsets.all(Util.responsiveSize(context, 10.0)),
              child: Text(
                "HK +852",
                style: TextStyle(
                    color: UtilExtendsion.mainColor,
                    fontSize: Util.responsiveSize(context, 18)),
              ),
            )),
      ),
    );
  }
}
