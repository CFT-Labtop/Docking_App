import 'dart:convert';

import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/flutter_picker.dart';

class StandardPullDown extends StatefulWidget {
  const StandardPullDown(
      {Key key,
      this.textController,
      this.hintText,
      @required this.pickerList,
      this.dialogTitle,
      @required this.onSelected})
      : super(key: key);
  final TextEditingController textController;
  final String hintText;
  final List<PickerItem> pickerList;
  final String dialogTitle;
  final void Function(dynamic value, String displayLabel) onSelected;

  @override
  _StandardPullDownState createState() => _StandardPullDownState();
}

class _StandardPullDownState extends State<StandardPullDown> {
  showPickerArray(BuildContext context) {
    new Picker(
        columnPadding: EdgeInsets.symmetric(horizontal: 0),
        adapter: PickerDataAdapter(data: widget.pickerList),
        hideHeader: true,
        title: new Text(widget.dialogTitle ?? "Please Select".tr()),
        textStyle: TextStyle(
            color: Colors.black, fontSize: Util.responsiveSize(context, 19)),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          setState(() {
            var selectedValue = picker.getSelectedValues()[0];
            widget.onSelected(selectedValue, getNameByValue(selectedValue));
          });
        }).showDialog(context);
  }

  String getNameByValue(dynamic value){
    try{
      Text textWidget = widget.pickerList.firstWhere((element) => element.value == value).text as Text;
      return textWidget.data;
    }catch(error){
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showPickerArray(context);
        },
        child: StandardTextFormField(
          textController: widget.textController,
          fontSize: Util.responsiveSize(context, 18),
          hintText: widget.hintText,
          enable: false,
        ));
  }
}
