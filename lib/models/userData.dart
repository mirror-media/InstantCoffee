class UserData {
  String email;
  String name;
  String profilePhoto;

  String verifyEmailLink;

  UserData({
    this.email,
    this.name,
    this.profilePhoto,

    this.verifyEmailLink,
  });

  // deep copy
  UserData copy() {
    return UserData(
      email: this.email,
      name: this.name,
      profilePhoto: this.profilePhoto,

      verifyEmailLink: this.verifyEmailLink,
    );
  }

  @override
  String toString() {
    return """\n
    email : $email, 
    name : $name, 
    profilePhoto : $profilePhoto, 
    """;
  }
}