import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';

class ConfirmBookingPage extends StatefulWidget {
  const ConfirmBookingPage({Key key}) : super(key: key);

  @override
  _ConfirmBookingPageState createState() => _ConfirmBookingPageState();
}

Widget _listTile(BuildContext context, IconData icon,  String label, String value, {bool isDivider = true}) {
  double size = 18;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, size)),
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
                Icon(icon, size: Util.responsiveSize(context, size + 8), color: Colors.grey,),
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
        isDivider ? Divider(color: Colors.grey,height: Util.responsiveSize(context, size),): SizedBox(height: Util.responsiveSize(context, size),)
      ],
    ),
  );
}

Widget _greyTile(BuildContext context){
  return Container(
    height: Util.responsiveSize(context, 24),
    width: double.infinity,
    color: Color(0xffDDDDDD),
  );
}

Widget _remarkField(BuildContext context){
  double size = 18;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, size)),
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
                Icon(Icons.text_fields, size: Util.responsiveSize(context, size + 8), color: Colors.grey,),
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
            Text("value",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: Util.responsiveSize(context, size))),
          ],
        ),
        Divider(color: Colors.grey,height: Util.responsiveSize(context, size),)
      ],
    ),
  );
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _listTile(context, Icons.car_repair, "Car Type".tr(), "20尺"),
          _listTile(context, Icons.ac_unit, "License Number".tr(), "AA1234", isDivider: false),
          _greyTile(context),
          _listTile(context, Icons.schedule, "TimeSlot".tr(), "01:00:00 - 02:00:00"),
          _listTile(context, Icons.date_range, "Booking Date".tr(), "20尺", isDivider: false),
          _greyTile(context),
          // _listTile(context, Icons.ac_unit, "車型", "20尺"),
        ],
      ),
    );
  }
}
