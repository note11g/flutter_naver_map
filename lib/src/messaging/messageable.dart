part of flutter_naver_map_messaging;

abstract class NMessageable {
  NPayload toNPayload();

  @override
  String toString() => "$runtimeType: ${toNPayload().m}";
}

abstract class NMessageableForEnum {
  dynamic toNPayload();
}

class NPayload {
  final Map<String, dynamic> m;

  NPayload._(this.m);

  factory NPayload.make(Map<String, dynamic> m) {
    _removeNull(m);
    final convertedm = _convertMapValueAsMessageable(m);
    return NPayload._(convertedm);
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

  static dynamic convertToMessageable(dynamic value) {
    if (value is NMessageable) {
      return value.toNPayload().m;
    } else if (value is NPayload) {
      return value.m;
    } else if (value is NMessageableForEnum) {
      return value.toNPayload();
    } else if (value is List) {
      return value.map((e) => convertToMessageable(e)).toList();
    } else {
      return _convertDefaultTypes(value);
    }
  }

  static dynamic _convertDefaultTypes(dynamic value) {
    if (value is Color) {
      return value.value;
    } else if (value is Locale) {
      return NLocale.fromLocale(value);
    } else if (value is EdgeInsets) {
      return NEdgeInsets.fromEdgeInsets(value);
    } else if (value is Size) {
      return NSize.fromSize(value);
    } else {
      return value;
    }
  }

  @override
  String toString() => "NPayload{m: $m}";
}
