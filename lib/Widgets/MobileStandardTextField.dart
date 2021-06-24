import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';

class MobileStandardTextField extends StatefulWidget {
  MobileStandardTextField({
    Key key,
    @required this.mobileTextController, this.enable,
    @required this.onPress, this.initialPrefix,
   }) : super(key: key);

  final TextEditingController mobileTextController;
  final bool enable;
  final String initialPrefix;
  final void Function(String countryCode) onPress;

  @override
  MobileStandardTextFieldState createState() => MobileStandardTextFieldState();
}

class MobileStandardTextFieldState extends State<MobileStandardTextField> {
  String countryCode = "852";
  List<PickerItem> pickerList = [new PickerItem(text: Text("852"), value: "852"), new PickerItem(text: Text("86"), value: "86")];
  int selectedIndex;

  @override
  void initState() {
    countryCode = widget.initialPrefix ?? countryCode;
    selectedIndex = _findIndexBySelectedValue(countryCode, pickerList);
    super.initState();
  }
  showPickerArray(BuildContext context) {
    new Picker(
        selecteds: [selectedIndex],
        adapter: PickerDataAdapter(data: pickerList ),
        title: new Text("Please Select Country Code").tr(),
        hideHeader: true,
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          setState(() {
            String selectedValue = picker.getSelectedValues()[0]; 
            selectedIndex = _findIndexBySelectedValue(selectedValue, pickerList);
            widget.onPress(selectedValue);
            countryCode = selectedValue;
          });
        }).showDialog(context);
  }

  int _findIndexBySelectedValue(String value, List<PickerItem> pickerList){
    for(int i = 0; i < pickerList.length; i++){
      if(pickerList[i].value == value) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return StandardTextFormField(
      textController: widget.mobileTextController,
      hintText: "Enter Your Phone Number".tr(),
      textInputType: TextInputType.phone,
      validator: (text) {
        if(text == null || text.isEmpty)
          return "Mobile Number Cannot Be Empty".tr();
        if(countryCode == null || countryCode.isEmpty)
          return "Country Code Cannot Be Empty".tr();
        if(text.length > 20)
          return "Mobile Number Cannot Larger Than 20 Characters".tr();
        if (countryCode == "852" && text.length > 8)
          return "Hong Kong Mobile Number Cannot Larger Than 8 Characters".tr();
        return null;
      },
      fontSize: Util.responsiveSize(context, 18),
      enable: this.widget.enable,
      prefixOnPress: (){
        showPickerArray(context);
      },
      prefixWidget: Padding(
        padding:
            EdgeInsets.only(right: Util.responsiveSize(context, 12)),
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    right:
                        BorderSide(color: Colors.grey, width: 1.0))),
            child: Padding(
              padding:
                  EdgeInsets.all(Util.responsiveSize(context, 10.0)),
              child: Text(
                countryCode,
                style: TextStyle(
                    color: UtilExtendsion.mainColor,
                    fontSize: Util.responsiveSize(context, 18)),
              ),
            )),
      ),
    );
  }
}