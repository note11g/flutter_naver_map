part of "../../../../../../flutter_naver_map.dart";

/// 지도에 한 지점, 혹은 마커에 텍스트로 간단한 정보를 나타낼 때 사용하는 정보창입니다.
class NInfoWindow extends NAddableOverlay<NInfoWindow> {
  /// 마커에 띄우는 정보창인지 나타내는 값입니다.
  final bool withMarker;

  String _text;

  /// 정보창이 위치하는 기준점을 나타냅니다.
  ///
  /// 기본 값은 하단의 중앙을 의미하는 [defaultAnchor] (NPoint(0.5, 1.0))입니다.
  NPoint get anchor => _anchor;
  NPoint _anchor;

  /// 정보창의 불투명도를 나타냅니다. (0 ~ 1)
  ///
  /// 기본값은 불투명함을 나타내는 `1`
  double get alpha => _alpha;
  double _alpha;

  /// 정보창의 위치를 나타냅니다. 지도에 표시된 경우에만 값이 존재합니다.
  // only for onMap
  NLatLng? get position => _position;
  NLatLng? _position;

  /// 좌표(또는 마커)와 X축 방향으로 얼마나 떨어져 정보창을 표시할지 나타냅니다.
  ///
  /// 기본값은 `0`
  double get offsetX => _offsetX;
  double _offsetX;

  /// 좌표(또는 마커)와 Y축 방향으로 얼마나 떨어져 정보창을 표시할지 나타냅니다.
  ///
  /// 기본값은 `0`
  double get offsetY => _offsetY;
  double _offsetY;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = 400000;

  /// 마커에 정보창을 띄울 때 사용하는 생성자입니다.
  NInfoWindow.onMarker({
    required super.id,
    required String text,
    NPoint anchor = defaultAnchor,
    double alpha = 1.0,
    double offsetX = 0,
    double offsetY = 0,
  })  : _text = text,
        _anchor = anchor,
        _alpha = alpha,
        _position = null,
        _offsetX = offsetX,
        _offsetY = offsetY,
        withMarker = true,
        super(type: NOverlayType.infoWindow);

  /// 지도에 정보창을 띄울 때 사용하는 생성자입니다.
  NInfoWindow.onMap({
    required super.id,
    required String text,
    required NLatLng position,
    NPoint anchor = defaultAnchor,
    double alpha = 1.0,
    double offsetX = 0,
    double offsetY = 0,
  })  : _text = text,
        _position = position,
        _anchor = anchor,
        _alpha = alpha,
        _offsetX = offsetX,
        _offsetY = offsetY,
        withMarker = false,
        super(type: NOverlayType.infoWindow);

  /// 정보창에 보일 텍스트를 지정합니다.
  void setText(String text) {
    _text = text;
    _set(_textName, text);
  }

  /// 정보창이 위치하는 기준점을 지정합니다.
  ///
  /// 기본 값은 하단의 중앙을 의미하는 [defaultAnchor] (NPoint(0.5, 1.0))입니다.
  void setAnchor(NPoint anchor) {
    _anchor = anchor;
    _set(_anchorName, anchor);
  }

  /// 정보창의 불투명도를 지정합니다. (0 ~ 1)
  ///
  /// 기본값은 불투명함을 나타내는 `1`
  void setAlpha(double alpha) {
    _alpha = alpha;
    _set(_alphaName, alpha);
  }

  /// 정보창의 위치를 지정합니다. 지도에 표시된 경우에만 값이 존재합니다.
  void setPosition(NLatLng position) {
    if (withMarker) {
      throw NInfoWindowAddedOnMarkerSetPositionException(
          "NInfoWindow added on Marker can't set position. if you want to set position, use NInfoWindow.onMap");
    }
    _position = position;
    _set(_positionName, position);
  }

  /// 좌표(또는 마커)와 X축 방향으로 얼마나 떨어져 정보창을 표시할지 지정합니다.
  ///
  /// 기본값은 `0`
  void setOffsetX(double offsetX) {
    _offsetX = offsetX;
    _set(_offsetXName, offsetX);
  }

  /// 좌표(또는 마커)와 Y축 방향으로 얼마나 떨어져 정보창을 표시할지 지정합니다.
  ///
  /// 기본값은 `0`
  void setOffsetY(double offsetY) {
    _offsetY = offsetY;
    _set(_offsetYName, offsetY);
  }

  /// 정보창을 닫는 메서드입니다.
  void close() {
    _runAsync(_closeName);
    for (final overlayController in _overlayControllers) {
      overlayController.deleteWithInfo(info);
    }
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _textName: _text,
        _anchorName: _anchor,
        _alphaName: _alpha,
        _positionName: _position,
        _offsetXName: _offsetX,
        _offsetYName: _offsetY,
        ..._commonMap,
      });

  /* ------ Constant ----- */

  /// 정보창의 기본 앵커를 나타냅니다. 하단의 중앙을 나타내는 값을 가지고 있습니다.
  static const NPoint defaultAnchor = NPoint(0.5, 1.0);

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _textName = "text";
  static const _anchorName = "anchor";
  static const _alphaName = "alpha";
  static const _positionName = "position";
  static const _offsetXName = "offsetX";
  static const _offsetYName = "offsetY";
  static const _closeName = "close";
}
