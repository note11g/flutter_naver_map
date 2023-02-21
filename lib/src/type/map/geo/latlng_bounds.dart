part of flutter_naver_map;

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

  bool containsPoint(NLatLng point) {
    return southLatitude <= point.latitude &&
        westLongitude <= point.longitude &&
        northLatitude >= point.latitude &&
        eastLongitude >= point.longitude;
  }

  bool containsBounds(NLatLngBounds bounds) {
    return southLatitude <= bounds.southLatitude &&
        westLongitude <= bounds.westLongitude &&
        northLatitude >= bounds.northLatitude &&
        eastLongitude >= bounds.eastLongitude;
  }

  NLatLngBounds expand(NLatLng point) {
    if (containsPoint(point)) return this;

    final northLatitude = max(this.northLatitude, point.latitude);
    final eastLongitude = max(this.eastLongitude, point.longitude);
    final southLatitude = min(this.southLatitude, point.latitude);
    final westLongitude = min(this.westLongitude, point.longitude);

    return NLatLngBounds(
        southWest: NLatLng(southLatitude, westLongitude),
        northEast: NLatLng(northLatitude, eastLongitude));
  }

  NLatLngBounds union(NLatLngBounds bounds) {
    if (containsBounds(bounds)) return this;

    final northLatitude = max(this.northLatitude, bounds.northLatitude);
    final eastLongitude = max(this.eastLongitude, bounds.eastLongitude);
    final southLatitude = min(this.southLatitude, bounds.southLatitude);
    final westLongitude = min(this.westLongitude, bounds.westLongitude);

    return NLatLngBounds(
        southWest: NLatLng(southLatitude, westLongitude),
        northEast: NLatLng(northLatitude, eastLongitude));
  }

  NLatLngBounds? intersection(NLatLngBounds bounds) {
    final maxWest = max(westLongitude, bounds.westLongitude);
    final minEast = min(eastLongitude, bounds.eastLongitude);
    if (minEast < maxWest) {
      return null;
    } else {
      final maxSouth = max(southLatitude, bounds.southLatitude);
      final minNorth = min(northLatitude, bounds.northLatitude);
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

  factory NLatLngBounds._fromMessageable(dynamic m) => NLatLngBounds(
      southWest: NLatLng._fromMessageable(m["southWest"]),
      northEast: NLatLng._fromMessageable(m["northEast"]));

  /*
    --- constant ---
  */

  static const NLatLngBounds world = NLatLng.worldCoverage;
}
