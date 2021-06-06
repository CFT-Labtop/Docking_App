import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_basecomponent/Util.dart';

class ScanQRCodePage extends StatefulWidget {
  const ScanQRCodePage({Key key}) : super(key: key);

  @override
  _ScanQRCodePageState createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isPermissionGranted = false;
  QRViewController controller;

Future<void> checkPermission() async {
  var status = await Permission.camera.status;
  if(status.isDenied)
    throw new Exception("No Camera Permission Granted");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: 'Scan'.tr(),
        backgroundColor: UtilExtendsion.mainColor,
        fontColor: Colors.white,
      ),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Camera Permission Not Granted".tr(),textAlign: TextAlign.center,  style: TextStyle(color: Colors.grey, fontSize: Util.responsiveSize(context, 24)),));
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ],
              );
            }
          } else {
            return PlatformCircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller?.dispose();
      Navigator.pop(context, scanData);
    });
  }
}
