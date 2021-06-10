import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';

class MobileStandardTextField extends StatelessWidget {
  const MobileStandardTextField({
    Key key,
    @required this.mobileTextController, this.enable,
    @required this.onPress, this.countryCode = "852",
  }) : super(key: key);

  final TextEditingController mobileTextController;
  final bool enable;
  final void Function(String countryCode) onPress;
  final String countryCode;

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter(data: [new PickerItem(text: Text("852"), value: "852"), new PickerItem(text: Text("86"), value: "86")] ),
        title: new Text("Please Select Country Code").tr(),
        hideHeader: true,
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          onPress(picker.getSelectedValues()[0]);
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return StandardTextFormField(
      textController: mobileTextController,
      hintText: "Enter Your Phone Number".tr(),
      textInputType: TextInputType.phone,
      validator: (text) {
        if(text == null || text.isEmpty)
          return "Mobile Number Cannot Be Empty".tr();
        if(countryCode == null || countryCode.isEmpty)
          return "Country Code Cannot Be Empty".tr();
        return null;
      },
      fontSize: Util.responsiveSize(context, 18),
      enable: this.enable,
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
