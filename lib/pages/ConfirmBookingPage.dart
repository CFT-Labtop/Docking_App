import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Model/TimeSlot.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';

class ConfirmBookingPage extends StatefulWidget {
  final Booking booking;
  final TimeSlot timeSlot;
  final String truckTypeName;
  final String clientTypeName;
  final String truckCompanyName;
  const ConfirmBookingPage({Key key, this.booking, this.truckTypeName, this.clientTypeName, this.truckCompanyName, this.timeSlot})
      : super(key: key);

  @override
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  // final TextEditingController textEditingController = TextEditingController();
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
              Flexible(
                child: Text(value,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Util.responsiveSize(context, size)))
              ),
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

  void _submitForm() async{
    try {
      Util.showLoadingDialog(context);
      Booking booking = await Request().createBooking(context,
          warehouseID: widget.booking.warehouseID ,
          shipmentList: widget.booking.shipmentList ?? [],
          driverID: widget.booking.driverID,
          driverTel: widget.booking.driverTel,
          driverCountryCode: widget.booking.driverCountryCode,
          clientID: widget.booking.clientID,
          companyID: widget.booking.truckCompanyID,
          truckNo: widget.booking.truckNo,
          truckType: widget.booking.truckType,
          bookingDate: widget.booking.bookingDate,
          timeSlotId: widget.booking.timeSlot,
          isChHKTruck: widget.booking.isChHKTruck,
          unloading: widget.booking.unloading,
          bookingRemark: widget.booking.bookingRemark,
          timeSlotUsage: widget.booking.timeSlotUsage);
      await UtilExtendsion.setPreviousWarehouse( widget.booking.warehouseID);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking Successfully".tr())));
      showTopSnackBar(
        context,
        CustomSnackBar.success(
        message:
          "Please arrive".tr() + " " + widget.booking.warehouse + " " + "15 minutes in advance the reservation time slot".tr(),
        ),
      );
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
        body: Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Util.responsiveSize(context, 18),
                      ),
                      _listTile(
                          context, Icons.car_repair, "Car Type".tr(), widget.truckTypeName),
                      _listTile(
                          context, Icons.person, "Client Type".tr(), widget.clientTypeName),
                      _listTile(context, Icons.workspaces, "Truck Company".tr(), widget.truckCompanyName),
                      _listTile(context, Icons.card_travel,"License Number".tr(),
                          widget.booking.truckNo,
                          isDivider: false),
                      _greyTile(context),
                      Text("Please note that, you need to arrive".tr() + " " + widget.booking.warehouse + " " + "before starting time for docking".tr(), style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                      _listTile(context, Icons.schedule, "Start Time".tr(),widget.timeSlot.startTime.substring(0,5)),
                      _listTile(context, Icons.schedule_sharp, "End Time".tr(),widget.timeSlot.endTime.substring(0,5)),
                      _listTile(
                          context,
                          Icons.date_range,
                          "Booking Date".tr(),
                          new DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(widget.booking.bookingDate.substring(0,10))),
                          isDivider: false),
                      _greyTile(context),
                      _listTile(context, Icons.directions_car_sharp, "Cross Border Vehicle".tr(),widget.booking.isChHKTruck ? "Yes".tr() : "No".tr()),
                      _listTile(context, Icons.vertical_align_bottom, "Unloading".tr(),widget.booking.unloading ? "Yes".tr() : "No".tr(), isDivider: false),
                      _greyTile(context),
                      _listTile(context, Icons.text_fields, "Remark".tr(),widget.booking.bookingRemark),
                      // Text("Please note that, you need to arrive".tr() + " " + widget.booking.warehouse + " " + "before starting time for docking".tr(), style: TextStyle(color: Colors.red),)
                    ],
                  ),
                ),
              ),
            ),
                Padding(
                  padding:  EdgeInsets.only(left: Util.responsiveSize(context, 12), right: Util.responsiveSize(context, 12), bottom: Util.responsiveSize(context, 24)),
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
