import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class ConfirmBookingPage extends StatefulWidget {
  final Booking booking;
  final String truckTypeName;
  final String timeSlotName;
  const ConfirmBookingPage({Key key, this.booking, this.truckTypeName, this.timeSlotName})
      : super(key: key);

  @override
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  final TextEditingController textEditingController = TextEditingController();
  Widget _listTile(
      BuildContext context, IconData icon, String label, String value,
      {bool isDivider = true}) {
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
              Row(
                children: [
                  Icon(
                    icon,
                    size: Util.responsiveSize(context, size + 8),
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: Util.responsiveSize(context, 12),
                  ),
                  Text(
                    label + ":",
                    style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: Util.responsiveSize(context, size)),
                  ),
                ],
              ),
              Text(value,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Util.responsiveSize(context, size))),
            ],
          ),
          isDivider
              ? Divider(
                  color: Colors.grey,
                  height: Util.responsiveSize(context, size),
                )
              : SizedBox(
                  height: Util.responsiveSize(context, size),
                )
        ],
      ),
    );
  }

  Widget _greyTile(BuildContext context) {
    return Container(
      height: Util.responsiveSize(context, 24),
      width: double.infinity,
      color: Color(0xffDDDDDD),
    );
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
              Row(
                children: [
                  Icon(
                    Icons.text_fields,
                    size: Util.responsiveSize(context, size + 8),
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: Util.responsiveSize(context, 12),
                  ),
                  Text(
                    "Remark".tr() + ":",
                    style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: Util.responsiveSize(context, size)),
                  ),
                ],
              ),
              Expanded(
                  child: TextField(
                      controller: textEditingController,
                      textAlign: TextAlign.right))
            ],
          ),
          Divider(
            color: Colors.grey,
            height: Util.responsiveSize(context, size),
          )
        ],
      ),
    );
  }

  void _submitForm() async{
    try {
      Util.showLoadingDialog(context);
      Booking booking = await Request().createBooking(
          warehouseID: widget.booking.warehouse,
          shipmentList: widget.booking.shipmentList ?? [],
          driverID: widget.booking.driverID,
          driverTel: widget.booking.driverTel,
          driverCountryCode: widget.booking.driverCountryCode,
          truckNo: widget.booking.truckNo,
          truckType: widget.booking.truckType,
          bookingDate: widget.booking.bookingDate,
          timeSlotId: widget.booking.timeSlot,
          isChHKTruck: false);
      UtilExtendsion.setPreviousWarehouse( int.parse(widget.booking.warehouse));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Successfully".tr())));
      FlutterRouter().goToPage(context, Pages("MainPage"),routeSettings: RouteSettings(arguments: booking), clear: true);
    }catch(error){
      Navigator.pop(context);
      Util.showAlertDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: StandardAppBar(
          text: "Confirmation".tr(),
          backgroundColor: UtilExtendsion.mainColor,
          fontColor: Colors.white,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: Util.responsiveSize(context, 18),
            ),
            _listTile(
                context, Icons.car_repair, "Car Type".tr(), widget.truckTypeName),
            _listTile(context, Icons.ac_unit, "License Number".tr(),
                widget.booking.truckNo,
                isDivider: false),
            _greyTile(context),
            _listTile(context, Icons.schedule, "TimeSlot".tr(),
                widget.timeSlotName),
            _listTile(
                context,
                Icons.date_range,
                "Booking Date".tr(),
                new DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse(widget.booking.bookingDate)),
                isDivider: false),
            _greyTile(context),
            _remarkField(context),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: Color(0xffDDDDDD),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, 12)),
              child: StandardElevatedButton(
                backgroundColor: UtilExtendsion.mainColor,
                text: "Submit".tr(),
                onPress: () =>_submitForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
