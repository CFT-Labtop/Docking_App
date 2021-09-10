import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:easy_localization/easy_localization.dart';

class ClientTypePullDown extends StatefulWidget {
  final List<PickerItem> clientTypeSelection;
  final int initValue;
  final Future<void> Function(int selectedValue, String displayLabel) onSelected;
  ClientTypePullDown({ Key key, this.clientTypeSelection, this.initValue, this.onSelected}) : super(key: key);

  @override
  ClientTypePullDownState createState() => ClientTypePullDownState();
}

class ClientTypePullDownState extends State<ClientTypePullDown> {
  int selectedValue;
  String selectedLabel;
  final _pulldownKey = GlobalKey<StandardPullDownState>();
  @override
  void initState() {
    selectedValue = widget.initValue;
    selectedLabel = StandardPullDown.getPickerValue(widget.clientTypeSelection, widget.initValue);
    super.initState();
  }

  bool isAnswerValid(){
    return (_pulldownKey.currentState != null && _pulldownKey.currentState.isAnswerValid());
  }

  @override
  Widget build(BuildContext context) {
    return StandardPullDown(key: _pulldownKey, initValue: widget.initValue ?? null, pickerList: widget.clientTypeSelection, hintText: "Please select client type".tr(), dialogTitle: "Please select client type".tr(), onSelected: (value, String displayLabel) async{ 
        selectedValue = value;
        selectedLabel = displayLabel;
        if(widget.onSelected != null) await widget.onSelected(selectedValue, selectedLabel);
     },);
  }
}