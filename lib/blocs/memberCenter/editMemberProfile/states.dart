import 'package:readr_app/models/member.dart';

abstract class EditMemberProfileState {}

class EditMemberProfileInitState extends EditMemberProfileState {}

class MemberLoading extends EditMemberProfileState {}

class MemberLoaded extends EditMemberProfileState {
  final Member member;
  MemberLoaded({this.member});
}

class MemberLoadedError extends EditMemberProfileState {
  final error;
  MemberLoadedError({
    this.error,
  });
}