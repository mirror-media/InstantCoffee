import 'package:readr_app/models/member.dart';

abstract class EditMemberContactInfoState {}

class EditMemberContactInfoInitState extends EditMemberContactInfoState {}

class MemberLoading extends EditMemberContactInfoState {}

class MemberLoaded extends EditMemberContactInfoState {
  final Member member;
  MemberLoaded({required this.member});
}

class MemberLoadedError extends EditMemberContactInfoState {
  final dynamic error;
  MemberLoadedError({
    this.error,
  });
}

class SavingLoading extends EditMemberContactInfoState {
  final Member member;
  SavingLoading({required this.member});
}
