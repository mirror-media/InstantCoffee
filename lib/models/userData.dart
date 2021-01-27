import 'package:readr_app/models/contactAddress.dart';

class UserData {
  String email;
  String name;
  String profilePhoto;
  Gender gender;
  String birthday;

  String phoneNumber;
  ContactAddress contactAddress;

  String verifyEmailLink;

  UserData({
    this.email,
    this.name,
    this.profilePhoto,
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
      profilePhoto: this.profilePhoto,
      gender: this.gender,
      birthday: this.birthday,

      phoneNumber: this.phoneNumber,
      contactAddress: this.contactAddress,

      verifyEmailLink: this.verifyEmailLink,
    );
  }

  @override
  String toString() {
    return """\n
    email : $email, 
    name : $name, 
    profilePhoto : $profilePhoto, 
    gender : $gender,
    birthday : $birthday,

    phoneNumber : $phoneNumber,
    contactAddress : ${contactAddress.toString()}, 
    """;
  }
}

enum Gender {
  Null,
  Male,
  Female,
  Unknown,
}