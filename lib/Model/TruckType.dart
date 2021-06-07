class TruckType{
  String truck_Type;
  String typeName_Ch;
  String typeName_En;
  int dock_Usage;
  int timeSlot_Usage;
  int seq;

  TruckType.fromJson(Map json){
    this.truck_Type = json["truck_Type"] ?? null;
    this.typeName_Ch = json ["typeName_Ch"] ?? null;
    this.typeName_En = json ["typeName_En"] ?? null;
    this.dock_Usage = json ["dock_Usage"] ?? null;
    this.timeSlot_Usage = json ["timeSlot_Usage"] ?? null;
    this.seq = json ["seq"]?? null;
  }
}