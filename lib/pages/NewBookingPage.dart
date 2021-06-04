import 'dart:convert';

import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardTextField.dart';
import 'package:docking_project/Widgets/TimeSlotGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewBookingPage extends StatefulWidget {
  const NewBookingPage({Key key}) : super(key: key);

  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  String _carType = "車型";
  final TextEditingController licenseTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();

  showDateDialog() {
    DateTime selectedDate = DateTime.now();
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Please Select Date'.tr()),
        content: Container(
            height: Util.responsiveSize(context, 400),
            // width: Util.responsiveSize(context, 1000),
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
    return Scaffold(
      appBar: StandardAppBar( text: "Create New Booking".tr(),backgroundColor: UtilExtendsion.mainColor, fontColor: Colors.white,),
      body: GestureDetector(
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
      ),
    );
  }
}
