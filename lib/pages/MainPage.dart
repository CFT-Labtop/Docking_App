import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
import 'package:docking_project/pages/BookingListFragment.dart';
import 'package:docking_project/pages/NewBookingFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:easy_localization/easy_localization.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  PageController _pageViewcontroller = new PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StandardAppBar(
        text: "Dock Booking System".tr(),
        fontColor: Colors.white,
        backgroundColor: UtilExtendsion.mainColor,
        trailingActions: [
          PlatformIconButton(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          )
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
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), title: Text("New Booking".tr())),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), title: Text("Current Bookings".tr())),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings".tr())),
        ],
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageViewcontroller,
          children: [
            NewBookingFragment(),
            BookingListFragment()
          ],
        )
      ),
    );
  }
}
