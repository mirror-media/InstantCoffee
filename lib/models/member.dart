import 'package:readr_app/helpers/EnumParser.dart';
import 'package:readr_app/models/contactAddress.dart';

class Member {
  final String israfelId;
  final MemberStateType state;
  String email;
  String name;
  Gender gender;
  String birthday;

  String phoneNumber;
  ContactAddress contactAddress;

  Member({
    this.israfelId,
    this.state,
    this.email,
    this.name,
    this.gender,
    this.birthday,

    this.phoneNumber,
    this.contactAddress,
  });

  // deep copy
  Member copy() {
    return Member(
      israfelId: this.israfelId,
      email: this.email,
      name: this.name,
      gender: this.gender,
      birthday: this.birthday,

      phoneNumber: this.phoneNumber,
      contactAddress: this.contactAddress.copy(),
    );
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    String state = json['state'];
    MemberStateType memberStateType = state.toEnum(MemberStateType.values);

    String genderString = json['gender'];
    return Member(
      israfelId: json['id'],
      state: memberStateType,
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

enum MemberStateType { 
  active, 
  inactive
}

enum Gender {
  //Male,
  M,
  //Female,
  F,
  //Unknown,
  NA,
}