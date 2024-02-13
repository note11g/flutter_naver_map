part of flutter_naver_map;

class NCameraUpdate with NMessageableWithMap {
  final NLatLng? _target;
  final double? _zoom;
  final double? _zoomBy;
  final double? _tilt;
  final double? _tiltBy;
  final double? _bearing;
  final double? _bearingBy;
  final NLatLngBounds? _bounds;
  final EdgeInsets? _boundsPadding;
  NPoint? _pivot;
  NCameraAnimation _animation = defaultMovingAnimation;
  Duration _duration = defaultMovingDuration;
  NCameraUpdateReason? _reason;

  final String _signature;

  NCameraUpdate._({
    NLatLng? target,
    double? zoom,
    double? zoomBy,
    double? tilt,
    double? tiltBy,
    double? bearing,
    double? bearingBy,
    NLatLngBounds? bounds,
    EdgeInsets? boundsPadding,
    required String signature,
  })  : _target = target,
        _zoom = zoom,
        _zoomBy = zoomBy,
        _tilt = tilt,
        _tiltBy = tiltBy,
        _bearing = bearing,
        _bearingBy = bearingBy,
        _bounds = bounds,
        _boundsPadding = boundsPadding,
        _signature = signature;

  factory NCameraUpdate.fromCameraPosition(NCameraPosition position) =>
      NCameraUpdate.withParams(
        target: position.target,
        zoom: position.zoom,
        tilt: position.tilt,
        bearing: position.bearing,
      );

  factory NCameraUpdate.zoomIn() => NCameraUpdate.zoomBy(1);

  factory NCameraUpdate.zoomOut() => NCameraUpdate.zoomBy(-1);

  factory NCameraUpdate.zoomBy(double delta) =>
      NCameraUpdate.withParams(zoomBy: delta);

  factory NCameraUpdate.scrollAndZoomTo({NLatLng? target, double? zoom}) =>
      NCameraUpdate.withParams(target: target, zoom: zoom);

  factory NCameraUpdate.withParams(
      {NLatLng? target,
      double? zoom,
      double? zoomBy,
      double? tilt,
      double? tiltBy,
      double? bearing,
      double? bearingBy}) {
    assert(zoom == null || zoomBy == null);
    assert(tilt == null || tiltBy == null);
    assert(bearing == null || bearingBy == null);

    return NCameraUpdate._(
      target: target,
      zoom: zoom,
      zoomBy: zoomBy,
      tilt: tilt,
      tiltBy: tiltBy,
      bearing: bearing,
      bearingBy: bearingBy,
      signature: "withParams",
    );
  }

  factory NCameraUpdate.fitBounds(NLatLngBounds bounds,
          {EdgeInsets? padding}) =>
      NCameraUpdate._(
          bounds: bounds, boundsPadding: padding, signature: "fitBounds");

  void setPivot(NPoint pivot) => _pivot = pivot;

  void setAnimation({
    NCameraAnimation animation = NCameraAnimation.easing,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    _animation = animation;
    _duration = duration;
  }

  @visibleForTesting
  void setReason(NCameraUpdateReason? reason) {
    _reason = reason;
  }

  @override
  String toString() => "$runtimeType: ${toNPayload().map}";

  @override
  NPayload toNPayload() => NPayload.makeWithSignature({
        "target": _target,
        "zoom": _zoom,
        "zoomBy": _zoomBy,
        "tilt": _tilt,
        "tiltBy": _tiltBy,
        "bearing": _bearing,
        "bearingBy": _bearingBy,
        "bounds": _bounds,
        "boundsPadding": _boundsPadding,
        "pivot": _pivot,
        "animation": _animation,
        "duration": _duration.inMilliseconds,
        "reason": _reason,
      }, sign: _signature);

  static const defaultMovingAnimation = NCameraAnimation.easing;
  static const defaultMovingDuration = Duration(milliseconds: 800);
}
