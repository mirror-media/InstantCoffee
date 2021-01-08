import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/models/contactAddress.dart';

class UserData {
  String email;
  String name;
  Gender gender;
  String birthday;

  String phoneNumber;
  ContactAddress contactAddress;

  String verifyEmailLink;

  UserData({
    this.email,
    this.name,
    this.gender,
    this.birthday,

    this.phoneNumber,
    this.contactAddress,

    this.verifyEmailLink,
  });

  // deep copy
  UserData copy() {
    return UserData(
      email: this.email,
      name: this.name,
      gender: this.gender,
      birthday: this.birthday,

      phoneNumber: this.phoneNumber,
      contactAddress: this.contactAddress,

      verifyEmailLink: this.verifyEmailLink,
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return null;
    }

    String genderString = json['gender'];
    return UserData(
      email: json['email'],
      name: json['name'],
      gender: genderString.toEnum(Gender.values),
      birthday: json['birthday'],

      phoneNumber: json['phone'],
      contactAddress: ContactAddress(
        country: json['country'],
        city: json['city'],
        district: json['district'],
        address: json['adress'],
      ),

      verifyEmailLink: json['verifyEmailLink'],
    );
  }

  @override
  String toString() {
    return """\n
    email : $email, 
    name : $name, 
    gender : $gender,
    birthday : $birthday,

    phoneNumber : $phoneNumber,
    contactAddress : ${contactAddress.toString()}, 
    """;
  }
}

enum Gender {
  //Null,
  A_0,
  //Male,
  A_1,
  //Female,
  A_2,
  //Unknown,
  A_3,
}