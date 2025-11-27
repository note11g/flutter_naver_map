part of "messaging.dart";

enum NChannel {
  naverMapNativeView("flutter_naver_map_view"),
  overlayChannelName("flutter_naver_map_overlay");

  final String str;

  const NChannel(this.str);

  static const _separateString = "#";

  MethodChannel _create(int id) => MethodChannel("$str$_separateString$id");

  @override
  String toString() => name;

  /* ----- Pre-defined Channel ----- */
  static const MethodChannel sdkChannel =
      MethodChannel("flutter_naver_map_sdk");
}
