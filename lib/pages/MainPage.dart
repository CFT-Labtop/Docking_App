import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/pages/BookingListFragment.dart';
import 'package:docking_project/pages/SettingFragment.dart';
import 'package:docking_project/pages/ShipmentFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:flutter_basecomponent/Util.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  PageController _pageViewcontroller = new PageController();

  void showLanguageButton() {
    new Picker(
        columnPadding: EdgeInsets.symmetric(horizontal: 0),
        adapter: PickerDataAdapter(data: [
          new PickerItem(
              text: Text("Traditional Chinese".tr()),
              value: "Traditional Chinese"),
          new PickerItem(
              text: Text("Simplified Chinese".tr()),
              value: "Simplified Chinese"),
          new PickerItem(text: Text("English".tr()), value: "English")
        ]),
        hideHeader: true,
        title: new Text("Please Select Language".tr()),
        textStyle: TextStyle(
            color: Colors.black, fontSize: Util.responsiveSize(context, 19)),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) {
          switch (picker.getSelectedValues()[0]) {
            case "English":
              context.locale = Locale('en', 'US');
              break;
            case "Simplified Chinese":
              context.locale = Locale('zh', 'CN');
              break;
            case "Traditional Chinese":
              context.locale = Locale('zh', 'HK');
              break;
          }
        }).showDialog(context);
  }

  Widget myPopMenu() {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 1:
                showLanguageButton();
                break;
              case 3:
                Util.showConfirmDialog(context, onPress: () {
                  Util.sharedPreferences.clear();
                  FlutterRouter()
                      .goToPage(context, Pages("FirstPage"), clear: true);
                }, title: "Confirm To Logout?".tr());
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
                          child: Icon(Icons.language),
                        ),
                        Text('Language'.tr())
                      ],
                    )),
                PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.tungsten),
                        ),
                        Text('Latest News'.tr())
                      ],
                    )),
                PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                          child: Icon(Icons.logout),
                        ),
                        Text('Logout'.tr())
                      ],
                    )),
              ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: "Dock Booking System".tr(),
        fontColor: Colors.white,
        backgroundColor: UtilExtendsion.mainColor,
        trailingActions: [
          myPopMenu(),
        ],
      ),
      bottomNavigationBar: PlatformNavBar(
        currentIndex: _currentIndex,
        itemChanged: (index) => setState(
          () {
            _currentIndex = index;
            _pageViewcontroller.jumpToPage(index);
          },
        ),
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.book_online_outlined,
                color: UtilExtendsion.mainColor,
              ),
              icon: Icon(Icons.book_online_outlined),
              title: Text("New Booking".tr(),
                  style: TextStyle(color: UtilExtendsion.mainColor))),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.schedule, color: UtilExtendsion.mainColor),
              icon: Icon(Icons.schedule),
              title: Text(
                "Current Bookings".tr(),
                style: TextStyle(color: UtilExtendsion.mainColor),
              )),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.settings,
                color: UtilExtendsion.mainColor,
              ),
              icon: Icon(Icons.settings),
              title: Text("Settings".tr(),
                  style: TextStyle(color: UtilExtendsion.mainColor))),
        ],
      ),
      body: SafeArea(
          child: PageView(
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        controller: _pageViewcontroller,
        children: [
          ShipmentFragment(),
          BookingListFragment(),
          SettingFragment()
        ],
      )),
    );
  }
}
