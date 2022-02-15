part of flutter_naver_map;

/// 지도 카에라의 위치를 나타낸다.
/// [target]에서 보이는 카메라 화면은 가진 위,경도와 [zoom]레벨, [tilt]각도,
/// 그리고 [bearing]의 값들을 모두 종합한다.
class CameraPosition {
  const CameraPosition({
    this.bearing = 0.0,
    required this.target,
    this.tilt = 0.0,
    this.zoom = 15.0,
  }) ;

  /// 카메라 회전 각도. 북쪽에서 시계 방향으로의 회전량.
  ///
  /// 기본값은 '0'이고 카메라가 북쪽을 가르킨다.
  /// 90.0이 들어가게 되면 카메라의 상단이 동쪽을 바라본다.
  final double bearing;

  /// 카메라가 가르키는 위치의 위,경도값
  final LatLng target;

  /// 기본값으로 최소값인 0.0을 가진다. 지도의 기울기 값.
  /// 0의 값일때 카메라는 땅을 바로 위에서 바라본다.
  final double tilt;

  /// 기본값으로 0을 가진다.
  /// 지원되는 zoom level 은 장치나 지도 데이터에 따라 다른 범위를 가진다.
  final double zoom;

  dynamic toMap() => <String, dynamic>{
        'bearing': bearing,
        'target': target._toJson(),
        'tilt': tilt,
        'zoom': zoom,
      };

  static CameraPosition? fromMap(dynamic json) {
    if (json == null) {
      return null;
    }
    return CameraPosition(
      bearing: json['bearing'],
      target: LatLng._fromJson(json['target'])!,
      tilt: json['tilt'],
      zoom: json['zoom'],
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final CameraPosition typedOther = other;
    return bearing == typedOther.bearing &&
        target == typedOther.target &&
        tilt == typedOther.tilt &&
        zoom == typedOther.zoom;
  }

  @override
  int get hashCode => hashValues(bearing, target, tilt, zoom);

  @override
  String toString() =>
      'CameraPosition(bearing: $bearing, target: $target, tilt: $tilt, zoom: $zoom)';
}

/// 카메라의 동적 움직임을 정의한 클래스입니다.
/// 현재 위치로 부터의 온전한 움직임을 지원합니다.
class CameraUpdate {
  final dynamic _json;

  CameraUpdate._(this._json);

  dynamic _toJson() => _json;

  /// 카메라의 좌표를 target으로 변경하는 CameraUpdate 객체를 생성합니다.
  /// 줌 레벨, 기울기 각도, 베어링 각도 등 좌표 외의 다른 속성은 변하지 않습니다.
  static CameraUpdate scrollTo(LatLng latLng) {
    return CameraUpdate._({'scrollTo': latLng._toJson()});
  }

  /// 카메라를 position 위치로 이동하는 CameraUpdate 객체를 생성합니다.
  static CameraUpdate toCameraPosition(CameraPosition position) {
    return CameraUpdate._({'newCameraPosition': position.toMap()});
  }

  /// 카메라의 좌표, 줌 레벨, 애니메이션 시간을 이용하여 카메라를 이동하는 CameraUpdate 객체를 생성합니다.
  /// 현재 duration은 안드로이드에서는 지원하지 않습니다(기본 설정으로 작동됩니다)
  static CameraUpdate scrollWithOptions(LatLng latLng,
      {double? zoom, double? duration}) {
    Map cameraData = {'scrollTo': latLng._toJson()};
    if (zoom != null) cameraData['zoomTo'] = zoom;
    if (duration != null) cameraData['duration'] = duration;

    return CameraUpdate._(cameraData);
  }

  /// 카메라의 줌이 1만큼 증가하는 카메라 업데이트를 반환합니다.
  ///
  /// zooomBy(1.0) 을 실행하는 것과 동일한 효과를 가집니다.
  static CameraUpdate zoomIn() {
    return CameraUpdate._({'zoomIn': true});
  }

  /// 카메라의 줌이 1만큼 감소하는 카메라 업데이트를 반환합니다.
  ///
  /// zooomBy(-1.0) 을 실행하는 것과 동일한 효과를 가집니다.
  static CameraUpdate zoomOut() {
    return CameraUpdate._({'zoomOut': true});
  }

  /// 카메라의 줌을 zoom으로 변경하는 카메라 업테이트를 반환합니다.
  ///
  /// 좌표, 기울기 각도, 베어링등 다른 값은 변하지 않습니다.
  static CameraUpdate zoomTo(double zoom) {
    return CameraUpdate._({'zoomTo': zoom});
  }

  /// bounds가 화면에 온전히 보이는 좌표와 최대 줌 레벨로 카메라의 위치를
  /// 변경하는 CameraUpdate 객체를 생성합니다.
  /// </br>
  /// 기울기 각도와 베어링 각도는 0으로 변경되며, 피봇 지점은 무시됩니다
  /// <h3>padding 은 바운더리에 맞는 영역에 대해 상하좌우 여백을 설정하며 상대크기 단위입니다.</h3>
  static CameraUpdate fitBounds(LatLngBounds bounds, {int padding = 0}) {
    return CameraUpdate._({
      'fitBounds': [bounds._toList(), padding]
    });
  }
}

/// ## 카메라의 변경 원인
/// [NaverMap]의 onCameraChange 의 인자로 전달되는 값으로, 카메라가 움직이는 원인을 의미한다.
/// 각각의 값은 다음과 같은 의미를 가진다.
/// - [CameraChangeReason.developer]
///     - 개발자가 API를 호출해 카메라가 움직였음을 나타낸다. (기본값)
/// - [CameraChangeReason.gesture]
///     - 사용자의 제스처로 인해 카메라가 움직였음을 나타낸다.
/// - [CameraChangeReason.control]
///     - 사용자의 버튼 선택으로 인해 카메라가 움직였음을 나타낸다.
/// - [CameraChangeReason.location]
///     - 위치 트래킹 기능으로 인해 카메라가 움직였음을 나타낸다.
enum CameraChangeReason {
  /// 개발자가 API를 호출해 카메라가 움직였음을 나타낸다. (기본값)
  developer,

  /// 사용자의 제스처로 인해 카메라가 움직였음을 나타낸다.
  gesture,

  /// 사용자의 버튼 선택으로 인해 카메라가 움직였음을 나타낸다.
  control,

  /// 위치 트래킹 기능으로 인해 카메라가 움직였음을 나타낸다.
  location,
}
