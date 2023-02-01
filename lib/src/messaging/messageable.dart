part of flutter_naver_map_messaging;

abstract class NMessageable {
  NPayload toNPayload();

  @override
  String toString() => "$runtimeType: ${toNPayload().json}";
}

abstract class NMessageableForEnum {
  dynamic toNPayload();
}

class NPayload {
  final Map<String, dynamic> json;

  NPayload._(this.json);

  factory NPayload.make(Map<String, dynamic> json) {
    _removeNull(json);
    final convertedJson = _convertMapValueAsMessageable(json);
    return NPayload._(convertedJson);
  }

  factory NPayload.makeWithSignature(Map<String, dynamic> json,
          {required String sign}) =>
      NPayload.make({...json, "sign": sign});

  static void _removeNull(Map<String, dynamic> json) =>
      json.removeWhere((key, value) => value == null);

  static Map<String, dynamic> _convertMapValueAsMessageable(
      Map<String, dynamic> json) {
    return json
        .map((key, value) => MapEntry(key, convertToMessageable(value)));
  }

  static dynamic convertToMessageable(dynamic value) {
    if (value is NMessageable) {
      return value.toNPayload().json;
    } else if (value is NPayload) {
      return value.json;
    } else if (value is NMessageableForEnum) {
      return value.toNPayload();
    } else if (value is List) {
      return value.map((e) => convertToMessageable(e)).toList();
    } else {
      return value;
    }
  }

  @override
  String toString() => "NPayload{json: $json}";
}
