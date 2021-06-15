import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:flutter_basecomponent/Util.dart';

class BookingDetailPage extends StatefulWidget {
  final Booking booking;
  const BookingDetailPage({Key key, this.booking}) : super(key: key);

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  Widget detailTile(IconData icon, String title) {
    return Row(children: [
      Icon(icon, size: Util.responsiveSize(context, 20), color: Colors.white),
      Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: Util.responsiveSize(context, 20)),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: 'Booking Detail'.tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
        trailingActions: [
          PlatformIconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
          )
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Text(widget.booking.shipmentList.length.toString()),
          SizedBox(
            height: Util.responsiveSize(context, 24),
          ),
          SlimyCard(
            color: UtilExtendsion.mainColor,
            width: MediaQuery.of(context).size.width * 0.8,
            topCardHeight: Util.responsiveSize(context, 600),
            bottomCardHeight: Util.responsiveSize(context, 26.5)* 6,
            borderRadius: 15,
            topCardWidget: Column(
              children: [
                Text(
                  widget.booking.bookingRef,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Util.responsiveSize(context, 24)),
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                QrImage(
                  data: widget.booking.qrCodeString ?? "",
                  // data: "AA",
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: Util.responsiveSize(context, 200),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Util.responsiveSize(context, 28)),
                  child: Column(
                    children: [
                      detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                      detailTile(Icons.schedule, widget.booking.timeSlot),
                      detailTile(Icons.store, widget.booking.warehouse),
                      detailTile(Icons.car_repair,
                          widget.booking.showTruckAndLicense()),
                    ],
                  ),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 24),
                ),
                Text(
                  "If You Arrived, Please Click Arrived".tr(),
                  style: TextStyle(
                      fontSize: Util.responsiveSize(context, 18),
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 12),
                ),
                StandardElevatedButton(
                  backgroundColor: Colors.green,
                  text: "Arrive".tr(),
                  onPress: () {}, // TODO: onPress handling
                ),
              ],
            ),
            bottomCardWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Shipment'.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Util.responsiveSize(context, 24)),
                ),
                Divider(
                  color: Colors.white,
                ),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
                detailTile(Icons.date_range,widget.booking.displayBookingDate()),
              ],
            ),
            slimeEnabled: true,
          )
        ],
      )),
    );
  }
}
