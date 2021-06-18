import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:easy_localization/easy_localization.dart';

class WarehousePullDown extends StatefulWidget {
  final int initValue;
  final List<PickerItem> warehouseSelection;
  const WarehousePullDown({ Key key, this.initValue, this.warehouseSelection }) : super(key: key);

  @override
  WarehousePullDownState createState() => WarehousePullDownState();
}

class WarehousePullDownState extends State<WarehousePullDown> {
  int selectedValue;
  String selectedLabel;
  @override
  void initState() {
    selectedValue = widget.initValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StandardPullDown(initValue: widget.initValue, pickerList: widget.warehouseSelection, hintText: "Please Select Warehouse".tr(), dialogTitle: "Please Select Warehouse".tr(), onSelected: (value, String displayLabel) { 
        selectedValue = value;
        selectedLabel = displayLabel;
     },);
  }
}