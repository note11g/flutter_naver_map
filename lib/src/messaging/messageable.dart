part of "messaging.dart";

class NMessageable {
  final dynamic payload;

  const NMessageable.forOnce(Object this.payload);

  NMessageable.forOnceWithMap(Map<String, dynamic> payload)
      : payload = NPayload.make(payload).map;

  @override
  String toString() => "$runtimeType: $payload";
}

mixin NMessageableWithMap implements NMessageable {
  @override
  Map<String, dynamic> get payload => toNPayload().map;

  NPayload toNPayload();
}

mixin NMessageableWithEnum on Enum implements NMessageable {
  @override
  dynamic get payload => name;
}

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

  static void _removeNull(Map<String, dynamic> m) =>
      m.removeWhere((key, value) => value == null);

  static Map<String, dynamic> _convertMapValueAsMessageable(
      Map<String, dynamic> m) {
    return m.map((key, value) => MapEntry(key, convertToMessageable(value)));
  }

  static dynamic convertToMessageable(Object value) {
    if (value.isDefaultType) return value;

    assert(value is NMessageable ||
        value is Iterable ||
        value is Locale ||
        value is EdgeInsets ||
        value is Size ||
        value is Color);

    switch (value) {
      case NMessageable():
        return value.payload;
      case Iterable():
        return value.map((e) => convertToMessageable(e!)).toList();
      default:
        final result = _tryConvertFlutterUITypes(value);
        if (result == null) {
          throw UnsupportedError(
              "Unsupported Messaging Type: ${value.runtimeType}");
        }
        return result;
    }
  }

  static dynamic _tryConvertFlutterUITypes(Object value) {
    return switch (value) {
      Locale() => NLocale.fromLocale(value).payload,
      EdgeInsets() => NEdgeInsets.fromEdgeInsets(value).payload,
      Size() => NSize.fromSize(value).payload,
      Color() => value.value,
      _ => null,
    };
  }

  @override
  String toString() => "NPayload{m: $map}";
}
