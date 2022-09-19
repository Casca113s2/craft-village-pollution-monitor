import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String firstname;
  final String lastname;
  final String phone;
  final String username;
  final String birthdate;
  final String email;
  final TypeOfActive isActive;
  final TypeOfUser type;
  User({this.firstname, this.lastname, this.phone, this.username, this.birthdate, this.email, this.isActive, this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
      username: json['account'],
      phone: json['phone'],
      birthdate: json['birthdate'],
      email: json['email'],
      isActive: (json['activeCode'].toString() != "null" ?  TypeOfActive.Activated : TypeOfActive.NotActived),
     // type: (json['type'].toString() == "LocalAuthority" ? TypeOfUser.LocalAuthority : (json['type'].toString() == "HouseHold" ? TypeOfUser.HouseHold : TypeOfUser.PrivatePerson) )
       type: (json['type'].toString() == "LocalAuthority" ? TypeOfUser.LocalAuthority : (json['type'].toString() == "HouseHold" ? TypeOfUser.HouseHold : TypeOfUser.PrivatePerson) ) 
    );
  }
 
}
 enum TypeOfActive{
    Activated,
    NotActived
  }
  enum TypeOfUser{
    LocalAuthority,
    PrivatePerson,
    HouseHold
  }