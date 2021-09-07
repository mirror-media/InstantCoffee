part of 'memberdetail_cubit.dart';

@immutable
abstract class MemberdetailState {}

class MemberdetailInitial extends MemberdetailState {}

class MemberDetailLoad extends MemberdetailState {
  final MemberDetail memberDetail;
  MemberDetailLoad({this.memberDetail});
}

class MemberDetailError extends MemberdetailState {
  final error;
  MemberDetailError({this.error});
}
