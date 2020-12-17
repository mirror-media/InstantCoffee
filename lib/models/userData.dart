class UserData {
  String email;
  String name;
  String profilePhoto;
  Gender gender;
  String birthday;

  String verifyEmailLink;

  UserData({
    this.email,
    this.name,
    this.profilePhoto,
    this.gender,
    this.birthday,

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
    """;
  }
}

enum Gender {
  Null,
  Male,
  Female,
  Unknown,
}