import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';

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
                  padding: EdgeInsets.all(Util.responsiveSize(context, 16.0)),
                  child: Column(children: [
                    Text(
                      '2021 年 五月 十一日',
                      style: TextStyle(
                          fontSize: Util.responsiveSize(context, 18.0)),
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    Text(
                      '12:00',
                      style: TextStyle(
                          fontSize: Util.responsiveSize(context, 24.0)),
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Car Number".tr(),
                            style: TextStyle(
                                fontSize: Util.responsiveSize(context, 18.0))),
                        Text('HD1234',
                            style: TextStyle(
                                fontSize: Util.responsiveSize(context, 18.0)))
                      ],
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Car Type".tr(),
                            style: TextStyle(
                                fontSize: Util.responsiveSize(context, 18.0))),
                        Text('40\'',
                            style: TextStyle(
                                fontSize: Util.responsiveSize(context, 18.0)))
                      ],
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    QrImage(
                      data: "DummyData",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    Text("Reference Number".tr(),
                        style: TextStyle(
                            fontSize: Util.responsiveSize(context, 18.0))),
                    Text("202105101023".tr(),
                        style: TextStyle(
                            fontSize: Util.responsiveSize(context, 18.0))),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    StandardElevatedButton(
                      backgroundColor: UtilExtendsion.mainColor,
                      text: "Arrive".tr(),
                      onPress: () {},
                    ),
                    SizedBox(
                      height: Util.responsiveSize(context, 10),
                    ),
                    StandardElevatedButton(
                      backgroundColor: Colors.red,
                      text: "Delete".tr(),
                      onPress: () {},
                    )
                  ]))
            ]))));
  }
}
