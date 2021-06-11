import 'dart:convert';

import 'package:docking_project/Model/TimeSlot.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:docking_project/Widgets/StandardTextFormField.dart';
import 'package:docking_project/Widgets/TimeSlotGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewBookingPage extends StatefulWidget {
  final String warehouse;
  final List<String> shipmentList;

  const NewBookingPage({Key key, this.warehouse, this.shipmentList}) : super(key: key);

  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  String _carType;
  final TextEditingController licenseTextController = TextEditingController();
  final TextEditingController timeTextController = TextEditingController();
  List<PickerItem> truckTypeSelection;
  List<PickerItem> dateSelection;
  List<dynamic> dateList;
  List<TimeSlot> timeSlotList = [];
  String selectedDate;
  int selectedTimeSlotIndex = -1;
  String selectedTime;
  Future futureBuilder;

  @override
  void initState() {
    futureBuilder = getInformation();
    super.initState();
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

  Future<void> getInformation() async{
    try{
      List<TruckType> truckTypeList = await Request().getTrunckType();
      this.dateList = await Request().getTimeSlot(widget.warehouse);
      this.dateSelection = this.dateList.map((e) => new PickerItem(text: Text(DateFormat("yyyy-MM-dd").format(DateTime.parse(e["bookingDate"]))), value:e["bookingDate"] )).toList();
      this.truckTypeSelection = UtilExtendsion.getTruckTypeSelection(truckTypeList);
      licenseTextController.text = UtilExtendsion.getDefaultTruckNo();
      _carType = UtilExtendsion.getDefaultTruckType();
    }catch(e){
      throw e;
    }
  }
  
  void getTimeSlot(List<dynamic> dateList){
    try{
      List<dynamic> list = dateList.firstWhere((element) => element["bookingDate"] == this.selectedDate)["bookingTimeSlots"];
      this.timeSlotList = list.map((e) => new TimeSlot.fromJson(e)).toList();
      this.timeSlotList.sort((a,b) => a.timeSlotId.compareTo(b.timeSlotId));
    }catch(error){
      this.timeSlotList = [];
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
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: Util.responsiveSize(context, 24)),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
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
                        }, truckTypeSelection: truckTypeSelection,
                      ),
                      SizedBox(
                        height: Util.responsiveSize(context, 32),
                      ),
                      StandardPullDown(hintText: "Please Select Booking Date Time".tr(), textController: timeTextController, pickerList: dateSelection, onSelected: (value, String displayLabel) { 
                        setState(() {
                          selectedDate = value;
                          timeTextController.text = displayLabel;
                          getTimeSlot(this.dateList);
                          selectedTimeSlotIndex = -1;
                          selectedTime = null;
                        });
                       },),
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
                        child: TimeSlotGrid(selectedIndex: selectedTimeSlotIndex, timeSlotList: this.timeSlotList, onSelected: (int index, TimeSlot selectedTimeSlot) { 
                          setState(() {
                            selectedTimeSlotIndex = index;
                          });
                         },),
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
              ),
            );
          }else{
            return Center(child: PlatformCircularProgressIndicator());
          }
        },
      ),
    );
  }
}
