import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Widgets/ColumnBuilder.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:badges/badges.dart';
import 'package:location/location.dart';

class BookingDetailPage extends StatefulWidget {
  final Booking booking;
  const BookingDetailPage({Key key, this.booking}) : super(key: key);

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  Future futureBuilder;
  Booking booking;
  bool isNeedGPS = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> getBooking() async {
    this.booking = await Request().getBooking(context, widget.booking.bookingRef);
    Map<String, dynamic> isNeedGPSConfig = await UtilExtendsion.getConfigItem(context,"TruckArriveIncludeLocation");
    this.isNeedGPS = isNeedGPSConfig["configValue"] == "False" ? false: true;
  }

  Color convertStatusToColor(String bookingStatusCode) {
    switch(bookingStatusCode){
      case "B000":
        return Colors.red;
      case "B100":
        return Colors.blue;
      case "B200":
        return Colors.green;
      case "B700":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  void initState() {
    this.booking = widget.booking;
    futureBuilder = getBooking();
    super.initState();
  }

  Widget detailTile(IconData icon, String title) {
    return Row(children: [
      Icon(icon, size: Util.responsiveSize(context, 20), color: Colors.white),
      SizedBox(
        width: Util.responsiveSize(context, 8),
      ),
      Flexible(
        child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: Util.responsiveSize(context, 20)),)
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

  Widget _remarkText() {
    return (this.booking.bookingRemark != null &&
            this.booking.bookingRemark.isNotEmpty)
        ? GestureDetector(
            onTap: () {
              Util.showAlertDialog(context, this.booking.bookingRemark,
                  title: "Remark".tr());
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Util.responsiveSize(context, 24)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remark".tr() + ":",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Util.responsiveSize(context, 18),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(width: Util.responsiveSize(context, 12)),
                  Flexible(
                      child: Text(
                    this.booking.bookingRemark,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: Util.responsiveSize(context, 18),
                      decoration: TextDecoration.underline,
                    ),
                  )),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget _myPopMenu() {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton(
          onSelected: (value) async {
            switch (value) {
              case 1:
                Util.showAlertDialog(
                    context, this.booking.shipmentList.join("\n"),
                    title: "Shipment".tr());
                break;
              case 2:
                List<Map<String, dynamic>> cancelReasonList =
                    await Request().getCancelReasons(context);
                String val = cancelReasonList[0]["msgCode"];
                String selectedLabel = cancelReasonList[0]["msg"];
                final TextEditingController textEditingController = TextEditingController();
                Util.showModalSheet(context, "Confirm To Delete?".tr(), (
                  BuildContext context,
                  StateSetter setState,
                ) {
                  return Scaffold(
                    body: Scrollbar(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            children: [
                              ColumnBuilder(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(cancelReasonList[index]["msg"]),
                                      leading: Radio(
                                        value: cancelReasonList[index]["msgCode"],
                                        groupValue: val,
                                        onChanged: (value) {
                                          setState(() {
                                            val = value;
                                            selectedLabel =
                                                cancelReasonList[index]["msg"];
                                          });
                                        },
                                        activeColor: Colors.blue,
                                      ),
                                    );
                                  },
                                  itemCount: cancelReasonList.length),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: textEditingController,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Reason of Cancelling Booking'.tr(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Util.responsiveSize(context, 12),
                              ),
                              StandardElevatedButton(
                                backgroundColor: Colors.green,
                                text: "Submit".tr(),
                                onPress: () async {
                                  try {
                                    String submitMessage = textEditingController.text.isEmpty || textEditingController.text == null ? selectedLabel : selectedLabel +
                                            " (" +
                                            textEditingController.text +
                                            ")";
                                    Util.showLoadingDialog(context);
                                    await Request().deleteBookingWithReason(
                                        context,
                                        this.booking.bookingRef,
                                        submitMessage);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Delete Successfully".tr())));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } catch (error) {
                                    Navigator.pop(context);
                                    Util.showAlertDialog(
                                        context, error.toString());
                                  }
                                },
                              ),
                              // Spacer()
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }, height: .8);
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

  bool _isArrivedOrWIPOrDeleted() {
    return this.booking.bookingStatusCode == "B000" ||
        this.booking.bookingStatusCode == "B200" ||
        this.booking.bookingStatusCode == "B700";
  }

  void arriveTruck() {
    Util.showConfirmDialog(context, title: "Confirm To Arrive?".tr(),
        onPress: () async {
      try {
        Util.showLoadingDialog(context);
        await Request().truckArrive(context, this.booking.bookingRef, this.booking.latitude, this.booking.longitude);
        await getBooking();
        Navigator.pop(context);
        Util.showAlertDialog(context, "", title: "Confirm Successfully".tr());
        // setState(() {
        //   this.booking.bookingStatusCode = "B200".tr();
        //   this.booking.bookingStatus = "Arrived".tr();
        // });
        setState(() {});
      } catch (error) {
        Navigator.pop(context);
        Util.showAlertDialog(context, error.toString());
      }
    });
  }

  Widget _boxContent() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          color: UtilExtendsion.mainColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Scrollbar(
        child: SingleChildScrollView(
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
                  _titleText(this.booking.bookingRef),
                  SizedBox(
                    height: Util.responsiveSize(context, 4),
                  ),
                  _isArrivedOrWIPOrDeleted()
                      ? AbsorbPointer(
                        child: StandardElevatedButton(
                            backgroundColor: convertStatusToColor(this.booking.bookingStatusCode),
                            text: this.booking.bookingStatus,
                            onPress: () {},
                          ),
                      )
                      : StandardElevatedButton(
                          backgroundColor: convertStatusToColor(this.booking.bookingStatusCode),
                          text: "Arrive".tr(),
                          onPress: () {
                            if(this.isNeedGPS){
                              Util.showLoadingDialog(context);
                              Util.checkGPSPermission(context, onGranted: () async {
                                Location location = new Location();
                                LocationData locationData = await location.getLocation();
                                this.booking.latitude = locationData.latitude;
                                this.booking.longitude = locationData.longitude;
                                Navigator.pop(context);
                                arriveTruck();
                              }, onFailed: () {
                                Navigator.pop(context);
                                arriveTruck();
                              });
                            }else
                              arriveTruck();
                          },
                        ),
                  SizedBox(
                    height: Util.responsiveSize(context, 4),
                  ),
                  _whiteDivider(),
                  SizedBox(
                    height: Util.responsiveSize(context, 32),
                  ),
                  QrImage(
                    data: this.booking.qrCodeString ?? "",
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
                            this.booking.displayBookingDate()),
                        detailTile(Icons.schedule, this.booking.timeSlot),
                        detailTile(
                            Icons.store, this.booking.warehouse.toString()),
                        detailTile(Icons.car_repair,
                            this.booking.showTruckAndLicense()),
                        this.booking.clientName != null
                            ? detailTile(Icons.person, this.booking.clientName)
                            : SizedBox(),
                        this.booking.truckCompanyName!= null
                            ? detailTile(Icons.workspaces, this.booking.truckCompanyName)
                            : SizedBox(),
                        detailTile(
                            Icons.directions_car_sharp,
                            this.booking.isChHKTruck
                                ? "Cross Border Vehicle".tr()
                                : "No CHK License".tr()),
                        detailTile(
                            Icons.vertical_align_bottom,
                            this.booking.unloading
                                ? "Unloading".tr()
                                : "No Unloading".tr()),
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
                    height: Util.responsiveSize(context, 24),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: 'Booking Detail'.tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
        trailingActions: [_myPopMenu()],
      ),
      body: SafeArea(
        child: FutureBuilder(
        future: futureBuilder,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return SmartRefresher(
            header: WaterDropMaterialHeader(),
            controller: _refreshController,
            onRefresh: () async {
              await getBooking();
                setState(() {
                  _refreshController.refreshCompleted();
                });
            },
            child: UtilExtendsion.CustomFutureBuild(context, snapshot, () {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Util.responsiveSize(context, 12)),
                  child: this.booking.bookingMsg != null
                      ? GestureDetector(
                          onTap: () {
                            Util.showAlertDialog(
                                context, this.booking.bookingMsg,
                                title: "Alert".tr());
                          },
                          child: Badge(
                              badgeColor: Colors.blue,
                              animationType: BadgeAnimationType.scale,
                              badgeContent: Icon(
                                Icons.add_alert,
                                color: Colors.white,
                              ),
                              child: _boxContent()),
                        )
                      : _boxContent(),
                ),
              );
            }),
          );
        },
      )),
    );
  }
}
