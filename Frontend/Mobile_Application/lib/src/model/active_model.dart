
class ActiveUser {
  String activeCode;
  String activeDate;
  ActiveUser({this.activeCode, this.activeDate});
  factory ActiveUser.fromJson(Map json) {
    return ActiveUser(
      activeCode: json['ActiveCode'],
      activeDate: json['ActiveDate'],
    );
  }
}