import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:flutter_basecomponent/Util.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({Key key}) : super(key: key);

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
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: Util.responsiveSize(context, 24),
          ),
          SlimyCard(
            color: UtilExtendsion.mainColor,
            width: MediaQuery.of(context).size.width * 0.8,
            topCardHeight: Util.responsiveSize(context, 500),
            bottomCardHeight: Util.responsiveSize(context, 230),
            borderRadius: 15,
            topCardWidget: Column(
              children: [
                Text(
                  "AFC2105210190001",
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
                  data: "DummyData", // TODO: get value from server
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: Util.responsiveSize(context, 200),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 32),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Booking Detail'.tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Util.responsiveSize(context, 24)),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
                detailTile(Icons.store, "長沙灣"),
                detailTile(Icons.car_repair, "貨車(AA1234)"),
                detailTile(Icons.schedule,
                    new DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()))
              ],
            ),
            slimeEnabled: true,
          )
        ],
      )),
    );
  }
}
