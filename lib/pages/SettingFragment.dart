import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CarTypeStandardField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingFragment extends StatefulWidget {
  const SettingFragment({Key key}) : super(key: key);

  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController licenseTextController = TextEditingController();
  final _carTypeTextFieldKey = GlobalKey<CarTypeStandardFieldState>();
  List<PickerItem> truckTypeSelection;
  Driver driver;
  Future futureBuilder;

  Future<void> getInformation() async{
    try{
      List<TruckType> truckTypeList = await Request().getTrunckType();
      this.truckTypeSelection = UtilExtendsion.getTruckTypeSelection(truckTypeList);
      driver = await Request().getDriver();
      mobileTextController.text = driver.tel;
      licenseTextController.text = driver.default_Truck_No;
    }catch(e){
      throw e;
    }
  }

  @override
  void initState() {
    futureBuilder = getInformation();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBuilder,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: Util.responsiveSize(context, 24)),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: Util.responsiveSize(context, 24),
                  ),
                  Text(
                    "Read Only".tr(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: Util.responsiveSize(context, 18)),
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 24),
                  ),
                  MobileStandardTextField(//NO Country Code
                    mobileTextController: mobileTextController,
                    enable: false,
                    initialPrefix: driver.countryCode,
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 24),
                  ),
                  Text(
                    "Default Car - Optional".tr(),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: Util.responsiveSize(context, 18)),
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 12),
                  ),
                  CarTypeStandardField(
                    initCarType: driver.default_Truck_Type,
                    textController: licenseTextController,
                    key: _carTypeTextFieldKey,
                    onPress: (String selectedCarType) {}, truckTypeSelection: this.truckTypeSelection
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  StandardElevatedButton(
                    backgroundColor: UtilExtendsion.mainColor,
                    text: "Submit".tr(),
                    onPress: ()async {
                      try{
                        Util.showLoadingDialog(context);
                        await Request().updateSetting(tel: mobileTextController.text, countryCode: driver.countryCode, default_Truck_No: licenseTextController.text, default_Truck_Type: _carTypeTextFieldKey.currentState.carType);
                        await UtilExtendsion.initDriver();
                        Navigator.pop(context);
                        Util.showAlertDialog(context, "",  title: "Update Successfully".tr());
                      }catch(error){
                        Navigator.pop(context);
                        Util.showAlertDialog(context, error.toString());
                      }
                    },
                  ),
                  SizedBox(
                    height: Util.responsiveSize(context, 12),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(child: PlatformCircularProgressIndicator());
        }
      },
    );
  }
}
