import 'package:docking_project/Widgets/TimeSlotBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TimeSlotGrid extends StatefulWidget {
  const TimeSlotGrid({Key key}) : super(key: key);

  @override
  _TimeSlotGridState createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<TimeSlotGrid> {
  int _selectedIndex = 0;
  List sampleListText = [
    "9:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00",
    "24:00",
  ];

  int getRowCount(){
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= Util.smallPhoneSize)
      return 3;
    else if (screenWidth <= Util.smallPadSize)
      return 4;
    else if (screenWidth <= Util.padRate)
      return 5;
    else
      return 6;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2.8,
      child: AnimationLimiter(
        child: GridView.count(
            crossAxisCount: getRowCount(),
            crossAxisSpacing: Util.responsiveSize(context, 12),
            mainAxisSpacing: Util.responsiveSize(context, 8),
            children: List.generate(
                sampleListText.length,
                (index) => AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 4,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: TimeSlotBox(
                            timeSlotType: _selectedIndex == index
                                ? TimeSlotType.SELECTED
                                : TimeSlotType.AVAILABLE,
                            timeText: sampleListText[index],
                            onPress: (String timeText) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ))),
      ),
    );
  }
}
