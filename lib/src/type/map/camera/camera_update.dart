part of flutter_naver_map;

class NCameraUpdate implements NMessageable {
  final NLatLng? _target;
  final double? _zoom;
  final double? _zoomBy;
  final double? _tilt;
  final double? _tiltBy;
  final double? _bearing;
  final double? _bearingBy;
  final NLatLngBounds? _bounds;
  final NEdgeInsets? _boundsPadding;
  NPoint? _pivot;
  NCameraAnimation _animation = defaultMovingAnimation;
  Duration _duration = defaultMovingDuration;

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
    NEdgeInsets? boundsPadding,
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
          {NEdgeInsets? nEdgeInsets}) =>
      NCameraUpdate._(
          bounds: bounds, boundsPadding: nEdgeInsets, signature: "fitBounds");

  void setPivot(NPoint pivot) => _pivot = pivot;

  void setAnimation(
      {NCameraAnimation animation = defaultMovingAnimation,
      Duration duration = defaultMovingDuration}) {
    _animation = animation;
    _duration = duration;
  }

  @override
  String toString() => "$runtimeType: ${toNPayload().json}";

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
      }, sign: _signature);

  static const defaultMovingAnimation = NCameraAnimation.easing;
  static const defaultMovingDuration = Duration(milliseconds: 800);
}
