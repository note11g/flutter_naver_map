part of flutter_naver_map;

abstract class NOverlay<O extends NOverlay<void>> implements Pickable {
  NOverlay(this.info);

  @visibleForTesting
  final NOverlayInfo info;

  NOverlayType get type => info.type;

  String get id => info.id;

  bool get _isAdded => _overlayController != null;

  _NOverlayController? _overlayController;

  /// [addFunc] 는 setOnTapListener 등의 함수를 추가할 지 여부를 결정합니다.
  /// [addFunc] 는 기본 true 이며, 지도에서 가져오는 경우(pickAll)에서는 false 로 설정하여,
  /// 오버레이들을 가져오더라도 onTapListener를 잃지 않도록 합니다.
  void _addedOnMap(_NOverlayController controller, {bool addFunc = true}) {
    log("_addedOnMap", name: "NOverlay");
    if (addFunc) controller.add(info, this);
    _overlayController = controller;
  }

  Future<dynamic> _invokeMethod(String method, [dynamic arguments]) async {
    if (!_isAdded) throw Exception("Overlay Not added on Map!");
    final queryString = info.toQueryString(injectMethod: method);

    if (arguments == null) {
      return await _overlayController!.invokeMethod(queryString);
    } else {
      final messagableArgs = NPayload.convertToMessageable(arguments);
      return await _overlayController!
          .invokeMethodWithMessageableArgs(queryString, messagableArgs);
    }
  }

  void _set(String name, dynamic value) async {
    await _invokeMethod(name, value);
  }

  Future<T> _getAsync<T>(String name) {
    return _invokeMethod("get$name").then((value) => value as T);
  }

  Future<T> _getAsyncWithCast<T>(String name, T Function(dynamic) cast) {
    return _invokeMethod("get$name").then((value) => cast(value));
  }

  Future<T> _runAsync<T>(String method, [dynamic arguments]) async =>
      await _invokeMethod(method, arguments);

  /*
    --- methods ---
  */

  Future<int> getZIndex() => _getAsync(_zIndexName);

  void setZIndex(int zIndex) => _set(_zIndexName, zIndex);

  Future<int> getGlobalZIndex() => _getAsync(_globalZIndexName);

  void setGlobalZIndex(int globalZIndex) =>
      _set(_globalZIndexName, globalZIndex);

  Future<String?> getTag() => _getAsync(_tagName);

  void setTag(String tag) => _set(_tagName, tag);

  Future<bool> getIsAdded() => _getAsync(_isAddedName);

  Future<bool> getIsVisible() => _getAsync(_isVisibleName);

  void setIsVisible(bool isVisible) => _set(_isVisibleName, isVisible);

  Future<double> getMinZoom() => _getAsync(_minZoomName);

  void setMinZoom(double minZoom) => _set(_minZoomName, minZoom);

  Future<double> getMaxZoom() => _getAsync(_maxZoomName);

  void setMaxZoom(double maxZoom) => _set(_maxZoomName, maxZoom);

  Future<bool> getIsMinZoomInclusive() => _getAsync(_isMinZoomInclusiveName);

  void setIsMinZoomInclusive(bool isMinZoomInclusive) =>
      _set(_isMinZoomInclusiveName, isMinZoomInclusive);

  Future<bool> getIsMaxZoomInclusive() => _getAsync(_isMaxZoomInclusiveName);

  void setIsMaxZoomInclusive(bool isMaxZoomInclusive) =>
      _set(_isMaxZoomInclusiveName, isMaxZoomInclusive);

  Future<void> performClick() => _runAsync(_performClickName);

  /* ----- Handle ----- */

  void _handle(String methodName) {
    if (methodName == _onTapName) _onTapListener?.call(this as O);
  }

  Function(O overlay)? _onTapListener;

  void setOnTapListener(Function(O overlay) listener) =>
      _onTapListener = listener;

  void removeOnTapListener() => _onTapListener = null;

  /* ----- Override ----- */

  @override
  String toString() => "$runtimeType{info: $info}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NOverlay &&
          runtimeType == other.runtimeType &&
          info == other.info;

  @override
  int get hashCode => info.hashCode;

  /*
    --- Messaging Name Define ---
  */

  static const _zIndexName = "zIndex";
  static const _globalZIndexName = "globalZIndex";
  static const _tagName = "tag";
  static const _isAddedName = "isAdded";
  static const _isVisibleName = "isVisible";
  static const _minZoomName = "minZoom";
  static const _maxZoomName = "maxZoom";
  static const _isMinZoomInclusiveName = "isMinZoomInclusive";
  static const _isMaxZoomInclusiveName = "isMaxZoomInclusive";
  static const _performClickName = "performClick";
  static const _onTapName = "onTap";
}
