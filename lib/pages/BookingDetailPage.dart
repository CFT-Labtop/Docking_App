import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_basecomponent/Util.dart';

class BookingDetailPage extends StatefulWidget {
  final Booking booking;
  const BookingDetailPage({Key key, this.booking}) : super(key: key);

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  List<String> shipmentList = ["testing1", "testing2", "testing3", "testing4"];
  //TODO Sample ShipmentList
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

  Widget _titleText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontSize: Util.responsiveSize(context, 24)),
    );
  }

  Divider _whiteDivider(){
    return Divider(color: Colors.white,);
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
            onPressed: () async{
              Util.showConfirmDialog(context, title: "Confirm To Delete?".tr(), onPress: () async{
                try{
                  Util.showLoadingDialog(context);
                  await Request().deleteBooking(widget.booking.bookingRef);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete Successfully".tr())));
                  Navigator.pop(context);
                }catch(error){
                  Navigator.pop(context);
                  Util.showAlertDialog(context, error.toString());
                }
              });
            },
          ),
          PlatformIconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: (){
              Util.showAlertDialog(context, shipmentList.join("\n"), title: "Shipment".tr());
            },
          )
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: Util.responsiveSize(context, 12)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: UtilExtendsion.mainColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Wrap(
              children: [
                SizedBox(
                  height: Util.responsiveSize(context, 24),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: Util.responsiveSize(context, 12),
                    ),
                    _titleText(widget.booking.bookingRef),
                    _whiteDivider(),
                    SizedBox(
                      height: Util.responsiveSize(context, 32),
                    ),
                    QrImage(
                      data: widget.booking.qrCodeString ?? "",
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
                          detailTile(Icons.date_range,
                              widget.booking.displayBookingDate()),
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
                    widget.booking.bookingStatus == "Arrived"?
                    StandardElevatedButton(
                      backgroundColor: Colors.grey,
                      text: "Done".tr(),
                      onPress: () {}, 
                    ):
                    StandardElevatedButton(
                      backgroundColor: Colors.green,
                      text: "Arrive".tr(),
                      onPress: () async{
                        try{
                          Util.showLoadingDialog(context);
                          await Request().truckArrive(widget.booking.bookingRef);
                          Navigator.pop(context);
                          Util.showAlertDialog(context, "", title: "Confirm Successfully".tr());
                          setState(() {
                            widget.booking.bookingStatus = "Arrived";
                          });
                        }catch(error){
                          Navigator.pop(context);
                          Util.showAlertDialog(context, error.toString());
                        }
                    }, 
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 24),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
