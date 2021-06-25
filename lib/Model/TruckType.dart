class TruckType{
  String truck_Type;
  String typeName;
  int dock_Usage;
  int timeSlot_Usage;
  int seq;

  TruckType.fromJson(Map json){
    this.truck_Type = json["truck_Type"] ?? null;
    this.typeName = json ["typeName"] ?? null;
    this.dock_Usage = json ["dock_Usage"] ?? null;
    this.timeSlot_Usage = json ["timeSlot_Usage"] ?? null;
    this.seq = json ["seq"]?? null;
  }
}