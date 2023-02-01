part of flutter_naver_map;

class NInfoWindow extends NAddableOverlay<NInfoWindow> {
  final bool withMarker;

  String _text;

  NPoint get anchor => _anchor;
  NPoint _anchor;

  double get alpha => _alpha;
  double _alpha;

  // only for onMap
  NLatLng? get position => _position;
  NLatLng? _position;

  double get offsetX => _offsetX;
  double _offsetX;

  double get offsetY => _offsetY;
  double _offsetY;

  NInfoWindow.onMarker({
    required String id,
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
        super(id: id, type: NOverlayType.infoWindow);

  NInfoWindow.onMap({
    required String id,
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
        super(id: id, type: NOverlayType.infoWindow);

  void setText(String text) {
    _text = text;
    _set(_textName, text);
  }

  void setAnchor(NPoint anchor) {
    _anchor = anchor;
    _set(_anchorName, anchor);
  }

  void setAlpha(double alpha) {
    _alpha = alpha;
    _set(_alphaName, alpha);
  }

  void setPosition(NLatLng position) {
    if (withMarker) {
      throw Exception("NInfoWindow attached NMarker can't set position.");
    }
    _position = position;
    _set(_positionName, position);
  }

  void setOffsetX(double offsetX) {
    _offsetX = offsetX;
    _set(_offsetXName, offsetX);
  }

  void setOffsetY(double offsetY) {
    _offsetY = offsetY;
    _set(_offsetYName, offsetY);
  }

  void close() {
    _runAsync(_closeName);
    _overlayController!.disposeWithInfo(info);
  }

  // only at map
  factory NInfoWindow._fromJson(dynamic json) => NInfoWindow.onMap(
        id: NOverlayInfo._fromJson(json[_infoName]).id,
        text: json[_textName],
        position: NLatLng._fromJson(json[_positionName]),
        anchor: NPoint._fromJson(json[_anchorName]),
        alpha: json[_alphaName],
        offsetX: json[_offsetXName],
        offsetY: json[_offsetYName],
      );

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _textName: _text,
        _anchorName: _anchor,
        _alphaName: _alpha,
        _positionName: _position,
        _offsetXName: _offsetX,
        _offsetYName: _offsetY,
      });

  /* ------ Constant ----- */

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
