import 'Record.dart';
 
class LatestList {
  List<Record> records = new List();
 
  LatestList({
    this.records
  });
 
  factory LatestList.fromJson(List<dynamic> parsedJson) {
 
    List<Record> records = new List<Record>();
    print(parsedJson.runtimeType);
 
    records = parsedJson.map((i) => Record.fromJson(i)).toList();
 
    return new LatestList(
      records: records,
    );
  }
}