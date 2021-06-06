import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ShipmentFragment extends StatefulWidget {
  const ShipmentFragment({Key key}) : super(key: key);

  @override
  _ShipmentFragmentState createState() => _ShipmentFragmentState();
}

class _ShipmentFragmentState extends State<ShipmentFragment> {
  final TextEditingController wareHouseTextController = TextEditingController();
  final TextEditingController manualTextController = TextEditingController();
  List<String> shipmentList = [
    "1120-CMSHK",
    "1121-CMSHK",
    "1122-CMSHK",
    "1123-CMSHK"
  ];
  String _carType = "車型";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Util.responsiveSize(context, 24),
        ),
        StandardPullDown(
          textController: wareHouseTextController,
          hintText: "Please Select Warehouse".tr(),
          arraySelection: "[[\"長沙灣長沙灣長沙灣長沙灣\",\"淺水灣\",\"何文田\"]]",
          dialogTitle: "Please Select Warehouse".tr(),
          onSelected: (String value) {
            wareHouseTextController.text = value;
          },
        ),
        SizedBox(
          height: Util.responsiveSize(context, 24),
        ),
        Text(
          "Please Scan QRCode To Input Shipment",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey, fontSize: Util.responsiveSize(context, 24)),
        ).tr(),
        Expanded(
          child: ListView.builder(
              itemCount: shipmentList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Util.responsiveSize(context, 12),
                      vertical: Util.responsiveSize(context, 6)),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Util.responsiveSize(context, 12)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(shipmentList[index]),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  shipmentList.removeAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      )),
                );
              }),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Util.responsiveSize(context, 12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StandardElevatedButton(
                backgroundColor: Colors.green,
                text: "Scan".tr(),
                padding: EdgeInsets.symmetric(
                    horizontal: Util.responsiveSize(context, 48),
                    vertical: Util.responsiveSize(context, 12)),
                onPress: () async {
                  if (await Permission.camera.request().isGranted) {
                    Barcode shipmentNo = await FlutterRouter()
                        .goToPage(context, Pages("ScanQRCodePage"));
                    if (shipmentNo != null && shipmentNo.code != "" && shipmentNo.code != null)
                      setState(() {
                        shipmentList.add(shipmentNo.code);
                      });
                  } else {
                    showPlatformDialog(
                        context: context,
                        builder: (_) => PlatformAlertDialog(
                                title: Text("Camera Permission".tr()),
                                content: Text(
                                    'Request For Camera Permission For Scanning QR Code'
                                        .tr()),
                                actions: <Widget>[
                                  PlatformDialogAction(
                                    child: PlatformText("Deny".tr()),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  PlatformDialogAction(
                                    child: PlatformText("Allow".tr()),
                                    onPressed: () {
                                      openAppSettings();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ]));
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StandardElevatedButton(
                    backgroundColor: Colors.grey,
                    text: "Manual Input".tr(),
                    padding: EdgeInsets.symmetric(
                        horizontal: Util.responsiveSize(context, 24),
                        vertical: Util.responsiveSize(context, 12)),
                    onPress: () {
                      showPlatformDialog(
                        context: context,
                        builder: (_) => PlatformAlertDialog(
                          title: Text("Manual Input".tr()),
                          content: PlatformTextField(
                            controller: manualTextController,
                          ),
                          actions: <Widget>[
                            PlatformDialogAction(
                              child: PlatformText("Cancel".tr()),
                              onPressed: () => Navigator.pop(context),
                            ),
                            PlatformDialogAction(
                              child: PlatformText("Confirm".tr()),
                              onPressed: () {
                                Navigator.pop(context);
                                if (manualTextController.text != "" &&
                                    manualTextController.text != null)
                                  setState(() {
                                    shipmentList.add(manualTextController.text);
                                  });
                                manualTextController.clear();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: Util.responsiveSize(context, 12),
        ),
        Divider(
          color: Colors.black,
        ),
        StandardElevatedButton(
          backgroundColor: UtilExtendsion.mainColor,
          text: "Next".tr(),
          onPress: () {
            FlutterRouter().goToPage(context, Pages("NewBookingPage"));
          },
        ),
        SizedBox(
          height: Util.responsiveSize(context, 12),
        ),
      ],
    );
  }
}
