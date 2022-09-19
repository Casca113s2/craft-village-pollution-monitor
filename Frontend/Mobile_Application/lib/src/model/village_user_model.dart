class VillageUser{
  int wardId;
  int villageId;
  int districtId;
  int provinceId;
  String villageNote;
  String villageName;
  int hasAdded;
  String coordinate;
  VillageUser({this.wardId, this.villageId, this.districtId, this.provinceId, this.villageNote, this.villageName, this.hasAdded, this.coordinate});
  factory VillageUser.fromJson(Map json) {
    return VillageUser(
      wardId: int.parse(json['wardId']),
      //answerContent: (json['answerContent'] as String).split("_") ?? ["999 đóa hoa hồng"],
      villageId: int.parse(json['villageId']),
      districtId: int.parse(json['districtId']),
      provinceId: int.parse(json['provinceId']),
      villageNote: json['villageNote'],
      villageName: json['villageName'],
      hasAdded: int.parse(json['hasAdded']),
      coordinate: json['coordinate']
    );
  }
}