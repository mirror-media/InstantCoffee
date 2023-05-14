import 'package:readr_app/models/member.dart';

abstract class EditMemberProfileState {}

class EditMemberProfileInitState extends EditMemberProfileState {}

class MemberLoading extends EditMemberProfileState {}

class MemberLoaded extends EditMemberProfileState {
  final Member member;
  MemberLoaded({required this.member});
}

class MemberLoadedError extends EditMemberProfileState {
  final dynamic error;
  MemberLoadedError({
    this.error,
  });
}

class SavingLoading extends EditMemberProfileState {
  final Member member;
  SavingLoading({required this.member});
}
