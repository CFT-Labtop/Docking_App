import 'dart:convert';

import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';

class CarTypeStandardField extends StatelessWidget {
  const CarTypeStandardField({
    Key key,
    @required this.textController,
    @required this.onPress,
    @required this.carType,
    @required this.truckTypeSelection,
  }) : super(key: key);

  final TextEditingController textController;
  final void Function(String carType) onPress;
  final String carType;
  final List<PickerItem> truckTypeSelection;

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter(data: this.truckTypeSelection),
        title: new Text("Please select your car type").tr(),
        hideHeader: true,
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          onPress(picker.getSelectedValues()[0]);
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return StandardTextField(
      textController: textController,
      hintText: "Enter Your Car Licence Number".tr(),
      textInputType: TextInputType.text,
      fontSize: Util.responsiveSize(context, 18),
      prefixOnPress: () {
        showPickerArray(context);
      },
      prefixWidget: Padding(
        padding: EdgeInsets.only(right: Util.responsiveSize(context, 12)),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.grey, width: 1.0))),
            child: Padding(
              padding: EdgeInsets.all(Util.responsiveSize(context, 10.0)),
              child: Text(
                carType,
                style: TextStyle(
                    color: UtilExtendsion.mainColor,
                    fontSize: Util.responsiveSize(context, 18)),
              ),
            )),
      ),
    );
  }
}
