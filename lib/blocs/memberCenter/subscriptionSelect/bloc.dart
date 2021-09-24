import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/services/subscriptionSelectService.dart';

class SubscriptionSelectBloc extends Bloc<SubscriptionSelectEvents, SubscriptionSelectState> {
  final SubscriptionSelectRepos subscriptionSelectRepos;

  SubscriptionSelectBloc({this.subscriptionSelectRepos}) : super(SubscriptionSelectInitState());

  @override
  Stream<SubscriptionSelectState> mapEventToState(SubscriptionSelectEvents event) async* {
    yield* event.run(subscriptionSelectRepos);
  }
}
