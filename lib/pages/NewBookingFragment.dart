import 'dart:convert';

import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:docking_project/Widgets/TimeSlotBox.dart';
import 'package:docking_project/Widgets/TimeSlotGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewBookingFragment extends StatefulWidget {
  const NewBookingFragment({Key key}) : super(key: key);

  @override
  _NewBookingFragmentState createState() => _NewBookingFragmentState();
}

class _NewBookingFragmentState extends State<NewBookingFragment> {
  String _carType = "車型";
  final TextEditingController licenseTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();

  showPickerArray(BuildContext context) {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder()
                .convert("[[\"2021年10月1日\",\"2021年10月2日\",\"2021年10月3日\"]]"),
            isArray: true),
        hideHeader: true,
        title: new Text("Please select your car type").tr(),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          setState(() {
            timeTextController.text = picker.getSelectedValues()[0];
          });
        }).showDialog(context);
  }

  showDateDialog() {
    DateTime selectedDate = DateTime.now();
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Please Select Date'.tr()),
        content: Container(
            height: Util.responsiveSize(context, 400),
            child: SfDateRangePicker(
              initialSelectedDate: DateTime.now(),
              enablePastDates: false,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                selectedDate = args.value as DateTime;
              },
              monthViewSettings: DateRangePickerMonthViewSettings(
                blackoutDates: <DateTime>[
                  // DateTime.utc(2021, 6, 12)
                ],
              ),
            )),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText("Cancel".tr()),
            onPressed: () => Navigator.pop(context),
          ),
          PlatformDialogAction(
            child: PlatformText("Confirm".tr()),
            onPressed: () {
              timeTextController.text =
                  new DateFormat('yyyy-MM-dd').format(selectedDate);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  Text(
                    "Create New Booking".tr(),
                    style:
                        TextStyle(fontSize: Util.responsiveSize(context, 28)),
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  CarTypeStandardField(
                    carType: _carType,
                    textController: licenseTextController,
                    onPress: (String carType) {
                      setState(() {
                        this._carType = carType;
                      });
                    },
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDateDialog();
                      },
                      child: StandardTextField(
                        textController: timeTextController,
                        fontSize: Util.responsiveSize(context, 18),
                        hintText: "Please Select Booking Date Time".tr(),
                        enable: false,
                      )),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  Text(
                    "Available Time Slots".tr(),
                    style:
                        TextStyle(fontSize: Util.responsiveSize(context, 28)),
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 12.0),
                  //     child: TimeSlotGrid(),
                  //   ),
                  // ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: TimeSlotGrid(),
                    ),
                  SizedBox(
                    height: Util.responsiveSize(context, 18),
                  ),
                  StandardElevatedButton(
                    backgroundColor: UtilExtendsion.mainColor,
                    text: "Submit".tr(),
                    onPress: () {},
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 24),
                  ),
                ],
              ),
            ),
          )
      ,
    );
  }
}
