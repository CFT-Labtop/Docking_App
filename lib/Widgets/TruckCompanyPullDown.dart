import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:easy_localization/easy_localization.dart';

class TruckCompanyPullDown extends StatefulWidget {
  final List<PickerItem> truckCompanySelection;
  final int initValue;
  final Future<void> Function(int selectedValue, String displayLabel) onSelected;
  TruckCompanyPullDown({ Key key, this.truckCompanySelection, this.initValue, this.onSelected}) : super(key: key);

  @override
  TruckCompanyPullDownState createState() => TruckCompanyPullDownState();
}

class TruckCompanyPullDownState extends State<TruckCompanyPullDown> {
  int selectedValue;
  String selectedLabel;
  final _pulldownKey = GlobalKey<StandardPullDownState>();
  @override
  void initState() {
    selectedValue = widget.initValue;
    selectedLabel = StandardPullDown.getPickerValue(widget.truckCompanySelection, widget.initValue);
    super.initState();
  }

  bool isAnswerValid(){
    return (_pulldownKey.currentState != null && _pulldownKey.currentState.isAnswerValid());
  }
  @override
  Widget build(BuildContext context) {
    return StandardPullDown(key: _pulldownKey, initValue: widget.initValue ?? null, pickerList: widget.truckCompanySelection, hintText: "Please Select Your Truck Company".tr(), dialogTitle: "Please Select Your Truck Company".tr(), onSelected: (value, String displayLabel) async{ 
        selectedValue = value;
        selectedLabel = displayLabel;
        if(widget.onSelected != null) await widget.onSelected(selectedValue, selectedLabel);
     },);
  }
}