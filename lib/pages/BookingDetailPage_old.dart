import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Util/Constants.dart';

class BookingDetailPage extends StatefulWidget {
  @override
  _BookingDetailPage createState() => _BookingDetailPage();
}

class _BookingDetailPage extends State<BookingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StandardAppBar(
          text: 'Booking Detail'.tr(),
          backgroundColor: UtilExtendsion.mainColor,
          fontColor: Colors.white,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
                child: Column(children: [
              Padding(
                  padding: EdgeInsets.all(
                      Util.responsiveSize(context, Dimensions.pagePadding)),
                  child: Column(children: [
                    Text(
                      '2021 年 五月 十一日', // TODO: get value from server
                      style: TextStyle(
                          fontSize: Util.responsiveSize(context, Fonts.medium)),
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    Text(
                      '12:00', // TODO: get value from server
                      style: TextStyle(
                          fontSize:
                              Util.responsiveSize(context, Fonts.x_large)),
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Car Number".tr(),
                            style: TextStyle(
                                fontSize: Util.responsiveSize(
                                    context, Fonts.medium))),
                        Text('HD1234', // TODO: get value from server
                            style: TextStyle(
                                fontSize:
                                    Util.responsiveSize(context, Fonts.medium)))
                      ],
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Car Type".tr(),
                            style: TextStyle(
                                fontSize: Util.responsiveSize(
                                    context, Fonts.medium))),
                        Text('40\'', // TODO: get value from server
                            style: TextStyle(
                                fontSize:
                                    Util.responsiveSize(context, Fonts.medium)))
                      ],
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    QrImage(
                      data: "DummyData", // TODO: get value from server
                      version: QrVersions.auto,
                      size: Dimensions.qrCodeSize,
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    Text("Reference Number".tr(),
                        style: TextStyle(
                            fontSize:
                                Util.responsiveSize(context, Fonts.medium))),
                    Text("202105101023".tr(), // TODO: get value from server
                        style: TextStyle(
                            fontSize:
                                Util.responsiveSize(context, Fonts.medium))),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    StandardElevatedButton(
                      backgroundColor: UtilExtendsion.mainColor,
                      text: "Arrive".tr(),
                      onPress: () {}, // TODO: onPress handling
                    ),
                    SizedBox(
                      height:
                          Util.responsiveSize(context, Dimensions.itemPadding),
                    ),
                    StandardElevatedButton(
                      backgroundColor: Colors.red,
                      text: "Delete".tr(),
                      onPress: () {}, // TODO: onPress handling
                    )
                  ]))
            ]))));
  }
}
