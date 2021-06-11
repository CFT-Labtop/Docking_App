class TimeSlot{
  String timeSlotId;
  String startTime;
  String endTime;
  bool isAvailable;

  TimeSlot.fromJson(Map json){
    this.timeSlotId = json["timeSlotId"] ?? null;
    this.startTime = json ["startTime"] ?? null;
    this.endTime = json ["endTime"] ?? null;
    this.isAvailable = json ["isAvailable"] ?? false;
  }
}