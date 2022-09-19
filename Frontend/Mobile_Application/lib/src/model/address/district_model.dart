class District{
  int districtId;
  String districtCode;
  String districtName;
 
  District({this.districtId, this.districtCode, this.districtName});
  factory District.fromJson(Map json) {
    return District(
      districtId: json['districtId'],
      districtCode: json['districtCode'] ,
      districtName: json['districtName'],
    );
  }
}