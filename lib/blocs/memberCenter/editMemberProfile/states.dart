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

class SavingLoading extends EditMemberProfileState {
  final Member member;
  SavingLoading({this.member});
}

class SavingSuccess extends EditMemberProfileState {
  final Member member;
  SavingSuccess({this.member});
}

class SavingError extends EditMemberProfileState {
  final Member member;
  final error;
  SavingError({
    this.member,
    this.error,
  });
}
