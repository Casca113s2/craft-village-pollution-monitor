
class TypeUserModel {
  String id;
  String nameType;
  
  TypeUserModel({this.id, this.nameType});

  factory TypeUserModel.fromJson(Map json) {
    return TypeUserModel(
      id: json['id'],
      nameType: json['nameType'],
    );
  }
}