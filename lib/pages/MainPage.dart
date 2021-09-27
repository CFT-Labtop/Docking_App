import 'package:dio/dio.dart';
import 'package:docking_project/Model/News.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainPage extends StatefulWidget {
  final int initIndex;
  const MainPage({Key key, this.initIndex = 1}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _currentIndex = 1;
  PageController _pageViewcontroller = new PageController();
  bool isLoading = false;
  String whatsappContactPhone = null;
  GlobalKey<BookingListFragmentState> _bookingListKey = GlobalKey<BookingListFragmentState>();
  GlobalKey<SettingFragmentState> _settingKey = GlobalKey<SettingFragmentState>();

  void showLanguageButton() {
    new Picker(
        itemExtent: Util.responsiveSize(context, 50),
        columnPadding: EdgeInsets.symmetric(horizontal: 0),
        adapter: PickerDataAdapter(data: [
          new PickerItem(text: Text("繁體中文"), value: "Traditional Chinese"),
          new PickerItem(text: Text("简体中文"), value: "Simplified Chinese"),
          new PickerItem(text: Text("English"), value: "English")
        ]),
        hideHeader: true,
        title: new Text("Please Select Language".tr()),
        textStyle: TextStyle(
            color: Colors.black, fontSize: Util.responsiveSize(context, 19)),
        cancelText: "Cancel".tr(),
        confirmText: "Confirm".tr(),
        onConfirm: (Picker picker, List value) async{
          Util.showLoadingDialog(context);
          switch (picker.getSelectedValues()[0]) {
            case "English":
              context.locale = Locale('en', 'US');
              await Request().changeLanguage(context, Locale('en', 'US'));
              break;
            case "Simplified Chinese":
              context.locale = Locale('zh', 'CN');
              await Request().changeLanguage(context, Locale('zh', 'CN'));
              break;
            case "Traditional Chinese":
              context.locale = Locale('zh', 'HK');
              await Request().changeLanguage(context, Locale('zh', 'HK'));
              break;
          }
          if(_currentIndex == 1)
            await _bookingListKey.currentState.refreshPage();
          else if (_currentIndex == 2){
            await _settingKey.currentState.refreshPage();
          }
          Navigator.pop(context);
          setState(() {});
        }).showDialog(context);
  }

  void showLatestNews() async {
    List<News> newsList = [];
    try {
      Util.showLoadingDialog(context);
      newsList = await Request().getLatestNews(context, context.locale);
      Navigator.pop(context);
    } catch (error) {
      Navigator.pop(context);
      Util.showAlertDialog(context, error.toString());
    }
    showPlatformDialog(
        context: context,
        builder: (_) => AlertDialog(
              actions: [
                TextButton(
                  child: Text("Cancel".tr()),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
              content: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .5,
                child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding:
                              EdgeInsets.all(Util.responsiveSize(context, 4)),
                          child: ListView(
                            children: [
                              Text(
                                newsList[index].subject,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Util.responsiveSize(context, 32),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  height: Util.responsiveSize(context, 12)),
                              Html(data: newsList[index].content)
                            ],
                          ));
                    },
                    itemCount: newsList.length,
                    pagination: new SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            activeColor: UtilExtendsion.mainColor,
                            color: Colors.grey))),
              ),
            ));
  }

  Widget myPopMenu() {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton(
          onSelected: (value) async {
            switch (value) {
              case 1:
                showLanguageButton();
                break;
              case 2:
                var connectivityResult =
                    await (Connectivity().checkConnectivity());
                if (connectivityResult == ConnectivityResult.none) {
                  Util.showAlertDialog(context, "",
                      title: "Unstable Network".tr());
                } else {
                  showLatestNews();
                }
                break;
              case 3:
                launch("https://dkmsweb-prod.sunhinggroup.com/support");
                break;
              case 4:
                final newVersion = NewVersion(
                  iOSId: 'com.cft.docking',
                  androidId: 'com.cft.docking_project',
                );
                final status = await newVersion.getVersionStatus();
                Util.showAlertDialog(context, status.localVersion,
                    title: "Current Version".tr());
                break;
              case 5:
                var whatsappUrl = "whatsapp://send?phone=" + this.whatsappContactPhone;
                launch(whatsappUrl);
                break;
              case 6:
                Util.showConfirmDialog(context, onPress: () async {
                  Request().logout(context,Util.sharedPreferences.getString("Authorization"));
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
          itemBuilder: (context) => getPopItem()),
    );
  }

  List<PopupMenuEntry<dynamic>> getPopItem() {
    if(this.whatsappContactPhone != null && this.whatsappContactPhone.isNotEmpty)
      return [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
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
                  child: Icon(Icons.tungsten, color: Colors.black),
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
                  child: Icon(Icons.contact_support, color: Colors.black),
                ),
                Text('Support'.tr())
              ],
            )),
        PopupMenuItem(
            value: 4,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.perm_device_information, color: Colors.black),
                ),
                Text('About'.tr())
              ],
            )),
        PopupMenuItem(
            value: 5,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.call, color: Colors.black),
                ),
                Text('Whatsapp Enquiry'.tr())
              ],
            )),
        PopupMenuItem(
            value: 6,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.logout, color: Colors.black),
                ),
                Text('Logout'.tr())
              ],
            )),
      ];
    else
      return [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(
                    Icons.language,
                    color: Colors.black,
                  ),
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
                  child: Icon(Icons.tungsten, color: Colors.black),
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
                  child: Icon(Icons.contact_support, color: Colors.black),
                ),
                Text('Support'.tr())
              ],
            )),
        PopupMenuItem(
            value: 4,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.perm_device_information, color: Colors.black),
                ),
                Text('About'.tr())
              ],
            )),
        PopupMenuItem(
            value: 6,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(Icons.logout, color: Colors.black),
                ),
                Text('Logout'.tr())
              ],
            )),
      ];
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await Request().renewToken(context);
  //     setState(() {
  //       isLoading = false;
  //       _pageViewcontroller = new PageController(initialPage: _currentIndex);
  //     });
  //   }
  // }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await UtilExtendsion.checkForUpdate(context);
      await Request().renewToken(context);
      Map<String, dynamic> whatsappMobileConfig = await UtilExtendsion.getConfigItem(context,"ContactPhoneNo");
      this.whatsappContactPhone = whatsappMobileConfig["configValue"];
      _currentIndex = widget.initIndex;
      _pageViewcontroller.jumpToPage(widget.initIndex);
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Scaffold(
            body: Center(
              child: PlatformCircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: StandardAppBar(
                text: "Dock Booking System".tr(),
                fontColor: Colors.white,
                backgroundColor: UtilExtendsion.mainColor,
                trailingActions: [
                  myPopMenu(),
                ],
                hasLeading: false),
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
                    activeIcon:
                        Icon(Icons.schedule, color: UtilExtendsion.mainColor),
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
                BookingListFragment(key: _bookingListKey,),
                SettingFragment(key: _settingKey)
              ],
            )),
          );
  }
}
