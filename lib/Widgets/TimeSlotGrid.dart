import 'package:docking_project/Model/TimeSlot.dart';
import 'package:docking_project/Widgets/TimeSlotBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TimeSlotGrid extends StatefulWidget {
  final List<TimeSlot> timeSlotList;
  final Function(int index, TimeSlot selectedTimeSlot) onSelected;
  final int selectedIndex;
  const TimeSlotGrid({Key key, @required this.timeSlotList, @required this.onSelected, this.selectedIndex = -1}) : super(key: key);

  @override
  _TimeSlotGridState createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends State<TimeSlotGrid> {

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

  TimeSlotType getTimeSlotType(TimeSlot timeSlot, int index){
    if(!timeSlot.isAvailable)
      return TimeSlotType.DISABLED;
    return widget.selectedIndex == index?  TimeSlotType.SELECTED : TimeSlotType.AVAILABLE;
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
                widget.timeSlotList.length,
                (index) => AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 4,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: TimeSlotBox(
                            timeSlotType: getTimeSlotType(widget.timeSlotList[index], index),
                            timeText: widget.timeSlotList[index].startTime.substring(0,5),
                            onPress: (String text, TimeSlotType timeSlotType) {
                              if(timeSlotType != TimeSlotType.DISABLED){
                                  widget.onSelected(index, widget.timeSlotList[index]);
                              }
                              // widget.onSelected(widget.timeSlotList[index]);
                            },
                          ),
                        ),
                      ),
                    ))),
      ),
    );
  }
}
