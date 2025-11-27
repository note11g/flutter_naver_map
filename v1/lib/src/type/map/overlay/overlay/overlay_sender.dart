part of "../../../../../flutter_naver_map.dart";

mixin _NOverlaySender {
  bool get _isAdded;

  List<_NOverlayController> get _overlayControllers;

  NOverlayInfo get info;

  Future<dynamic> _send(String method, [dynamic arguments]) async {
    if (!_isAdded) {
      throw NOverlayNotAddedOnMapException("Overlay Not added on Map!");
    }

    final query = _NOverlayQuery(info, methodName: method).query;

    final messageable = arguments != null
        ? NMessageable.forOnce(NPayload.convertToMessageable(arguments!))
        : null;

    dynamic lastValue;

    for (final overlayController in _overlayControllers) {
      lastValue = await overlayController.invokeMethod(query, messageable);
    }

    return lastValue;
  }

  void _set(String name, dynamic value) async {
    if (!_isAdded) return;
    await _send(name, value);
  }

  Future<T> _getAsyncWithCast<T>(String name, T Function(dynamic) cast) {
    return _send("get$name").then((value) => cast(value));
  }

  Future<T> _runAsync<T>(String method, [dynamic arguments]) async =>
      await _send(method, arguments);
}
