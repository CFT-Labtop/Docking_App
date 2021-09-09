class TruckClient{
  int clientID;
  String clientName;

  TruckClient.fromJson(Map json){
    this.clientID = json["clientID"] ?? null;
    this.clientName = json ["clientName"] ?? null;
  }
}