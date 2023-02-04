part of flutter_naver_map;

enum NCameraAnimation implements NMessageableForEnum {
  easing,
  fly,
  linear,
  none;

  @override
  String toNPayload() => name;
}

enum NMapType implements NMessageableForEnum {
  basic,
  hybrid,
  navi,
  satellite,
  terrain,
  none;

  @override
  String toNPayload() => name;
}

enum NLayerGroup implements NMessageableForEnum {
  building._("building"), // iOS not checked!!
  traffic._("ctt"),
  transit._("transit"),
  bicycle._("bike"),
  mountain._("mountain"),
  cadastral._("landparcel");

  final String _jsonValue;

  const NLayerGroup._(this._jsonValue);

  @override
  String toNPayload() => _jsonValue;
}

enum NLocationTrackingMode implements NMessageableForEnum {
  face,
  follow,
  noFollow,
  none;

  factory NLocationTrackingMode._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => name;
}

enum NAlign implements NMessageableForEnum {
  center,
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  factory NAlign._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => name;
}

enum NLogoAlign implements NMessageableForEnum {
  leftBottom,
  rightBottom,
  leftTop,
  rightTop;

  @override
  String toNPayload() => name;
}

enum NCameraUpdateReason implements NMessageableForEnum {
  developer._(0),
  gesture._(-1),
  control._(-2),
  location._(-3);

  final int code;

  const NCameraUpdateReason._(this.code);

  factory NCameraUpdateReason._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  int toNPayload() => code;
}

enum NOverlayType implements NMessageableForEnum {
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

  final String _str;

  const NOverlayType._(this._str);

  factory NOverlayType._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => _str;

  @override
  String toString() => _str;
}

enum NLineCap implements NMessageableForEnum {
  butt,
  round,
  square;

  factory NLineCap._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => name;
}

enum NLineJoin implements NMessageableForEnum {
  bevel,
  miter,
  round;

  factory NLineJoin._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => name;
}

/* ----- Private ----- */

enum _NOverlayImageMode implements NMessageableForEnum {
  asset,
  file,
  temp;

  factory _NOverlayImageMode._fromJson(dynamic json) {
    for (final value in values) {
      if (value.toNPayload() == json) return value;
    }
    throw NUnknownTypeCastException(unknownValue: json);
  }

  @override
  String toNPayload() => name;
}
