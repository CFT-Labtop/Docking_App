import 'dart:convert';

import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TimeSlot.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypePullDown.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/LicenseStandardTextField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:docking_project/Widgets/TimeSlotGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class NewBookingPage extends StatefulWidget {
  final int warehouseID;
  final List<String> shipmentList;

  const NewBookingPage({Key key, this.warehouseID, this.shipmentList})
      : super(key: key);

  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final TextEditingController licenseTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  final _carTypeKey = GlobalKey<CarTypePullDownState>();
  List<PickerItem> truckTypeSelection;
  List<PickerItem> dateSelection;
  List<TruckType> truckTypeList;
  List<dynamic> dateList;
  List<TimeSlot> timeSlotList = [];
  TimeSlot selectedTimeSlot;
  Driver driver;
  String selectedDate;
  int selectedTimeSlotIndex = -1;
  String selectedTime;
  Future futureBuilder;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        futureBuilder = getInformation();
      });
    });
    super.initState();
  }

  int _getTimeSlotUsageByValue(String value){
    return this.truckTypeList.firstWhere((element) => element.truck_Type == value).timeSlot_Usage;
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

  Future<void> getInformation() async {
    try {
      this.truckTypeList = await Request().getTrunckType(context, context.locale);
      driver = await Request().getDriver(context: context);
      this.dateList = await Request().getTimeSlot(context, widget.warehouseID);
      this.dateSelection = this
          .dateList
          .map((e) => new PickerItem(
              text: Text(DateFormat("yyyy-MM-dd")
                  .format(DateTime.parse(e["bookingDate"].substring(0,10)))),
              value: e["bookingDate"]))
          .toList();
      this.truckTypeSelection =
          UtilExtendsion.getTruckTypeSelection(this.truckTypeList);
      licenseTextController.text = driver.default_Truck_No;
    } catch (e) {
      throw e;
    }
  }

  void getTimeSlot(List<dynamic> dateList) {
    try {
      List<dynamic> list = dateList.firstWhere((element) =>
          element["bookingDate"] == this.selectedDate)["bookingTimeSlots"];
      this.timeSlotList = list.map((e) => new TimeSlot.fromJson(e)).toList();
    } catch (error) {
      this.timeSlotList = [];
    }
  }

  void submitBooking() async {
    try {
      Util.showLoadingDialog(context);
      if (widget.warehouseID == null)
        throw "Please Select Warehouse".tr();
      if (driver.driver_ID == null || driver.driver_ID.isEmpty)
        throw "Driver ID Cannot Be Empty".tr();
      if (driver.tel == null || driver.tel.isEmpty)
        throw "Mobile Number Cannot Be Empty".tr();
      if (licenseTextController.text == null || licenseTextController.text.isEmpty)
        throw "License Cannot Be Empty".tr();
      if (_carTypeKey.currentState.selectedValue== null ||
          _carTypeKey.currentState.selectedValue.isEmpty)
        throw "Car Type Cannot Be Empty".tr();
      if (selectedDate == null || selectedDate.isEmpty)
        throw "Booking Date Cannot Be Empty".tr();
      if (selectedTime == null || selectedTime.isEmpty)
        throw "Booking Time Slot Cannot Be Empty".tr();
      Navigator.pop(context);
      FlutterRouter().goToPage(context, Pages("ConfirmBookingPage"), parameters: "/" + _carTypeKey.currentState.selectedLabel, routeSettings: RouteSettings(arguments: {"booking": new Booking(warehouseID: widget.warehouseID, shipmentList: widget.shipmentList, driverID: driver.driver_ID, driverCountryCode: driver.countryCode, driverTel: driver.tel, truckNo: licenseTextController.text, truckType: _carTypeKey.currentState.selectedValue, bookingDate: selectedDate, timeSlot: selectedTime, timeSlotUsage: _getTimeSlotUsageByValue(_carTypeKey.currentState.selectedValue)), "timeSlot": selectedTimeSlot} ));
    } catch (error) {
      Navigator.pop(context);
      Util.showAlertDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: "Create New Booking".tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
      ),
      body: FutureBuilder(
        future: futureBuilder,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
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
                      CarTypePullDown(initValue: driver.default_Truck_Type, truckTypeSelection: truckTypeSelection, key: _carTypeKey,),
                      SizedBox(height: Util.responsiveSize(context, 24),),
                      LicenseStandardTextField(textController: licenseTextController,),
                      SizedBox(
                        height: Util.responsiveSize(context, 24),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 8),
                      ),
                      StandardPullDown(
                        hintText: "Please Select Booking Date Time".tr(),
                        pickerList: dateSelection,
                        onSelected: (value, String displayLabel) {
                          setState(() {
                            selectedDate = value;
                            selectedTimeSlot = null;
                            timeTextController.text = displayLabel;
                            getTimeSlot(this.dateList);
                            selectedTimeSlotIndex = -1;
                            selectedTime = null;
                          });
                        },
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 32),
                      ),
                      Text(
                        "Available Time Slots".tr(),
                        style: TextStyle(
                            fontSize: Util.responsiveSize(context, 28)),
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 32),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: TimeSlotGrid(
                          selectedIndex: selectedTimeSlotIndex,
                          timeSlotList: this.timeSlotList,
                          onSelected: (int index, TimeSlot selectedTimeSlot, String timeSlotText) {
                            setState(() {
                              selectedTimeSlotIndex = index;
                              selectedTime = selectedTimeSlot.timeSlotId;
                              this.selectedTimeSlot = selectedTimeSlot;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 18),
                      ),
                      StandardElevatedButton(
                        backgroundColor: UtilExtendsion.mainColor,
                        text: "Next".tr(),
                        onPress: () => submitBooking(),
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 24),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
