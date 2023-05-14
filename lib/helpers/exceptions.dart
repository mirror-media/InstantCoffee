class Error500Exception {
  dynamic message;
  Error500Exception(this.message);
}

class Error400Exception {
  dynamic message;
  Error400Exception(this.message);
}

class NoInternetException {
  dynamic message;
  NoInternetException(this.message);
}

class NoServiceFoundException extends Error500Exception {
  NoServiceFoundException(message) : super(message);
}

class InvalidFormatException extends Error400Exception {
  InvalidFormatException(message) : super(message);
}

class UnknownException extends Error400Exception {
  UnknownException(message) : super(message);
}
