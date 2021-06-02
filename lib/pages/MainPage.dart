import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:docking_project/Widgets/StandardAppBar.dart';
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
          },
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.schedule)),
          BottomNavigationBarItem(icon: Icon(Icons.settings)),
        ],
      ),
      body: SafeArea(
        child: PageView(
          children: [
            NewBookingFragment()
          ],
        )
      ),
    );
  }
}
