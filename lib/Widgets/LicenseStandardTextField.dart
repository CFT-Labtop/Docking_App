import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';

class LicenseStandardTextField extends StatefulWidget {
  const LicenseStandardTextField({Key key, @required this.textController})
      : super(key: key);
  final TextEditingController textController;

  @override
  _LicenseStandardTextFieldState createState() =>
      _LicenseStandardTextFieldState();
}

class _LicenseStandardTextFieldState extends State<LicenseStandardTextField> {
  @override
  Widget build(BuildContext context) {
    return StandardTextFormField(
        textController: widget.textController,
        hintText: "Enter Your Car Licence Number".tr(),
        textInputType: TextInputType.text,
        fontSize: Util.responsiveSize(context, 18),
        validator: (text) {
        if(text.length > 8)
          return "License Number Cannot Be Larger Than 10 Characters".tr();
        return null;
      },);
  }
}
