part of "messaging.dart";

@internal
class NMessageable {
  final dynamic payload;

  const NMessageable.forOnce(Object this.payload);

  NMessageable.forOnceWithMap(Map<String, dynamic> payload)
      : payload = NPayload.make(payload).map;

  @override
  String toString() => "$runtimeType: $payload";
}

@internal
mixin NMessageableWithMap implements NMessageable {
  @override
  Map<String, dynamic> get payload => toNPayload().map;

  NPayload toNPayload();
}

@internal
mixin NMessageableWithEnum on Enum implements NMessageable {
  @override
  dynamic get payload => name;
}

@internal
class NPayload {
  final Map<String, dynamic> map;

  NPayload._(this.map);

  factory NPayload.make(Map<String, dynamic> m) {
    _removeNull(m);
    final convertedM = _convertMapValueAsMessageable(m);
    return NPayload._(convertedM);
  }

  factory NPayload.makeWithSignature(Map<String, dynamic> m,
          {required String sign}) =>
      NPayload.make({...m, "sign": sign});

  NPayload expandWith(Map<String, dynamic> m) {
    final convertedM = _convertMapValueAsMessageable(m);
    return NPayload._({...map, ...convertedM});
  }

  static void _removeNull(Map<String, dynamic> m) =>
      m.removeWhere((key, value) => value == null);

  static Map<String, dynamic> _convertMapValueAsMessageable(
      Map<String, dynamic> m) {
    return m.map((key, value) => MapEntry(key, convertToMessageable(value)));
  }

  static dynamic convertToMessageable(Object value) {
    if (value.isDefaultType) return value;

    assert(value is NMessageable ||
        value is List ||
        value is Locale ||
        value is EdgeInsets ||
        value is Size ||
        value is Color);

    if (value is NMessageable) return value.payload;
    if (value is List) {
      return value.map((e) => convertToMessageable(e!)).toList();
    }
    return _convertFlutterTypes(value);
  }

  static dynamic _convertFlutterTypes(Object value) {
    if (value is Color) return value.value;

    late final NMessageable nMessageable;

    if (value is Locale) {
      nMessageable = NLocale.fromLocale(value);
    } else if (value is EdgeInsets) {
      nMessageable = NEdgeInsets.fromEdgeInsets(value);
    } else if (value is Size) {
      nMessageable = NSize.fromSize(value);
    }

    return nMessageable.payload;
  }

  @override
  String toString() => "NPayload{m: $map}";
}
