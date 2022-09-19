class Ward{
  int wardId;
  String wardCode;
  String wardName;
 
  Ward({this.wardId, this.wardCode, this.wardName});
  factory Ward.fromJson(Map json) {
    return Ward(
      wardId: json['wardId'],
      wardCode: json['wardCode'] ,
      wardName: json['wardName'],
    );
  }
}