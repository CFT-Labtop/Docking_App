import 'dart:convert';

import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TimeSlot.dart';
import 'package:docking_project/Model/TruckClient.dart';
import 'package:docking_project/Model/TruckCompany.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CHHKSwitch.dart';
import 'package:docking_project/Widgets/CarTypePullDown.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/ClientTypePullDown.dart';
import 'package:docking_project/Widgets/LicenseStandardTextField.dart';
import 'package:docking_project/Widgets/LoadTruckSwitch.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:docking_project/Widgets/TimeSlotGrid.dart';
import 'package:docking_project/Widgets/TruckCompanyPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class NewBookingPage extends StatefulWidget {
  final int warehouseID;
  final String warehouseName;
  final List<String> shipmentList;

  const NewBookingPage(
      {Key key, this.warehouseID, this.shipmentList, this.warehouseName})
      : super(key: key);

  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final TextEditingController licenseTextController = TextEditingController();
  final TextEditingController remarkTextController = TextEditingController();
  final _carTypeKey = GlobalKey<CarTypePullDownState>();
  final _dateSelectorKey = GlobalKey<StandardPullDownState>();
  final _chhkKey = GlobalKey<CHHKSwitchState>();
  final _loadKey = GlobalKey<LoadTruckSwitchState>();
  final _clientTypeKey = GlobalKey<ClientTypePullDownState>();
  final _truckCompanyKey = GlobalKey<TruckCompanyPullDownState>();
  final _formKey = GlobalKey<FormState>();
  List<PickerItem> truckTypeSelection;
  List<PickerItem> truckClientSelection;
  List<PickerItem> truckCompanySelection;
  List<PickerItem> dateSelection = [];
  List<TruckType> truckTypeList = [];
  List<TruckClient> truckClientList = [];
  List<TruckCompany> truckCompanyList = [];
  List<dynamic> dateList;
  List<TimeSlot> timeSlotList = [];
  TimeSlot selectedTimeSlot;
  Driver driver;
  int selectedTimeSlotIndex = -1;
  String selectedTime;
  Future futureBuilder;
  ValueNotifier<GlobalKey<CarTypePullDownState>> carTypeValueNotifier;

  @override
  void initState() {
    futureBuilder = getInformation();
    super.initState();
    // carTypeValueNotifier = ValueNotifier(_carTypeKey);
  }

  int _getTimeSlotUsageByValue(String value) {
    return this
        .truckTypeList
        .firstWhere((element) => element.truck_Type == value)
        .timeSlot_Usage;
  }

  Future<void> getInformation() async {
    try {
      this.truckTypeList = await Request()
          .getTrunckTypeByWarehouseID(context, widget.warehouseID);
      this.truckClientList = await Request()
          .getTruckClientByWarehouseID(context, widget.warehouseID);
      this.truckCompanyList = await Request()
          .getTruckCompanyByWarehouseID(context, widget.warehouseID);
      driver = await Request().getDriver(context: context);
      // if (driver.default_Truck_Type != null && driver.default_Truck_Type.isNotEmpty && this.truckTypeList.firstWhere((element) => element.truck_Type == driver.default_Truck_Type, orElse: () => null) != null) await _getDateSelection(driver.default_Truck_Type);
      this.truckTypeSelection =
          UtilExtendsion.getTruckTypeSelection(this.truckTypeList);
      this.truckClientSelection =
          UtilExtendsion.getTruckClientSelection(this.truckClientList);
      this.truckCompanySelection =
          UtilExtendsion.getTruckCompanySelection(this.truckCompanyList);
      licenseTextController.text = driver.default_Truck_No;
    } catch (e) {
      throw e;
    }
  }

  Future<void> _getDateSelection(String truckType, int clientID) async {
    this.dateList = await Request()
        .getTimeSlot(context, widget.warehouseID, truckType, clientID);
    this.dateSelection = this
        .dateList
        .map((e) => new PickerItem(
            text: Text(DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["bookingDate"].substring(0, 10)))),
            value: e["bookingDate"]))
        .toList();
  }

  void getTimeSlot(List<dynamic> dateList) {
    try {
      List<dynamic> list = dateList.firstWhere((element) =>
          element["bookingDate"] ==
          _dateSelectorKey.currentState.selectedValue)["bookingTimeSlots"];
      this.timeSlotList = list.map((e) => new TimeSlot.fromJson(e)).toList();
    } catch (error) {
      this.timeSlotList = [];
    }
  }

  void submitBooking() async {
    if (_formKey.currentState.validate()) {
      try {
        Util.showLoadingDialog(context);
        if (widget.warehouseID == null) throw "Please Select Warehouse".tr();
        if (driver.driver_ID == null || driver.driver_ID.isEmpty)
          throw "Driver ID Cannot Be Empty".tr();
        if (driver.tel == null || driver.tel.isEmpty)
          throw "Mobile Number Cannot Be Empty".tr();
        if (licenseTextController.text == null ||
            licenseTextController.text.isEmpty)
          throw "License Cannot Be Empty".tr();
        if (_carTypeKey.currentState.selectedValue == null ||
            _carTypeKey.currentState.selectedValue.isEmpty)
          throw "Car Type Cannot Be Empty".tr();
        if (_clientTypeKey.currentState.selectedValue == null ||
            _clientTypeKey.currentState.selectedValue == 0)
          throw "Client Type Cannot Be Empty".tr();
        if (_truckCompanyKey.currentState.selectedValue == null ||
            _clientTypeKey.currentState.selectedValue == 0)
          throw "Truck Company Cannot Be Empty".tr();
        if (!_carTypeKey.currentState.isAnswerValid() ||
            _dateSelectorKey.currentState.selectedValue == null ||
            _dateSelectorKey.currentState.selectedValue.isEmpty)
          throw "Booking Date Cannot Be Empty".tr();

        if (selectedTime == null || selectedTime.isEmpty)
          throw "Booking Time Slot Cannot Be Empty".tr();
        Navigator.pop(context);
        FlutterRouter().goToPage(context, Pages("ConfirmBookingPage"),
            parameters: "/" +
                _carTypeKey.currentState.selectedLabel +
                "/" +
                _clientTypeKey.currentState.selectedLabel +
                "/" +
                _truckCompanyKey.currentState.selectedLabel,
            routeSettings: RouteSettings(arguments: {
              "booking": new Booking(
                  warehouseID: widget.warehouseID,
                  warehouse: widget.warehouseName,
                  shipmentList: widget.shipmentList,
                  driverID: driver.driver_ID,
                  driverCountryCode: driver.countryCode,
                  clientID: _clientTypeKey.currentState.selectedValue,
                  truckCompanyID: _truckCompanyKey.currentState.selectedValue,
                  driverTel: driver.tel,
                  truckNo: licenseTextController.text,
                  truckType: _carTypeKey.currentState.selectedValue,
                  bookingDate: _dateSelectorKey.currentState.selectedValue,
                  timeSlot: selectedTime,
                  timeSlotUsage: _getTimeSlotUsageByValue(
                      _carTypeKey.currentState.selectedValue),
                  unloading: _loadKey.currentState.value,
                  isChHKTruck: _chhkKey.currentState.value,
                  bookingRemark: remarkTextController.text),
              "timeSlot": selectedTimeSlot
            }));
      } catch (error) {
        Navigator.pop(context);
        Util.showAlertDialog(context, error.toString());
      }
    }
  }

  void _clearDateSelection() {
    setState(() {
      if (_dateSelectorKey.currentState != null)_dateSelectorKey.currentState.setValue(null);
      this.timeSlotList = [];
      selectedTimeSlot = null;
      selectedTimeSlotIndex = -1;
      selectedTime = null;
    });
  }

  Widget _timeSlotSelectPart(StateSetter setState) {
    return Column(
      children: [
        StandardPullDown(
          hintText: "Please Select Booking Date Time".tr(),
          key: _dateSelectorKey,
          pickerList: dateSelection,
          onSelected: (value, String displayLabel) {
            setState(() {
              selectedTimeSlot = null;
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
          style: TextStyle(fontSize: Util.responsiveSize(context, 28)),
        ),
        SizedBox(
          height: Util.responsiveSize(context, 32),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: TimeSlotGrid(
            selectedIndex: selectedTimeSlotIndex,
            timeSlotList: this.timeSlotList,
            onSelected:
                (int index, TimeSlot selectedTimeSlot, String timeSlotText) {
              setState(() {
                selectedTimeSlotIndex = index;
                selectedTime = selectedTimeSlot.timeSlotId;
                this.selectedTimeSlot = selectedTimeSlot;
              });
            },
          ),
        ),
      ],
    );
  }

  bool _isTruckTypeValid() {
    return (_carTypeKey.currentState != null &&
        _carTypeKey.currentState.isAnswerValid());
  }

  Widget _remarkField(BuildContext context) {
    double size = 18;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, size)),
      child: Column(
        children: [
          SizedBox(
            height: Util.responsiveSize(context, 8),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remark".tr() + ":",
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: Util.responsiveSize(context, size),
                ),
              ),
              SizedBox(
                width: Util.responsiveSize(context, 8),
              ),
              Expanded(
                  child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: remarkTextController,
              ))
            ],
          ),
        ],
      ),
    );
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
              onTap: () {
                print("ASDAS");
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Util.responsiveSize(context, 32),
                                ),
                                CarTypePullDown(
                                    initValue: driver.default_Truck_Type,
                                    truckTypeSelection: truckTypeSelection,
                                    key: _carTypeKey,
                                    onSelected: (String selectedValue,
                                        String displayLabel) async {
                                      try {
                                        Util.showLoadingDialog(context);
                                        await _getDateSelection(
                                            _carTypeKey
                                                .currentState.selectedValue,
                                            _clientTypeKey
                                                .currentState.selectedValue);
                                        _clearDateSelection();
                                        Navigator.pop(context);
                                      } catch (error) {
                                        Navigator.pop(context);
                                        Util.showAlertDialog(
                                            context, error.toString());
                                      }
                                    }),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                ClientTypePullDown(
                                    initValue: driver.default_Client_ID,
                                    clientTypeSelection: truckClientSelection,
                                    key: _clientTypeKey),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                TruckCompanyPullDown(
                                  initValue: driver.default_Company_ID,
                                  truckCompanySelection: truckCompanySelection,
                                  key: _truckCompanyKey,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 24),
                                ),
                                LicenseStandardTextField(
                                  textController: licenseTextController,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 16),
                                ),
                                CHHKSwitch(
                                  initValue: driver.default_Is_CH_HK_Truck,
                                  key: _chhkKey,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 16),
                                ),
                                LoadTruckSwitch(
                                  initValue: false,
                                  key: _loadKey,
                                ),
                                SizedBox(
                                  height: Util.responsiveSize(context, 16),
                                ),
                                _remarkField(context),
                                SizedBox(
                                  height: Util.responsiveSize(context, 8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Expanded(child: SizedBox()),
                      Column(
                        children: [
                          StandardElevatedButton(
                            backgroundColor: UtilExtendsion.mainColor,
                            text: "Next".tr(),
                            onPress: () async {
                              _clearDateSelection();
                              if (_formKey.currentState.validate()) {
                                if (_carTypeKey
                                            .currentState.selectedValue ==
                                        null ||
                                    _carTypeKey
                                        .currentState.selectedValue.isEmpty ||
                                    !_carTypeKey.currentState.isAnswerValid()) {
                                  Util.showAlertDialog(
                                      context, "Car Type Cannot Be Empty".tr());
                                } else if (_clientTypeKey
                                            .currentState.selectedValue ==
                                        null ||
                                    _clientTypeKey.currentState.selectedValue ==
                                        0 ||
                                    !_clientTypeKey.currentState
                                        .isAnswerValid()) {
                                  Util.showAlertDialog(context,
                                      "Client Type Cannot Be Empty".tr());
                                } else if (_truckCompanyKey
                                            .currentState.selectedValue ==
                                        null ||
                                    _truckCompanyKey
                                            .currentState.selectedValue ==
                                        0) {
                                  Util.showAlertDialog(context,
                                      "Truck Company Cannot Be Empty".tr());
                                } else if (licenseTextController.text == null ||
                                    licenseTextController.text.isEmpty) {
                                  Util.showAlertDialog(
                                      context, "License Cannot Be Empty".tr());
                                } else {
                                  Util.showLoadingDialog(context);
                                  await this._getDateSelection(
                                      _carTypeKey.currentState.selectedValue,
                                      _clientTypeKey
                                          .currentState.selectedValue);
                                  Navigator.pop(context);
                                  Util.showModalSheet(
                                      context, "Booking Date".tr(),
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Scrollbar(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            _timeSlotSelectPart(setState),
                                            StandardElevatedButton(
                                                backgroundColor:
                                                    UtilExtendsion.mainColor,
                                                text: "Confirm".tr(),
                                                onPress: () => submitBooking())
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                      colorTone: UtilExtendsion.mainColor,
                                      height: 0.9);
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: Util.responsiveSize(context, 24),
                          ),
                        ],
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
