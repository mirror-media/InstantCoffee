class JsonAndObject<E> {
  final String responseBody;
  final E object;

  JsonAndObject({
    required this.responseBody,
    required this.object
  });
}