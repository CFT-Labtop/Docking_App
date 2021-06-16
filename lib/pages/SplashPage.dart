import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo.png", height: Util.responsiveSize(context, 120),),
      )
    );
  }
}
