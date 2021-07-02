import 'dart:convert';

import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/flutter_picker.dart';

class StandardPullDown extends StatefulWidget {
  const StandardPullDown(
      {Key key,
      this.hintText,
      @required this.pickerList,
      this.dialogTitle,
      @required this.onSelected,
      this.initValue})
      : super(key: key);
  final String hintText;
  final List<PickerItem> pickerList;
  final String dialogTitle;
  final void Function(dynamic value, String displayLabel) onSelected;
  final dynamic initValue;

  @override
  StandardPullDownState createState() => StandardPullDownState();
  static String getPickerValue(List<PickerItem> pickerList, dynamic value) {
    try {
      Text textWidget = pickerList
          .firstWhere((element) => element.value == value)
          .text as Text;
      return textWidget.data;
    } catch (error) {
      return "";
    }
  }
}

class StandardPullDownState extends State<StandardPullDown> {
  dynamic selectedValue;
  int selectedIndex;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    setValue(widget.initValue);
    super.initState();
  }

  int _findIndexBySelectedValue(dynamic value, List<PickerItem> pickerList){
    for(int i = 0; i < pickerList.length; i++){
      if(pickerList[i].value == value) return i;
    }
    return 0;
  }

  showPickerArray(BuildContext context) {
    new Picker(
        columnPadding: EdgeInsets.symmetric(horizontal: 0),
        adapter: PickerDataAdapter(data: widget.pickerList),
        hideHeader: true,
        selecteds: [selectedIndex],
        title: new Text(widget.dialogTitle ?? "Please Select".tr()),
        textStyle: TextStyle(
            color: Colors.black, fontSize: Util.responsiveSize(context, 19)),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          selectedValue = picker.getSelectedValues()[0];
          selectedIndex = _findIndexBySelectedValue(selectedValue, widget.pickerList);
          textController.text = getNameByValue(selectedValue);
          widget.onSelected(selectedValue, textController.text);
        }).showDialog(context);
  }

  String getNameByValue(dynamic value) {
    try {
      Text textWidget = widget.pickerList
          .firstWhere((element) => element.value == value)
          .text as Text;
      return textWidget.data;
    } catch (error) {
      return "";
    }
  }

  void setValue(dynamic value){
    setState(() {
      selectedValue = value;
      textController.text = getNameByValue(selectedValue);
      selectedIndex = _findIndexBySelectedValue(selectedValue, widget.pickerList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showPickerArray(context);
        },
        child: StandardTextFormField(
          textController: textController,
          fontSize: Util.responsiveSize(context, 18),
          hintText: widget.hintText,
          enable: false,
        ));
  }
}
