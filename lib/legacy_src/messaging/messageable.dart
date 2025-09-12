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

  factory NPayload.make(Map<String, dynamic> m, {bool sendNull = false}) {
    if (!sendNull) _removeNull(m);
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

  static dynamic convertToMessageable(Object? value) {
    if (value == null) return null;
    if (value.isDefaultType) return value;

    return switch (value) {
      NMessageable() => value.payload,
      List() => value.map((e) => convertToMessageable(e!)).toList(),
      Map<String, dynamic>() =>
        value.map((k, v) => MapEntry(k, convertToMessageable(v))),
      Map<NMessageable, dynamic>() =>
        value.map((k, v) => MapEntry(k.payload, convertToMessageable(v))),
      Locale() ||
      EdgeInsets() ||
      Size() ||
      Color() =>
        _convertFlutterTypes(value),
      _ => throw ArgumentError.value(value),
    };
  }

  static dynamic _convertFlutterTypes(Object value) {
    return switch (value) {
      Color() => value.value,
      Locale() => NLocale.fromLocale(value).payload,
      EdgeInsets() => NEdgeInsets.fromEdgeInsets(value).payload,
      Size() => NSize.fromSize(value).payload,
      _ => throw ArgumentError.value(value),
    };
  }

  @override
  String toString() => "NPayload{m: $map}";
}
