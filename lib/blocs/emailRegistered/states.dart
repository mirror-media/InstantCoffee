abstract class EmailRegisteredState {}

class EmailRegisteredInitState extends EmailRegisteredState {}

class EmailRegisteredLoading extends EmailRegisteredState {}

class EmailRegisteredSuccess extends EmailRegisteredState {}

class EmailRegisteredFail extends EmailRegisteredState {
  final error;
  EmailRegisteredFail({this.error});
}

class EmailAlreadyInUse extends EmailRegisteredState {}
