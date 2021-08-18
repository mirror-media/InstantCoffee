class Error500Exception {
  var message;
  Error500Exception(this.message);
}

class Error400Exception {
  var message;
  Error400Exception(this.message);
}

class NoInternetException {
  var message;
  NoInternetException(this.message);
}

class NoServiceFoundException extends Error500Exception{
  NoServiceFoundException(message) : super(message);
}

class InvalidFormatException extends Error400Exception{
  InvalidFormatException(message) : super(message);
}

class UnknownException extends Error400Exception{
  UnknownException(message) : super(message);
}
