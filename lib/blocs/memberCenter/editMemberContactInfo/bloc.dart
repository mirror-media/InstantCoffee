import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/states.dart';
import 'package:readr_app/services/memberService.dart';

class EditMemberContactInfoBloc extends Bloc<EditMemberContactInfoEvents, EditMemberContactInfoState> {
  final MemberRepos memberRepos;
  
  EditMemberContactInfoBloc({this.memberRepos}) : super(EditMemberContactInfoInitState());

  @override
  Stream<EditMemberContactInfoState> mapEventToState(EditMemberContactInfoEvents event) async* {
    yield* event.run(memberRepos);
  }
}
