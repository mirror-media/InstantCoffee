import 'dart:collection';

abstract class CustomizedList<E> extends ListBase<E> {
  List<E> l = [];

  @override
  void add(E value) => l.add(value);

  @override
  void addAll(Iterable<E> iterable) => l.addAll(iterable);

  @override
  set length(int newLength) {
    l.length = newLength;
  }

  @override
  int get length => l.length;
  @override
  E operator [](int index) => l[index];
  @override
  void operator []=(int index, E value) {
    l[index] = value;
  }
}
