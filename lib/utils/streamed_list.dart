import 'dart:async';

class StreamedList<T> {
  final _controller = StreamController<List<T>>.broadcast();

  Stream<List<T>> get data => _controller.stream;

  List<T> _list = [];

  List<T> get list => _list;

  void updateList(List<T> list) {
    _list = list;
    _dispatch();
  }

  void addToList(T value) {
    _list.add(value);
    _dispatch();
  }

  void _dispatch() {
    _controller.sink.add(_list);
  }

  void dispose() {
    _list = [];
    _controller.close();
  }
}
