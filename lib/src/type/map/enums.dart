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

  final String _mValue;

  const NLayerGroup._(this._mValue);

  @override
  String toNPayload() => _mValue;
}

enum NLocationTrackingMode implements NMessageableForEnum {
  face,
  follow,
  noFollow,
  none;

  factory NLocationTrackingMode._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
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

  factory NAlign._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
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

  factory NCameraUpdateReason._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
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

  factory NOverlayType._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
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

  factory NLineCap._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
  }

  @override
  String toNPayload() => name;
}

enum NLineJoin implements NMessageableForEnum {
  bevel,
  miter,
  round;

  factory NLineJoin._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
  }

  @override
  String toNPayload() => name;
}

/* ----- Private ----- */

enum _NOverlayImageMode implements NMessageableForEnum {
  asset,
  file,
  temp,
  widget;

  factory _NOverlayImageMode._fromMessageable(dynamic m) {
    for (final value in values) {
      if (value.toNPayload() == m) return value;
    }
    throw NUnknownTypeCastException(unknownValue: m);
  }

  @override
  String toNPayload() => name;

  String toExplainString() =>
      this == _NOverlayImageMode.temp ? "byteArray" : name;
}
