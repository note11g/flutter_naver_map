part of flutter_naver_map_messaging;

enum NChannel {
  naverMapNativeView("flutter_naver_map_view"),
  overlayChannelName("flutter_naver_map_overlay");

  final String str;

  const NChannel(this.str);

  static const separateString = "#";

  MethodChannel createChannel(int id) =>
      MethodChannel("$str$separateString$id");

  @override
  String toString() => name;

  /* ----- Pre-defined Channel ----- */
  static const MethodChannel sdkChannel =
      MethodChannel("flutter_naver_map_sdk");
}
