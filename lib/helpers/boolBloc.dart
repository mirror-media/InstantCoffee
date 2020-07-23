import 'dart:async';

class BoolBloc{
  StreamController<bool> controller = StreamController<bool>.broadcast();
  //StreamController<bool> get controller => _controller;

  bool _flag;
  bool get flag => _flag;

  void change(bool value) {
    if(!controller.isClosed)
    {
      _flag = value;
      controller.sink.add(value);
    }
  }

  void setFlag(bool value) {
    _flag = value;
  }

  void sinkToAdd(bool value) {
    if(!controller.isClosed)
    {
      controller.sink.add(value);
    }
  }

  void dispose() {
    controller.close();
  }
}