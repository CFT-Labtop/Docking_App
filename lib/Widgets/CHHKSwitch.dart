import 'package:docking_project/Widgets/BaseSwitch.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CHHKSwitch extends StatefulWidget {
  final bool initValue;
  const CHHKSwitch({Key key, this.initValue}) : super(key: key);

  @override
  CHHKSwitchState createState() => CHHKSwitchState();
}

class CHHKSwitchState extends State<CHHKSwitch> {
  bool value;

  @override
  void initState() {
    this.value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, 18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Cross Border Vehicle".tr(),
            style: TextStyle(fontSize: Util.responsiveSize(context, 18)),
          ),
          BaseSwitch(initValue: widget.initValue, onChange: (bool value){
            this.value = value;
          },),
        ],
      ),
    );
  }
}
