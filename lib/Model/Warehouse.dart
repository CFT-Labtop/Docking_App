class Warehouse{
  int warehouse_ID;
  String warehouse_Code;
  String warehouse_Name;
  String msg_Booked;
  String msg_Dock;

  Warehouse.fromJson(Map json){
    this.warehouse_ID = json["warehouse_ID"] ?? null;
    this.warehouse_Code = json ["warehouse_Code"] ?? null;
    this.warehouse_Name = json ["warehouse_Name"] ?? null;
    this.msg_Booked = json ["msg_Booked"] ?? null;
    this.msg_Dock = json ["msg_Dock"] ?? null;
  }
}