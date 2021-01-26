class UserData {
  String email;
  String name;
  String profilePhoto;

  UserData({
    this.email,
    this.name,
    this.profilePhoto,
  });

  // deep copy
  UserData copy() {
    return UserData(
      email: this.email,
      name: this.name,
      profilePhoto: this.profilePhoto,
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