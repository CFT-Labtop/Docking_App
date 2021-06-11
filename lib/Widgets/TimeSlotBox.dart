import 'package:flutter/material.dart';
import 'package:flutter_basecomponent/Util.dart';

class TimeSlotBox extends StatelessWidget {
  final TimeSlotType timeSlotType;
  final String timeText;
  final void Function(String timeText, TimeSlotType timeSlotType) onPress;
  const TimeSlotBox({ Key key, @required this.timeSlotType, @required this.timeText, this.onPress }) : super(key: key);

  Color getColor(){
    switch(timeSlotType){
      case TimeSlotType.SELECTED:
        return Colors.blue;
      case TimeSlotType.AVAILABLE:
        return Colors.green;
      case TimeSlotType.DISABLED:
        return Colors.grey;
    }
    return Colors.red;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPress(timeText, timeSlotType);
      },
      child: Container(
        color: getColor(),
        child: Center(child: Text(timeText, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: Util.responsiveSize(context, 22),))),
      ),
    );
  }
}

enum TimeSlotType{
  SELECTED,
  AVAILABLE,
  DISABLED
}