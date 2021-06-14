import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';

class CarTypeStandardField extends StatefulWidget {
  const CarTypeStandardField({
    Key key,
    @required this.textController,
    @required this.onPress,
    @required this.truckTypeSelection, this.initCarType,
  }) : super(key: key);

  final TextEditingController textController;
  final void Function(String carType) onPress;
  final List<PickerItem> truckTypeSelection;
  final String initCarType;

  @override
  CarTypeStandardFieldState createState() => CarTypeStandardFieldState();
}

class CarTypeStandardFieldState extends State<CarTypeStandardField> {
  String carType;

  @override
  void initState() {
    carType = widget.initCarType ?? "";
    super.initState();
  }
  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter(data: this.widget.truckTypeSelection),
        title: new Text("Please select your car type").tr(),
        hideHeader: true,
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          setState(() {
            String selectedValue = picker.getSelectedValues()[0];
            carType = selectedValue;
            widget.onPress(selectedValue);
          });
        }).showDialog(context);
  }

  String getNameByType(String value){
    try{
      Text widget = this.widget.truckTypeSelection.firstWhere((element) => element.value == value).text as Text;
      return widget.data;
    }catch(error){
      return "Car Type".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StandardTextFormField(
      textController: widget.textController,
      hintText: "Enter Your Car Licence Number".tr(),
      textInputType: TextInputType.text,
      fontSize: Util.responsiveSize(context, 18),
      prefixOnPress: () {
        showPickerArray(context);
      },
      prefixWidget: Padding(
        padding: EdgeInsets.only(right: Util.responsiveSize(context, 12)),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.grey, width: 1.0))),
            child: Padding(
              padding: EdgeInsets.all(Util.responsiveSize(context, 10.0)),
              child: Text(
                getNameByType(carType) ?? "Car Type".tr(),
                style: TextStyle(
                    color: UtilExtendsion.mainColor,
                    fontSize: Util.responsiveSize(context, 18)),
              ),
            )),
      ),
    );
  }
}
