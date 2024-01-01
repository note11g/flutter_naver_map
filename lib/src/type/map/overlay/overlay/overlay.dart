part of flutter_naver_map;

abstract class NOverlay<O extends NOverlay<void>>
    with _NOverlaySender, _NOverlayHandler<O> {
  NOverlay(this.info);

  @override
  final NOverlayInfo info;

  @override
  bool get _isAdded => _overlayControllers.isNotEmpty;

  @override

  /// like stack. FIFO (because of flutter's navigator stack)
  final List<_NOverlayController> _overlayControllers = [];

  void _addedOnMap(_NOverlayController controller) {
    controller.add(info, this);
    _overlayControllers.add(controller);
  }

  void _removedOnMap(int overlayControllerId) {
    int foundIndex = -1;
    for (int i = _overlayControllers.length - 1; i >= 0; i--) {
      if (_overlayControllers[i].viewId == overlayControllerId) {
        foundIndex = i;
        break;
      }
    }
    if (foundIndex == -1) return;
    _overlayControllers.removeAt(foundIndex);
  }

  Function(O overlay)? __onTapListener;

  bool get _hasOnTapListener => __onTapListener != null;

  @override
  Function(O overlay)? get _onTapListener => __onTapListener;

  @override
  set _onTapListener(Function(O overlay)? listener) {
    __onTapListener = listener;
    _set(_hasOnTapListenerName, _hasOnTapListener);
  }

  /*
    --- methods ---
  */

  int get zIndex => _zIndex;
  int _zIndex = 0;

  /// globalZIndex has different initial values for each overlay type.
  int get _globalZIndex;

  set _globalZIndex(int value);

  int get globalZIndex => _globalZIndex;

  bool get isVisible => _isVisible;
  bool _isVisible = true;

  double get minZoom => _minZoom;
  double _minZoom = NaverMapViewOptions.minimumZoom;

  double get maxZoom => _maxZoom;
  double _maxZoom = NaverMapViewOptions.maximumZoom;

  bool get isMinZoomInclusive => _isMinZoomInclusive;
  bool _isMinZoomInclusive = true;

  bool get isMaxZoomInclusive => _isMaxZoomInclusive;
  bool _isMaxZoomInclusive = true;

  void setZIndex(int zIndex) {
    _zIndex = zIndex;
    _set(_zIndexName, zIndex);
  }

  void setGlobalZIndex(int globalZIndex) {
    _globalZIndex = globalZIndex;
    _set(_globalZIndexName, globalZIndex);
  }

  void setIsVisible(bool isVisible) {
    _isVisible = isVisible;
    _set(_isVisibleName, isVisible);
  }

  void setMinZoom(double minZoom) {
    _minZoom = minZoom;
    _set(_minZoomName, minZoom);
  }

  void setMaxZoom(double maxZoom) {
    _maxZoom = maxZoom;
    _set(_maxZoomName, maxZoom);
  }

  void setIsMinZoomInclusive(bool isMinZoomInclusive) {
    _isMinZoomInclusive = isMinZoomInclusive;
    _set(_isMinZoomInclusiveName, isMinZoomInclusive);
  }

  void setIsMaxZoomInclusive(bool isMaxZoomInclusive) {
    _isMaxZoomInclusive = isMaxZoomInclusive;
    _set(_isMaxZoomInclusiveName, isMaxZoomInclusive);
  }

  Future<void> performClick() => _runAsync(_performClickName);

  Map<String, dynamic> get _commonMap => {
        _zIndexName: _zIndex,
        _globalZIndexName: _globalZIndex,
        _isVisibleName: _isVisible,
        _minZoomName: _minZoom,
        _maxZoomName: _maxZoom,
        _isMinZoomInclusiveName: _isMinZoomInclusive,
        _isMaxZoomInclusiveName: _isMaxZoomInclusive,
        _hasOnTapListenerName: _hasOnTapListener,
      };

  /* ----- fromMessageable ----- */

  void _applyFromMessageable(dynamic m) {
    _zIndex = m[_zIndexName]!;
    _globalZIndex = m[_globalZIndexName]!;
    _isVisible = m[_isVisibleName]!;
    _minZoom = m[_minZoomName]!;
    _maxZoom = m[_maxZoomName]!;
    _isMinZoomInclusive = m[_isMinZoomInclusiveName]!;
    _isMaxZoomInclusive = m[_isMaxZoomInclusiveName]!;
  }

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
  static const _isVisibleName = "isVisible";
  static const _minZoomName = "minZoom";
  static const _maxZoomName = "maxZoom";
  static const _isMinZoomInclusiveName = "isMinZoomInclusive";
  static const _isMaxZoomInclusiveName = "isMaxZoomInclusive";
  static const _performClickName = "performClick";
  static const _hasOnTapListenerName = "hasOnTapListener";
}
