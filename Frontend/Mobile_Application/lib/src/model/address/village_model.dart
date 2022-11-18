class Village{
  int villageId;
  String villageName;
  String coordinate;
  String note;
  String provinceId;
  String districtId;
  String wardId;
 
  Village({this.villageId, this.villageName, this.coordinate, this.note, this.provinceId, this.districtId, this.wardId});
  factory Village.fromJson(Map json) {
    return Village(
      villageId: json['villageId'],
      villageName: json['villageName'] ,
      coordinate: json['coordinate'],
      note: json['note']
    );
  }
}