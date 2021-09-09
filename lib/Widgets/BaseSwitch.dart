import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:easy_localization/easy_localization.dart';

class BaseSwitch extends StatelessWidget {
  final bool initValue;
  final void Function(bool value) onChange;
  const BaseSwitch({Key key, this.initValue = false, this.onChange}) : super(key: key);

  bool _convertIndexToBool(int index){
    return index == 0 ? false : true;
  }


  int _convertBoolToIndex(bool value){
    return value ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 90.0,
      cornerRadius: 20.0,
      activeBgColors: [
        [Colors.red[800]],
        [Colors.green[800]]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      initialLabelIndex: _convertBoolToIndex(this.initValue),
      totalSwitches: 2,
      labels: ['No'.tr(), 'Yes'.tr()],
      radiusStyle: true,
      onToggle: (index) {
        this.onChange(_convertIndexToBool(index));
      },
    );
  }
}
