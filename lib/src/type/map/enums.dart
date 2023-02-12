part of flutter_naver_map;

enum NCameraAnimation with NMessageableWithEnum { easing, fly, linear, none }

enum NMapType with NMessageableWithEnum {
  basic,
  hybrid,
  navi,
  satellite,
  terrain,
  none
}

enum NLayerGroup with NMessageableWithEnum {
  building._("building"),
  traffic._("ctt"),
  transit._("transit"),
  bicycle._("bike"),
  mountain._("mountain"),
  cadastral._("landparcel");

  @override
  final String payload;

  const NLayerGroup._(this.payload);
}

enum NLocationTrackingMode with NMessageableWithEnum {
  face,
  follow,
  noFollow,
  none;

  factory NLocationTrackingMode._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

enum NAlign with NMessageableWithEnum {
  center,
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  factory NAlign._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

enum NLogoAlign with NMessageableWithEnum {
  leftBottom,
  rightBottom,
  leftTop,
  rightTop
}

enum NCameraUpdateReason with NMessageableWithEnum {
  developer._(0),
  gesture._(-1),
  control._(-2),
  location._(-3);

  @override
  final int payload;

  const NCameraUpdateReason._(this.payload);

  factory NCameraUpdateReason._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

enum NOverlayType with NMessageableWithEnum {
  marker._("ma"),
  infoWindow._("in"),
  circleOverlay._("ci"),
  groundOverlay._("gr"),
  polygonOverlay._("pg"),
  polylineOverlay._("pl"),
  pathOverlay._("pa"),
  multipartPathOverlay._("mp"),
  arrowheadPathOverlay._("ah"),
  locationOverlay._("lo");

  @override
  final String payload;

  const NOverlayType._(this.payload);

  factory NOverlayType._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);

  @override
  String toString() => "$runtimeType.$name";
}

enum NLineCap with NMessageableWithEnum {
  butt,
  round,
  square;

  factory NLineCap._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

enum NLineJoin with NMessageableWithEnum {
  bevel,
  miter,
  round;

  factory NLineJoin._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

/* ----- Private ----- */

enum _NOverlayImageMode with NMessageableWithEnum {
  asset,
  file,
  temp,
  widget;

  factory _NOverlayImageMode._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);

  String toExplainString() =>
      this == _NOverlayImageMode.temp ? "byteArray" : name;
}
