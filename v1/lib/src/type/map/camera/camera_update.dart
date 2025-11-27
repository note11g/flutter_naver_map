part of "../../../../flutter_naver_map.dart";

/// 카메라가 보여주는 곳을 변경할 때 사용하는 객체입니다.
///
/// 문서를 참고하세요. [문서 보러가기](https://note11.dev/flutter_naver_map/element/camera#ncameraupdate)
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

  /// NCameraPosition 객체를 이용해 NCameraUpdate 객체를 생성합니다.
  factory NCameraUpdate.fromCameraPosition(NCameraPosition position) =>
      NCameraUpdate.withParams(
        target: position.target,
        zoom: position.zoom,
        tilt: position.tilt,
        bearing: position.bearing,
      );

  /// 줌 레벨을 1 증가시킵니다.
  factory NCameraUpdate.zoomIn() => NCameraUpdate.zoomBy(1);

  /// 줌 레벨을 1 감소시킵니다.
  factory NCameraUpdate.zoomOut() => NCameraUpdate.zoomBy(-1);

  /// 줌 레벨을 상대적으로 설정합니다.
  factory NCameraUpdate.zoomBy(double delta) =>
      NCameraUpdate.withParams(zoomBy: delta);

  /// 간단하게 특정 지점 혹은 줌 레벨만을 지정하기 위해 사용하는 생성자입니다.
  factory NCameraUpdate.scrollAndZoomTo({NLatLng? target, double? zoom}) =>
      NCameraUpdate.withParams(target: target, zoom: zoom);

  /// target, zoom, bearing, tilt를 모두 선택적으로 설정할 수 있는 생성자입니다.
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

  /// NLatLngBounds에 해당하는 영역을 온전하게 보여주는 NCameraUpdate 객체를 생성합니다.
  factory NCameraUpdate.fitBounds(NLatLngBounds bounds,
          {EdgeInsets? padding}) =>
      NCameraUpdate._(
          bounds: bounds, boundsPadding: padding, signature: "fitBounds");

  /// 카메라의 이동 기준점을 설정하는 메서드입니다.
  /// 기본값은 화면 중앙을 의미하는 [NPoint.relativeCenter]입니다.
  void setPivot(NPoint pivot) => _pivot = pivot;

  /// 카메라가 이동할 때의 애니메이션을 설정하는 메서드입니다.
  void setAnimation({
    NCameraAnimation animation = NCameraAnimation.easing,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    _animation = animation;
    _duration = duration;
  }

  /// 카메라 업데이트의 원인을 설정하는 메서드입니다.
  void setReason(NCameraUpdateReason reason) {
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
