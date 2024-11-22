class AuthQuery {
  static String getMemberInfo = '''
    query AllMembers {
      allMembers(where: { firebaseId:"%s" }) {
        id
        type 
      }
    }
  ''';

  static String updateUserEmail = '''
  
  mutation Updatemember {
    updatemember(data: {  email: "%s" }, id: "%s") {
        id
    }
  }

  ''';
}
