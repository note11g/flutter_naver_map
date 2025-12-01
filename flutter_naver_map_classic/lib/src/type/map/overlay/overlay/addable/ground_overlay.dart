part of "../../../../../../flutter_naver_map.dart";

/// [NOverlayImage]를 이용해 특정 영역을 지도에 나타낼 수 있는 오버레이입니다.
///
/// 지상 오버레이라고 부릅니다.
class NGroundOverlay extends NAddableOverlay<NGroundOverlay> {
  /// 지상 오버레이의 영역을 나타냅니다.
  NLatLngBounds get bounds => _bounds;
  NLatLngBounds _bounds;

  /// 지상 오버레이에 사용할 이미지를 나타냅니다.
  NOverlayImage get image => _image;
  NOverlayImage _image;

  /// 지상 오버레이의 불투명도를 나타냅니다. (0~1)
  double get alpha => _alpha;
  double _alpha;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = -300000;

  NGroundOverlay({
    required super.id,
    required NLatLngBounds bounds,
    required NOverlayImage image,
    double alpha = 1.0,
  })  : _bounds = bounds,
        _image = image,
        _alpha = alpha,
        super(type: NOverlayType.groundOverlay);

  /// 지상 오버레이의 영역을 지정합니다.
  void setBounds(NLatLngBounds bounds) {
    _bounds = bounds;
    _set(_boundsName, bounds);
  }

  /// 지상 오버레이에 사용할 이미지를 지정합니다.
  void setImage(NOverlayImage image) {
    _image = image;
    _set(_imageName, image);
  }

  /// 지상 오버레이의 불투명도를 지정합니다. (0~1)
  ///
  /// 기본값은 불투명함을 나타내는 `1`
  void setAlpha(double alpha) {
    _alpha = alpha;
    _set(_alphaName, alpha);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        _infoName: info,
        _boundsName: _bounds,
        _imageName: _image,
        _alphaName: _alpha,
        ..._commonMap,
      });

  /*
    --- Messaging Name Define ---
  */

  static const _infoName = "info";
  static const _boundsName = "bounds";
  static const _imageName = "image";
  static const _alphaName = "alpha";
}
