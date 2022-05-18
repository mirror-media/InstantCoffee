import 'package:readr_app/models/member.dart';

abstract class EditMemberProfileEvents {}

class FetchMemberProfile extends EditMemberProfileEvents {
  FetchMemberProfile();

  @override
  String toString() => 'FetchMemberProfile';
}

class UpdateMemberProfile extends EditMemberProfileEvents {
  final Member editMember;
  UpdateMemberProfile({
    required this.editMember,
  });

  @override
  String toString() => 'UpdateMemberProfile';
}
