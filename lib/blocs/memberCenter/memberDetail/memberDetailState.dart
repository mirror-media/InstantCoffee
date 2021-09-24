part of 'memberDetailCubit.dart';

@immutable
abstract class MemberDetailState {}

class MemberDetailInitial extends MemberDetailState {}

class MemberDetailLoading extends MemberDetailState {}

class MemberDetailLoad extends MemberDetailState {
  final MemberDetail memberDetail;
  MemberDetailLoad({this.memberDetail});
}

class MemberDetailError extends MemberDetailState {
  final error;
  MemberDetailError({this.error});
}
