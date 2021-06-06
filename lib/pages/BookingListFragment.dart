import 'package:docking_project/Model/Booking.dart';
import 'package:docking_project/Util/FlutterRouter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_basecomponent/BaseRouter.dart';

class BookingListFragment extends StatefulWidget {
  const BookingListFragment({Key key}) : super(key: key);

  @override
  _BookingListFragmentState createState() => _BookingListFragmentState();
}

class _BookingListFragmentState extends State<BookingListFragment> {
  List<Booking> bookingList = [
    new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.ARRIVED,
    ),
    new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.PENDING,
    ),
    new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.PENDING,
    ),
    new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.EXPIRED,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.EXPIRED,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.ARRIVED,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.PENDING,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.EXPIRED,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.ARRIVED,
    ),new Booking(
      bookingTime: DateTime.now(),
      warehouse: "長沙灣",
      license: "AA1234",
      carType: "貨車",
      status: BookingStatus.ARRIVED,
    )
  ];

  String convertStatusToDisplay(BookingStatus status) {
    switch (status) {
      case BookingStatus.ARRIVED:
        return "Arrived".tr();
      case BookingStatus.EXPIRED:
        return "Expired".tr();
      case BookingStatus.PENDING:
        return "Pending".tr();
    }
    return "";
  }

  Color convertStatusToColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.ARRIVED:
        return Colors.grey;
      case BookingStatus.EXPIRED:
        return Colors.red;
      case BookingStatus.PENDING:
        return Colors.green;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimationLimiter(
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
                      onTap: (){
                        FlutterRouter().goToPage(context, Pages("BookingDetailPage"));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Util.responsiveSize(context, 8),
                            horizontal: Util.responsiveSize(context, 24)),
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(Util.responsiveSize(context, 8)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.schedule,
                                            size: Util.responsiveSize(context, 16)),
                                        SizedBox(
                                          width: Util.responsiveSize(context, 8),
                                        ),
                                        Text(
                                          new DateFormat('yyyy-MM-dd hh:mm')
                                              .format(bookingList[index].bookingTime),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Util.responsiveSize(context, 16)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            Util.responsiveSize(context, 8)),
                                        child: Text(
                                          convertStatusToDisplay(
                                              bookingList[index].status),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: convertStatusToColor(
                                              bookingList[index].status),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.store,
                                        size: Util.responsiveSize(context, 14),
                                        color: Colors.black87),
                                    Text(
                                      bookingList[index].warehouse,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: Util.responsiveSize(context, 14)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.car_repair,
                                        size: Util.responsiveSize(context, 14),
                                        color: Colors.black87),
                                    Text(
                                      bookingList[index].carType +
                                          "(" +
                                          bookingList[index].license +
                                          ")",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: Util.responsiveSize(context, 14)),
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
                                  offset: Offset(0, 3), // changes position of shadow
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
  }
}
