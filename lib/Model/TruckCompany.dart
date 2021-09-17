class TruckCompany{
  int companyID;
  String companyName;

  TruckCompany.fromJson(Map json){
    this.companyID = json["companyID"] ?? null;
    this.companyName = json ["companyName"] ?? null;
  }
}