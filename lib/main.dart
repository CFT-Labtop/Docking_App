import 'package:docking_project/pages/LoginPage.dart';
import 'package:docking_project/pages/VerificationPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_basecomponent/Util.dart';
import 'Util/FlutterRouter.dart';

Future<void> main() async {
  FlutterRouter().configureRoutes();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: [
        // Locale('en', 'US'),
        // Locale('zh', 'CN'),
        Locale('zh', 'HK')
      ],
      path: 'assets/translations', // <-- change patch to your
      fallbackLocale: Locale('zh', 'HK'),
      child: RouterPage()));
}

class RouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(microseconds: 250)),
      builder: (context, AsyncSnapshot snapshot) {
        return MaterialApp(
            title: 'Docking',
            theme: ThemeData(
              primaryColor: Util.mainColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: VerificationPage(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            onGenerateRoute: FlutterRouter().fluroRouter.generator);
      },
    );
  }
}
