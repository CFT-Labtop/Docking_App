import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroductionSwiper extends StatelessWidget {
  final List<SwiperComponent> listComponents;
  const IntroductionSwiper({Key key, this.listComponents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(Util.responsiveSize(context, 42)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  listComponents[index].icon,
                  color: Colors.white,
                  size: Util.responsiveSize(context, 100),
                ),
                SizedBox(
                  height: Util.responsiveSize(context, 48),
                ),
                Text(
                  listComponents[index].text.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Util.responsiveSize(context, 20)),
                  textAlign: TextAlign.center,
                ).tr()
              ],
            ),
          );
        },
        itemCount: listComponents.length,
        pagination: new SwiperPagination(builder: DotSwiperPaginationBuilder(
          activeColor: Colors.amber
        )),
        control: new SwiperControl(color: Colors.white),
      ),
    );
  }
}

class SwiperComponent {
  String text;
  IconData icon;
  SwiperComponent(this.text, this.icon);
}
