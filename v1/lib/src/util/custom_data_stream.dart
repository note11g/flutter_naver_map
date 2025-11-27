import "dart:async";

class NValueHoldHotStreamController<T> {
  T _currentValue;

  NValueHoldHotStreamController(T initialData) : _currentValue = initialData;

  final StreamController<T> _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  T get currentData => _currentValue;

  void add(T data) {
    _currentValue = data;
    _controller.add(data);
  }

  void close() {
    _controller.close();
  }
}
