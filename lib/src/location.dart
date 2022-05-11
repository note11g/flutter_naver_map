part of flutter_naver_map;

/// 위도와 경도가 한 쌍을 이루어서 저장되는 class.
class LatLng {
  const LatLng(double latitude, double longitude)
      : latitude =
            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  final double latitude;
  final double longitude;

  List<double> get json => [latitude, longitude];

  dynamic _toJson() {
    return <double>[latitude, longitude];
  }

  static LatLng? _fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLng(json[0], json[1]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);

  /// 다른 좌표와의 거리를 반환합니다.
  /// [other] : 거리를 잴 다른 좌표
  /// [return] : 좌표 간의 거리. 미터 단위.
  double distanceTo(LatLng other) {
    if (latitude == other.latitude && longitude == other.longitude) {
      return 0.0;
    } else {
      final double lat1 = radians(latitude);
      final double lng1 = radians(longitude);
      final double lat2 = radians(other.latitude);
      final double lng2 = radians(other.longitude);
      return 1.2756274e7 * asin(sqrt(pow(sin((lat1 - lat2) / 2.0), 2.0) + cos(lat1) * cos(lat2) * pow(sin((lng1 - lng2) / 2.0), 2.0)));
    }
  }
}

/// 북동쪽 위, 경도와 남서쪽 위,경도로 만들어진 사각형 영역이다.
class LatLngBounds {
  LatLngBounds({required this.southwest, required this.northeast})
      : assert(southwest.latitude <= northeast.latitude);

  /// The southwest corner of the rectangle.
  final LatLng southwest;

  /// The northeast corner of the rectangle.
  final LatLng northeast;

  /// <h2>LatLng 의 배열로 LatLngBounds 를 만드는 factory</h2>
  /// <hr/>
  /// <p>list로 전달된 [LatLng]들의 배열들을 이용해서 south, north, east, west 를
  /// 계산하여 [LatLngBounds]를 생성한다.</p>
  factory LatLngBounds.fromLatLngList(List<LatLng> latLngs) {
    if (latLngs.length < 2) {
      throw ArgumentError('최소한 2개 이상의 리스트 길이가 있어야 LatLngBounds를 만들 수 있습니다.');
    }
    double south = 200, west = 200;
    double north = -200, east = -200;
    for (LatLng latLng in latLngs) {
      if (south > latLng.longitude) south = latLng.longitude;
      if (north < latLng.longitude) north = latLng.longitude;
      if (east < latLng.latitude) east = latLng.latitude;
      if (west > latLng.latitude) west = latLng.latitude;
    }
    return LatLngBounds(
      southwest: LatLng(west, south),
      northeast: LatLng(east, north),
    );
  }

  List<List<double>> get json => [southwest.json, northeast.json];

  dynamic _toList() {
    return <dynamic>[southwest._toJson(), northeast._toJson()];
  }

  /// Returns whether this rectangle contains the given [LatLng].
  bool contains(LatLng point) {
    return _containsLatitude(point.latitude) &&
        _containsLongitude(point.longitude);
  }

  bool _containsLatitude(double lat) {
    return (southwest.latitude <= lat) && (lat <= northeast.latitude);
  }

  bool _containsLongitude(double lng) {
    if (southwest.longitude <= northeast.longitude) {
      return southwest.longitude <= lng && lng <= northeast.longitude;
    } else {
      return southwest.longitude <= lng || lng <= northeast.longitude;
    }
  }

  @visibleForTesting
  static LatLngBounds? fromList(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLngBounds(
      southwest: LatLng._fromJson(json[0])!,
      northeast: LatLng._fromJson(json[1])!,
    );
  }

  @override
  String toString() {
    return '$runtimeType($southwest, $northeast)';
  }

  @override
  bool operator ==(Object o) {
    return o is LatLngBounds &&
        o.southwest == southwest &&
        o.northeast == northeast;
  }

  @override
  int get hashCode => hashValues(southwest, northeast);
}
//
//List<Map<String, double>> _serializeLatLngList(List<LatLng> locations) {
//  if (locations == null) return null;
//  return locations.map((location) => location._toJson()).toList();
//}

enum LocationTrackingMode {
  /// 위치를 추적하지 않습니다.
  None,

  /// 위치 추적이 활성화되고, 현위치 오버레이가 사용자의 위치를 따라 움직입니다.
  /// 그러나 지도는 움직이지 않습니다.
  NoFollow,

  /// 위치 추적이 활성화되고, 현위치 오버레이와 카메라의 좌표가 사용자의 위치를 따라
  /// 움직입니다. API나 제스처를 사용해 임의로 카메라를 움직일 경우 모드가
  /// NoFollow로 바뀝니다.
  Follow,

  /// 위치 추적이 활성화되고, 현위치 오버레이, 카메라의 좌표, 베어링이 사용자의 위치
  /// 및 방향을 따라 움직입니다. API나 제스처를 사용해 임의로 카메라를 움직일 경우
  /// 모드가 NoFollow로 바뀝니다.
  Face,
}
