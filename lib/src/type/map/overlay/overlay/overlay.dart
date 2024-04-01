part of "../../../../../flutter_naver_map.dart";

/// 지도의 특정 위치나 영역에 정보를 표시하는 UI 요소입니다.
sealed class NOverlay<O extends NOverlay<void>>
    with _NOverlaySender, _NOverlayHandler<O> {
  NOverlay(this.info);

  /// 오버레이의 정보를 나타냅니다.
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

  /// 지도에서 오버레이 종류끼리의 zIndex를 나타냅니다.
  ///
  /// 기본 값은 `0` 입니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%A1%B0-%EC%9A%B0%EC%84%A0%EC%88%9C%EC%9C%84-zindex)
  int get zIndex => _zIndex;
  int _zIndex = 0;

  /// 지도에서의 zIndex를 나타냅니다.
  ///
  /// globalZIndex has different initial values for each overlay type.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EC%A0%84%EC%97%AD-%EC%9A%B0%EC%84%A0%EC%88%9C%EC%9C%84-globalzindex)
  int get _globalZIndex;

  set _globalZIndex(int value);

  int get globalZIndex => _globalZIndex;

  /// 지도에 오버레이를 보여지고 있는지, 숨겨졌는지 나타냅니다.
  /// 숨겨지더라도, 오버레이는 지도에 남아있으며, 다시 보이게 할 수 있습니다.
  ///
  /// 따라서, 이 값은 오버레이가 추가되었을 때만 유의미하며, 제거되었을 때는 무의미합니다. (추가/제거와 무관합니다)
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EC%A7%80%EB%8F%84%EC%97%90%EC%84%9C-%EC%88%A8%EA%B9%80)
  bool get isVisible => _isVisible;
  bool _isVisible = true;

  /// 오버레이가 보여질 최소 줌 레벨을 나타냅니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  double get minZoom => _minZoom;
  double _minZoom = NaverMapViewOptions.minimumZoom;

  /// 오버레이가 보여질 최대 줌 레벨을 나타냅니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  double get maxZoom => _maxZoom;
  double _maxZoom = NaverMapViewOptions.maximumZoom;

  /// 오버레이의 최소 줌 레벨을 포함해서 보여줄 지를 나타냅니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  bool get isMinZoomInclusive => _isMinZoomInclusive;
  bool _isMinZoomInclusive = true;

  /// 오버레이의 최대 줌 레벨을 포함해서 보여줄 지를 나타냅니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  bool get isMaxZoomInclusive => _isMaxZoomInclusive;
  bool _isMaxZoomInclusive = true;

  /// 지도에서 오버레이 종류끼리의 zIndex를 지정합니다.
  ///
  /// 기본 값은 `0` 입니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%A1%B0-%EC%9A%B0%EC%84%A0%EC%88%9C%EC%9C%84-zindex)
  void setZIndex(int zIndex) {
    _zIndex = zIndex;
    _set(_zIndexName, zIndex);
  }

  /// 지도에서의 zIndex를 지정합니다.
  ///
  /// globalZIndex has different initial values for each overlay type.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EC%A0%84%EC%97%AD-%EC%9A%B0%EC%84%A0%EC%88%9C%EC%9C%84-globalzindex)
  void setGlobalZIndex(int globalZIndex) {
    _globalZIndex = globalZIndex;
    _set(_globalZIndexName, globalZIndex);
  }

  /// 지도에 오버레이를 보여지고 있는지, 숨겨졌는지 지정합니다.
  /// 숨겨지더라도, 오버레이는 지도에 남아있으며, 다시 보이게 할 수 있습니다.
  ///
  /// 따라서, 이 값은 오버레이가 추가되었을 때만 유의미하며, 제거되었을 때는 무의미합니다. (추가/제거와 무관합니다)
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EC%A7%80%EB%8F%84%EC%97%90%EC%84%9C-%EC%88%A8%EA%B9%80)
  void setIsVisible(bool isVisible) {
    _isVisible = isVisible;
    _set(_isVisibleName, isVisible);
  }

  /// 오버레이가 보여질 최소 줌 레벨을 지정합니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  void setMinZoom(double minZoom) {
    _minZoom = minZoom;
    _set(_minZoomName, minZoom);
  }

  /// 오버레이가 보여질 최대 줌 레벨을 지정합니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  void setMaxZoom(double maxZoom) {
    _maxZoom = maxZoom;
    _set(_maxZoomName, maxZoom);
  }

  /// 오버레이의 최소 줌 레벨을 포함해서 보여줄 지를 지정합니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  void setIsMinZoomInclusive(bool isMinZoomInclusive) {
    _isMinZoomInclusive = isMinZoomInclusive;
    _set(_isMinZoomInclusiveName, isMinZoomInclusive);
  }

  /// 오버레이의 최대 줌 레벨을 포함해서 보여줄 지를 지정합니다.
  ///
  /// 자세한 내용은 문서를 참고하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/overlay/#%EB%B3%B4%EC%97%AC%EC%A7%80%EB%8A%94-%EC%A4%8C-%EB%A0%88%EB%B2%A8%EC%9D%98-%EB%B2%94%EC%9C%84-%EC%A7%80%EC%A0%95)
  void setIsMaxZoomInclusive(bool isMaxZoomInclusive) {
    _isMaxZoomInclusive = isMaxZoomInclusive;
    _set(_isMaxZoomInclusiveName, isMaxZoomInclusive);
  }

  /// [setOnTapListener]를 통해 지정된 사용자의 오버레이 터치를 처리하는 함수를 실행합니다.
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
