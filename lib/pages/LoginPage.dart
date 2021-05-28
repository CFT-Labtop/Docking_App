import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:docking_project/Util/UtilExtendsion.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget header() {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.2,
      child: Container(
        color: Colors.white,
        child: Center(
            child: Text(
          "Dock Booking System",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: Util.responsiveSize(context, 40.0),
              fontWeight: FontWeight.bold,
              color: UtilExtendsion.mainColor),
        ).tr()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: UtilExtendsion.mainColor,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Flexible(child: header()),
              // Spacer(),
              // Container(
              //   color: Colors.red,
              //   height: 20,
              //   width: 20
              // )
              // Expanded(
              //     child: Container(
              //     color: Colors.red,
              //     width: double.infinity,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         RaisedButton(
              //           padding: EdgeInsets.all(16.0),
              //           color: Colors.white,
              //           onPressed: () {},
              //           child: Text(
              //             "New Driver Register",
              //             style: TextStyle(
              //                 fontSize: Util.responsiveSize(context, 28)),
              //           ).tr(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ]),
          )),
    );
  }
}
