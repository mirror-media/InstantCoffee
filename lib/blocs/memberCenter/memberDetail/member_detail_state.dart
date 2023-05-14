part of 'member_detail_cubit.dart';

@immutable
abstract class MemberDetailState {}

class MemberDetailInitial extends MemberDetailState {}

class MemberDetailLoading extends MemberDetailState {}

class MemberDetailLoad extends MemberDetailState {
  final MemberSubscriptionDetail memberSubscriptionDetail;
  MemberDetailLoad({required this.memberSubscriptionDetail});
}

class MemberDetailError extends MemberDetailState {
  final dynamic error;
  MemberDetailError({this.error});
}
