import 'package:readr_app/models/member.dart';

abstract class EditMemberContactInfoState {}

class EditMemberContactInfoInitState extends EditMemberContactInfoState {}

class MemberLoading extends EditMemberContactInfoState {}

class MemberLoaded extends EditMemberContactInfoState {
  final Member member;
  MemberLoaded({this.member});
}

class MemberLoadedError extends EditMemberContactInfoState {
  final error;
  MemberLoadedError({
    this.error,
  });
}

class SavingLoading extends EditMemberContactInfoState {
  final Member member;
  SavingLoading({this.member});
}

class SavingSuccess extends EditMemberContactInfoState {
  final Member member;
  SavingSuccess({this.member});
}

class SavingError extends EditMemberContactInfoState {
  final Member member;
  final error;
  SavingError({
    this.member,
    this.error,
  });
}