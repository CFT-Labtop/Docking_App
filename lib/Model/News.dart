class News{
  String type;
  String subject;
  String content;
  String expireTime;

  News.fromJson(Map json){
    this.type = json["type"] ?? null;
    this.subject = json ["subject"] ?? null;
    this.content = json ["content"] ?? null;
    this.expireTime = json ["expireTime"] ?? false;
  }
}