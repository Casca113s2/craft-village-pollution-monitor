class Village{
  int villageId;
  String villageName;
  String coordinate;
  String note;
 
  Village({this.villageId, this.villageName, this.coordinate, this.note});
  factory Village.fromJson(Map json) {
    return Village(
      villageId: json['villageId'],
      villageName: json['villageName'] ,
      coordinate: json['coordinate'],
      note: json['note']
    );
  }
}