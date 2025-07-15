part of "../../../../flutter_naver_map.dart";

/// 영역의 서쪽의 좌표와 북동쪽의 좌표를 이용하여 영역의 최소 경계 사각형(MBR)을 나타내는 객체입니다.
///
/// 자세한 내용은 문서를 참조하세요. [문서 바로가기](https://note11.dev/flutter_naver_map/element/coord#nlatlngbounds-%EB%B2%94%EC%9C%84)
class NLatLngBounds with NMessageableWithMap {
  final NLatLng southWest;
  final NLatLng northEast;

  NLatLng get southEast => NLatLng(southLatitude, eastLongitude);

  NLatLng get northWest => NLatLng(northLatitude, westLongitude);

  NLatLng get center => NLatLng((southLatitude + northLatitude) / 2.0,
      (westLongitude + eastLongitude) / 2.0);

  double get southLatitude => southWest.latitude;

  double get westLongitude => southWest.longitude;

  double get northLatitude => northEast.latitude;

  double get eastLongitude => northEast.longitude;

  const NLatLngBounds({required this.southWest, required this.northEast});

  factory NLatLngBounds.from(Iterable<NLatLng> points) {
    if (points.isEmpty) {
      throw ArgumentError("Cannot create LatLngBounds with an empty list");
    } else {
      double minLatitude = NLatLng.maximumLatitude;
      double maxLatitude = NLatLng.minimumLatitude;
      double minLongitude = NLatLng.maximumLongitude;
      double maxLongitude = NLatLng.minimumLongitude;

      for (final point in points) {
        if (point.latitude < minLatitude) minLatitude = point.latitude;
        if (point.latitude > maxLatitude) maxLatitude = point.latitude;
        if (point.longitude < minLongitude) minLongitude = point.longitude;
        if (point.longitude > maxLongitude) maxLongitude = point.longitude;
      }

      return NLatLngBounds(
          southWest: NLatLng(minLatitude, minLongitude),
          northEast: NLatLng(maxLatitude, maxLongitude));
    }
  }

  /// 영역이 특정 지점([point])를 포함하는지 여부를 반환합니다.
  bool containsPoint(NLatLng point) {
    return southLatitude <= point.latitude &&
        westLongitude <= point.longitude &&
        northLatitude >= point.latitude &&
        eastLongitude >= point.longitude;
  }

  /// 영역이 다른 영역([bounds])를 포함하는지 여부를 반환합니다.
  bool containsBounds(NLatLngBounds bounds) {
    return southLatitude <= bounds.southLatitude &&
        westLongitude <= bounds.westLongitude &&
        northLatitude >= bounds.northLatitude &&
        eastLongitude >= bounds.eastLongitude;
  }

  /// 영역과 다른 한 지점([point]) 포함하는 최소한의 bounds를 반환합니다. (합집합)
  NLatLngBounds expand(NLatLng point) {
    if (containsPoint(point)) return this;

    final northLatitude = math.max(this.northLatitude, point.latitude);
    final eastLongitude = math.max(this.eastLongitude, point.longitude);
    final southLatitude = math.min(this.southLatitude, point.latitude);
    final westLongitude = math.min(this.westLongitude, point.longitude);

    return NLatLngBounds(
        southWest: NLatLng(southLatitude, westLongitude),
        northEast: NLatLng(northLatitude, eastLongitude));
  }

  /// 영역과 다른 영역([bounds])을 포함하는 최소한의 영역을 반환합니다. (합집합)
  NLatLngBounds union(NLatLngBounds bounds) {
    if (containsBounds(bounds)) return this;

    final northLatitude = math.max(this.northLatitude, bounds.northLatitude);
    final eastLongitude = math.max(this.eastLongitude, bounds.eastLongitude);
    final southLatitude = math.min(this.southLatitude, bounds.southLatitude);
    final westLongitude = math.min(this.westLongitude, bounds.westLongitude);

    return NLatLngBounds(
        southWest: NLatLng(southLatitude, westLongitude),
        northEast: NLatLng(northLatitude, eastLongitude));
  }

  /// 영역과 다른 영역([bounds])이 겹치는 영역을 반환합니다. (교집합)
  NLatLngBounds? intersection(NLatLngBounds bounds) {
    final maxWest = math.max(westLongitude, bounds.westLongitude);
    final minEast = math.min(eastLongitude, bounds.eastLongitude);
    if (minEast < maxWest) {
      return null;
    } else {
      final maxSouth = math.max(southLatitude, bounds.southLatitude);
      final minNorth = math.min(northLatitude, bounds.northLatitude);
      return minNorth < maxSouth
          ? null
          : NLatLngBounds(
              northEast: NLatLng(minNorth, minEast),
              southWest: NLatLng(maxSouth, maxWest));
    }
  }

  /*
    --- required method ---
  */

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NLatLngBounds &&
          runtimeType == other.runtimeType &&
          southWest == other.southWest &&
          northEast == other.northEast;

  @override
  int get hashCode => southWest.hashCode ^ northEast.hashCode;

  @override
  String toString() => "$runtimeType: ${toNPayload().map}";

  @override
  NPayload toNPayload() => NPayload.make({
        "southWest": southWest,
        "northEast": northEast,
      });

  @internal
  factory NLatLngBounds.fromMessageable(dynamic m) => NLatLngBounds(
      southWest: NLatLng.fromMessageable(m["southWest"]),
      northEast: NLatLng.fromMessageable(m["northEast"]));

  /*
    --- constant ---
  */

  static const NLatLngBounds world = NLatLng.worldCoverage;
}
