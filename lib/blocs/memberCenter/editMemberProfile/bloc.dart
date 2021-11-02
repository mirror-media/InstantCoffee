import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/states.dart';
import 'package:readr_app/services/memberService.dart';

class EditMemberProfileBloc extends Bloc<EditMemberProfileEvents, EditMemberProfileState> {
  final MemberRepos memberRepos;
  EditMemberProfileBloc({this.memberRepos}) : super(EditMemberProfileInitState());

  @override
  Stream<EditMemberProfileState> mapEventToState(EditMemberProfileEvents event) async* {
    yield* event.run(memberRepos);
  }
}
