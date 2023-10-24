part of flutter_naver_map;

class NGroundOverlay extends NAddableOverlay<NGroundOverlay> {
  NLatLngBounds get bounds => _bounds;
  NLatLngBounds _bounds;

  NOverlayImage _image;

  double get alpha => _alpha;
  double _alpha;

  @override
  // ignore: prefer_final_fields
  int _globalZIndex = -300000;

  NGroundOverlay({
    required String id,
    required NLatLngBounds bounds,
    required NOverlayImage image,
    double alpha = 1.0,
    super.minZoom,
    super.maxZoom,
  })  : _bounds = bounds,
        _image = image,
        _alpha = alpha,
        super(id: id, type: NOverlayType.groundOverlay);

  void setBounds(NLatLngBounds bounds) {
    _bounds = bounds;
    _set(_boundsName, bounds);
  }

  void setImage(NOverlayImage image) {
    _image = image;
    _set(_imageName, image);
  }

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
