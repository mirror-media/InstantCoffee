import 'package:readr_app/models/election/candidate.dart';

class Municipality {
  final String name;
  final List<Candidate> candidates;

  const Municipality({
    required this.name,
    required this.candidates,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    List<Candidate> candidates = [];
    for (var item in json['candidate']) {
      candidates.add(Candidate.fromJson(item));
    }
    candidates.sort((a, b) =>
        b.percentageOfVotesObtained.compareTo(a.percentageOfVotesObtained));
    return Municipality(
      name: json['city'],
      candidates: candidates,
    );
  }
}
