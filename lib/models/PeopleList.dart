import 'People.dart';

class PeopleList {
  List<People> peoples = new List();

  PeopleList({
    this.peoples,
  });

  factory PeopleList.fromJson(List<dynamic> parsedJson) {
    List<People> peoples = new List<People>();

    if (parsedJson != null) {
      peoples = parsedJson.map((i) => People.fromJson(i)).toList();
    }

      return new PeopleList(
        peoples: peoples,
      );
  }
}