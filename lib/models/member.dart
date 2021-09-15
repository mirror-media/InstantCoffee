import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/models/contactAddress.dart';

class Member {
  String email;
  String name;
  Gender gender;
  String birthday;

  String phoneNumber;
  ContactAddress contactAddress;

  Member({
    this.email,
    this.name,
    this.gender,
    this.birthday,

    this.phoneNumber,
    this.contactAddress,
  });

  factory Member.fromJson(Map<String, dynamic> json) {

    String genderString = json['gender'];
    return Member(
      email: json['email'],
      name: json['name'],
      gender: genderString.toEnum(Gender.values),
      birthday: json['birthday'],

      phoneNumber: json['phone'],
      contactAddress: ContactAddress(
        country: json['country'],
        city: json['city'],
        district: json['district'],
        address: json['address'],
      ),
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