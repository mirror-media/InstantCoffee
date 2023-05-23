import 'package:readr_app/helpers/enum_parser.dart';
import 'package:readr_app/models/contact_address.dart';

class Member {
  final String israfelId;
  String email;
  String? name;
  Gender? gender;
  String? birthday;

  String? phoneNumber;
  ContactAddress contactAddress;

  Member({
    required this.israfelId,
    required this.email,
    this.name,
    this.gender,
    this.birthday,
    this.phoneNumber,
    required this.contactAddress,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    String? genderString = json['gender'];
    String? birthdayString;
    if (json['birthday'] != null) {
      birthdayString = json['birthday'].split('T')[0];
    }

    return Member(
      israfelId: json['id'],
      email: json['email'],
      name: json['name'],
      gender: genderString?.toEnum(Gender.values),
      birthday: birthdayString,
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
  M, //Male,
  F, //Female,
  // ignore: constant_identifier_names
  NA, //Unknown,
}
