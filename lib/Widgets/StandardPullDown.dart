import 'dart:convert';

import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/flutter_picker.dart';

class StandardPullDown extends StatefulWidget {
  const StandardPullDown({Key key, this.textController, this.hintText, @required this.arraySelection, this.dialogTitle, @required this.onSelected}) : super(key: key);
  final TextEditingController textController;
  final String hintText;
  final String arraySelection;
  final String dialogTitle;
  final void Function(String value) onSelected;

  @override
  _StandardPullDownState createState() => _StandardPullDownState();
}

class _StandardPullDownState extends State<StandardPullDown> {
  showPickerArray(BuildContext context) {
    new Picker(
      columnPadding: EdgeInsets.symmetric(horizontal: 0),
            adapter: PickerDataAdapter<String>(
                pickerdata:
                    new JsonDecoder().convert(widget.arraySelection),
                isArray: true),
            hideHeader: true,
            title: new Text(widget.dialogTitle ?? "Please Select".tr()),
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: Util.responsiveSize(context, 19)
            ),
            cancelText: "Cancel".tr(),
            confirmText: "Confirm".tr(),
            onConfirm: (Picker picker, List value) {
              setState(() {
                widget.onSelected(picker.getSelectedValues()[0]);
              });
            })
        .showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showPickerArray(context);
        },
        child: StandardTextField(
          textController: widget.textController,
          fontSize: Util.responsiveSize(context, 18),
          hintText: widget.hintText,
          enable: false,
        ));
  }
}
