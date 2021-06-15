import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:docking_project/Util/Request.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookingListFragment extends StatefulWidget {
  const BookingListFragment({Key key}) : super(key: key);

  @override
  _BookingListFragmentState createState() => _BookingListFragmentState();
}

class _BookingListFragmentState extends State<BookingListFragment> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Booking> bookingList = [];
  Future futureBuilder;

  Color convertStatusToColor(String status) {
    switch (status) {
      case "Arrived":
        return Colors.grey;
      case "Booked":
        return Colors.green;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    futureBuilder = getBookingList();
    super.initState();
  }

  Future<void> getBookingList() async {
    bookingList = await Request().getBookingList(UtilExtendsion.getTel());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBuilder,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return UtilExtendsion.CustomFutureBuild(context, snapshot, () {
          return AnimationLimiter(
            child: SmartRefresher(
              header: WaterDropMaterialHeader(),
              controller: _refreshController,
              onRefresh: () async {
                await getBookingList();
                setState(() {
                  _refreshController.refreshCompleted();
                });
              },
              child: ListView.builder(
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 375),
                      position: index,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              FlutterRouter().goToPage(
                                  context, Pages("BookingDetailPage"),
                                  routeSettings: RouteSettings(
                                      arguments: this.bookingList[index]));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Util.responsiveSize(context, 8),
                                  horizontal: Util.responsiveSize(context, 24)),
                              child: Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      Util.responsiveSize(context, 8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.date_range,
                                                  size: Util.responsiveSize(
                                                      context, 16)),
                                              SizedBox(
                                                width: Util.responsiveSize(
                                                    context, 8),
                                              ),
                                              Text(
                                                bookingList[index]
                                                    .displayBookingDate(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        Util.responsiveSize(
                                                            context, 16)),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  Util.responsiveSize(
                                                      context, 8)),
                                              child: Text(
                                                bookingList[index]
                                                    .bookingStatus
                                                    .tr(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: convertStatusToColor(
                                                    bookingList[index]
                                                        .bookingStatus),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.schedule,
                                              size: Util.responsiveSize(
                                                  context, 14),
                                              color: Colors.black87),
                                          Text(
                                            bookingList[index].timeSlot,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: Util.responsiveSize(
                                                    context, 14)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.store,
                                              size: Util.responsiveSize(
                                                  context, 14),
                                              color: Colors.black87),
                                          Text(
                                            bookingList[index].warehouse,
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: Util.responsiveSize(
                                                    context, 14)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.car_repair,
                                              size: Util.responsiveSize(
                                                  context, 14),
                                              color: Colors.black87),
                                          Text(
                                            bookingList[index].showTruckAndLicense(),
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: Util.responsiveSize(
                                                    context, 14)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
      },
    );
  }
}
