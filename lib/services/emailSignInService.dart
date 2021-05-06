import 'package:firebase_auth/firebase_auth.dart';

abstract class EmailSignInRepos {
  Future<List<String>> fetchSignInMethodsForEmail(String email);
}

class EmailSignInServices implements EmailSignInRepos{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> fetchSignInMethodsForEmail(String email) async {
    List<String> resultList = List<String>();
    try {
      resultList = await _auth.fetchSignInMethodsForEmail(email);
    } catch(onError) {
      print('Fetch sign in methods for email: $onError');
    }
    return resultList;
  }
}