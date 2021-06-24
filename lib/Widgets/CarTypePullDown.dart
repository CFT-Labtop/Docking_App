import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:easy_localization/easy_localization.dart';

class CarTypePullDown extends StatefulWidget {
  final List<PickerItem> truckTypeSelection;
  final String initValue;
  final Function(String selectedValue, String displayLabel) onSelected;
  CarTypePullDown({ Key key, this.truckTypeSelection, this.initValue, this.onSelected}) : super(key: key);

  @override
  CarTypePullDownState createState() => CarTypePullDownState();
}

class CarTypePullDownState extends State<CarTypePullDown> {
  String selectedValue;
  String selectedLabel;
  @override
  void initState() {
    selectedValue = widget.initValue;
    selectedLabel = StandardPullDown.getPickerValue(widget.truckTypeSelection, widget.initValue);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StandardPullDown(initValue: widget.initValue ?? null, pickerList: widget.truckTypeSelection, hintText: "Please select your car type".tr(), dialogTitle: "Please select your car type".tr(), onSelected: (value, String displayLabel) { 
        selectedValue = value;
        selectedLabel = displayLabel;
        if(widget.onSelected != null) widget.onSelected(selectedValue, selectedLabel);
     },);
  }
}