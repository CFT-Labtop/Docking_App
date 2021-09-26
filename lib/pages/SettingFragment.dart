import 'package:docking_project/Model/Driver.dart';
import 'package:docking_project/Model/TruckClient.dart';
import 'package:docking_project/Model/TruckCompany.dart';
import 'package:docking_project/Model/TruckType.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/CHHKSwitch.dart';
import 'package:docking_project/Widgets/CarTypePullDown.dart';
import 'package:docking_project/Widgets/ClientTypePullDown.dart';
import 'package:docking_project/Widgets/LicenseStandardTextField.dart';
import 'package:docking_project/Widgets/MobileStandardTextField.dart';
import 'package:docking_project/Widgets/StandardElevatedButton.dart';
import 'package:docking_project/Widgets/TruckCompanyPullDown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_picker/Picker.dart';

class SettingFragment extends StatefulWidget {
  const SettingFragment({Key key}) : super(key: key);

  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController licenseTextController = TextEditingController();
  final _carTypeKey = GlobalKey<CarTypePullDownState>();
  final _chhkKey = GlobalKey<CHHKSwitchState>();
  final _truckCompanyKey = GlobalKey<TruckCompanyPullDownState>();
  final _truckClientKey = GlobalKey<ClientTypePullDownState>();
  List<PickerItem> truckTypeSelection;
  List<PickerItem> truckCompanySelection = [];
  List<PickerItem> truckClientSelection = [];
  Driver driver;
  Future futureBuilder;
  FocusNode _focusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<void> getInformation() async {
    try {
      List<TruckType> truckTypeList =await Request().getTrunckType(context, context.locale);
      List<TruckCompany> truckCompanyList = await Request().getTruckCompany(context, context.locale);
      List<TruckClient> truckClientList = await Request().getTruckClient(context, context.locale);
      this.truckTypeSelection =UtilExtendsion.getTruckTypeSelection(truckTypeList);
      this.truckCompanySelection =UtilExtendsion.getTruckCompanySelection(truckCompanyList);
      this.truckClientSelection =UtilExtendsion.getTruckClientSelection(truckClientList);
      driver = await Request().getDriver(context: context);
      mobileTextController.text = driver.tel;
      licenseTextController.text = driver.default_Truck_No;
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        futureBuilder = getInformation();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBuilder,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
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
                              MobileStandardTextField(
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
                              CarTypePullDown(
                                initValue: driver.default_Truck_Type,
                                truckTypeSelection: truckTypeSelection,
                                key: _carTypeKey,
                                onSelected: (String selectedValue, String selectedLabel) {
                                  _focusNode.requestFocus();
                                },
                              ),
                              SizedBox(
                                height: Util.responsiveSize(context, 24),
                              ),
                              ClientTypePullDown(initValue: driver.default_Client_ID, clientTypeSelection: truckClientSelection, key: _truckClientKey,),
                              SizedBox(
                                height: Util.responsiveSize(context, 24),
                              ),
                              TruckCompanyPullDown(initValue: driver.default_Company_ID, truckCompanySelection: truckCompanySelection, key: _truckCompanyKey,),
                              SizedBox(
                                height: Util.responsiveSize(context, 24),
                              ),
                              LicenseStandardTextField(
                                textController: licenseTextController,
                                focusNode: _focusNode,
                              ),
                              SizedBox(
                                height: Util.responsiveSize(context, 24),
                              ),
                              CHHKSwitch(initValue: driver.default_Is_CH_HK_Truck, key: _chhkKey,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                          StandardElevatedButton(
                            backgroundColor: UtilExtendsion.mainColor,
                            text: "Submit".tr(),
                            onPress: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  Util.showLoadingDialog(context);
                                  await Request().updateSetting(context,
                                      tel: mobileTextController.text,
                                      countryCode: driver.countryCode,
                                      default_Truck_No: licenseTextController.text,
                                      default_Truck_Type: _carTypeKey.currentState.selectedValue,
                                      default_Is_CH_HK_Truck: _chhkKey.currentState.value,
                                      default_Client_ID: _truckClientKey.currentState.selectedValue,
                                      default_Company_ID: _truckCompanyKey.currentState.selectedValue);
                                  await UtilExtendsion.initDriver();
                                  await getInformation();
                                  Navigator.pop(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Util.showAlertDialog(context, "",
                                      title: "Update Successfully".tr());
                                } catch (error) {
                                  Navigator.pop(context);
                                  Util.showAlertDialog(context, error.toString());
                                }
                              }
                            }),
                        SizedBox(
                          height: Util.responsiveSize(context, 12),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
