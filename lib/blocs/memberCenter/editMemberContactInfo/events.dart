import 'package:readr_app/models/member.dart';

abstract class EditMemberContactInfoEvents {}

class FetchMemberContactInfo extends EditMemberContactInfoEvents {
  FetchMemberContactInfo();

  @override
  String toString() => 'FetchMemberContactInfo';
}

class UpdateMemberContactInfo extends EditMemberContactInfoEvents {
  final Member editMember;
  UpdateMemberContactInfo({
    required this.editMember,
  });

  @override
  String toString() => 'UpdateMemberContactInfo';
}

class ChangeMember extends EditMemberContactInfoEvents {
  final Member member;
  ChangeMember({
    required this.member,
  });
  @override
  String toString() => 'ChangeMember';
}
