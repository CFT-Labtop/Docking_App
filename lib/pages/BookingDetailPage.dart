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
  Widget detailTile(IconData icon, String title) {
    return Row(children: [
      Icon(icon, size: Util.responsiveSize(context, 20), color: Colors.white),
      SizedBox(
        width: Util.responsiveSize(context, 8),
      ),
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

  Divider _whiteDivider() {
    return Divider(
      color: Colors.white,
    );
  }

  Widget _remarkText(){
    return (widget.booking.bookingRemark != null && widget.booking.bookingRemark.isNotEmpty)? GestureDetector(
      onTap: (){
        Util.showAlertDialog(context, widget.booking.bookingRemark, title: "Remark".tr());
      },
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: Util.responsiveSize(context, 24)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Remark".tr() + ":", style: TextStyle(color: Colors.white, fontSize: Util.responsiveSize(context, 18),decoration: TextDecoration.underline, ),),
            SizedBox(width: Util.responsiveSize(context, 12)),
            Flexible(child: Text(widget.booking.bookingRemark,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blue, fontSize: Util.responsiveSize(context, 18),decoration: TextDecoration.underline, ), )),
          ],
        ),
      ),
    ): SizedBox();
  }

  Widget _myPopMenu() {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 1:
                Util.showAlertDialog(context, widget.booking.shipmentList.join("\n"),
                    title: "Shipment".tr());
                break;
              case 2:
                Util.showConfirmDialog(context,
                    title: "Confirm To Delete?".tr(), onPress: () async {
                  try {
                    Util.showLoadingDialog(context);
                    await Request().deleteBooking(context ,widget.booking.bookingRef);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Delete Successfully".tr())));
                    Navigator.pop(context);
                  } catch (error) {
                    Navigator.pop(context);
                    Util.showAlertDialog(context, error.toString());
                  }
                });
                break;
            }
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.list, color: Colors.black),
                        ),
                        Text('Shipment'.tr())
                      ],
                    )),
                PopupMenuItem(
                    value: 2,
                    enabled: !_isArrivedOrWIPOrDeleted(),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                        Text('Delete'.tr())
                      ],
                    )),
              ]),
    );
  }

  bool _isArrivedOrWIPOrDeleted(){
    return (widget.booking.bookingStatus == "WIP" || widget.booking.bookingStatus == "工作中" || widget.booking.bookingStatus == "Arrived" || widget.booking.bookingStatus == "已到達" || widget.booking.bookingStatus == "已到达" || widget.booking.bookingStatus == "Cancelled" || widget.booking.bookingStatus == "已取消");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: 'Booking Detail'.tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
        trailingActions: [
          _myPopMenu()
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
                          detailTile(Icons.store, widget.booking.warehouse.toString()),
                          detailTile(Icons.car_repair,
                              widget.booking.showTruckAndLicense()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 24),
                    ),
                    _remarkText(),
                    SizedBox(
                      height: Util.responsiveSize(context, 12),
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
                    _isArrivedOrWIPOrDeleted()
                        ? StandardElevatedButton(
                            backgroundColor: Colors.grey,
                            text: widget.booking.bookingStatus,
                            onPress: () {},
                          )
                        : StandardElevatedButton(
                            backgroundColor: Colors.green,
                            text: "Arrive".tr(),
                            onPress: () async {
                              Util.showConfirmDialog(context, title: "Confirm To Arrive?".tr(), onPress: () async{
                                try {
                                Util.showLoadingDialog(context);
                                await Request()
                                    .truckArrive(context, widget.booking.bookingRef);
                                Navigator.pop(context);
                                Util.showAlertDialog(context, "",
                                    title: "Confirm Successfully".tr());
                                setState(() {
                                  widget.booking.bookingStatus = "Arrived".tr();
                                });
                              } catch (error) {
                                Navigator.pop(context);
                                Util.showAlertDialog(context, error.toString());
                              }
                              });
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
