import "package:flutter_naver_map/src/messaging/messaging.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("Iterable in payload serialization test (#217)", () {
    final rawMap = {
      "list": [1, 2, 3],
      "set": {"a", "b", "c"},
    };
    expect(rawMap["list"].runtimeType.toString(), "List<int>");
    expect(rawMap["set"].runtimeType.toString(), "_Set<String>");

    final payload = NPayload.make(rawMap);
    expect(payload.map["list"].runtimeType.toString(), "List<dynamic>");
    expect(payload.map["set"].runtimeType.toString(), "List<dynamic>");
  });
}
