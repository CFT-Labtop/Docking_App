import 'package:docking_project/Model/News.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
              children: [
                Text(
                  listComponents[index].news.subject,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: Util.responsiveSize(context, 32),
                      fontWeight: FontWeight.bold),
                ),
                Html(
                  data: listComponents[index].news.content,
                ),
              ],
            ),
          );
        },
        itemCount: listComponents.length,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(activeColor: Colors.amber)),
        control: new SwiperControl(color: Colors.white),
      ),
    );
  }
}

class SwiperComponent {
  News news;
  SwiperComponent(this.news);
}
