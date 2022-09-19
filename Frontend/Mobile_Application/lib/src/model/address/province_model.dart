class Province{
  int provinceId;
  String provinceCode;
  String provinceName;
 
  Province({this.provinceId, this.provinceCode, this.provinceName});
  factory Province.fromJson(Map json) {
    return Province(
      provinceId: json['provinceId'],
      //answerContent: (json['answerContent'] as String).split("_") ?? ["999 đóa hoa hồng"],
      provinceCode: json['provinceCode'] ,
      provinceName: json['provinceName'],
    );
  }
}