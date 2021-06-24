import 'package:docking_project/Model/Warehouse.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/StandardPullDown.dart';
import 'package:docking_project/Widgets/WarehousePullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/flutter_picker.dart';
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
  final TextEditingController manualTextController = TextEditingController();
  final _warehouseKey = GlobalKey<WarehousePullDownState>();
  List<PickerItem> warehouseSelection;
  final _formKey = GlobalKey<FormState>();
  List<String> shipmentList = [];
  Future futureBuilder;
  

  Future<void> getWarehouse() async{
    List<Warehouse> warehouseList = await Request().getWarehouse(context);
    this.warehouseSelection = warehouseList.map((e) => new PickerItem(text: Text(e.warehouse_Name), value: e.warehouse_ID)).toList();
  }

  @override
  void initState() {
    futureBuilder = getWarehouse();
    super.initState();
    
  }

  void addShipment(String shipNo){
    try{
      if(shipmentList.firstWhere((element) => element == shipNo, orElse: () => null) != null)
        throw "Duplicated Shipment".tr();
      else if(shipmentList.length +1 > 50)
        throw "Limited 50 Shipment Per Booking".tr();
    else
      shipmentList.add(shipNo);  
    }catch(error){
      Util.showAlertDialog(context, "", title: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBuilder,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
          return Column(
            children: [
              SizedBox(
                height: Util.responsiveSize(context, 24),
              ),
              WarehousePullDown(warehouseSelection: warehouseSelection, key: _warehouseKey,initValue: UtilExtendsion.getPreviouseWarehouse() ?? null,),
              SizedBox(
                height: Util.responsiveSize(context, 24),
              ),
              Text(
                "Please Scan QRCode To Input Shipment",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: Util.responsiveSize(context, 24)),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                          if (shipmentNo != null &&
                              shipmentNo.code != "" &&
                              shipmentNo.code != null)
                            setState(() {
                              addShipment(shipmentNo.code);
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
                                          onPressed: () =>
                                              Navigator.pop(context),
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
                                  autofocus: true,
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
                                      if (manualTextController.text != "" &&manualTextController.text != null)
                                        setState(() {
                                          addShipment(manualTextController.text);
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
                onPress: () async{
                  try{
                    Util.showLoadingDialog(context);
                    if(_warehouseKey.currentState.selectedValue == null)
                      throw "Warehouse Cannot Be Empty".tr();
                    Navigator.pop(context);
                    await FlutterRouter().goToPage(context, Pages("NewBookingPage"), parameters: "/" + _warehouseKey.currentState.selectedValue.toString(), routeSettings: RouteSettings(arguments: this.shipmentList));
                    setState(() {shipmentList = [];});
                  }catch(error){
                    Navigator.pop(context);
                    Util.showAlertDialog(context, error.toString());
                  }
                },
              ),
              SizedBox(
                height: Util.responsiveSize(context, 12),
              ),
            ],
          );
        });
      },
    );
  }
}
