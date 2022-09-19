class Country{
  int countryId;
  String zipcode;
  String countryName;
 
  Country({this.countryId, this.zipcode, this.countryName});
  factory Country.fromJson(Map json) {
    return Country(
      countryId: json['countryId'],
      zipcode: json['zipcode'] ,
      countryName: json['countryName'],
    );
  }
}