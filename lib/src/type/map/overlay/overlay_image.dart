part of flutter_naver_map;

class NOverlayImage with NMessageableWithMap {
  final String _path;
  final _NOverlayImageMode _mode;

  const NOverlayImage._({
    required String path,
    required _NOverlayImageMode mode,
  })  : _path = path,
        _mode = mode;

  NOverlayImage.fromFile(File file)
      : _path = file.path,
        _mode = _NOverlayImageMode.file;

  static Future<NOverlayImage> fromAssetImage({
    required String assetName,
    double? devicePixelRatio,
    TargetPlatform? platform,
  }) async {
    final configuration = ImageConfiguration(
      devicePixelRatio: devicePixelRatio,
      platform: platform ??
          (Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android),
    );
    final AssetImage assetImage = AssetImage(assetName);
    final AssetBundleImageKey key = await assetImage.obtainKey(configuration);

    return NOverlayImage._(path: key.name, mode: _NOverlayImageMode.asset);
  }

  static Future<NOverlayImage> fromByteArray(Uint8List imageBytes) async {
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(path: path, mode: _NOverlayImageMode.temp);
  }

  static Future<NOverlayImage> fromWidget({
    required Widget widget,
    required Size size,
    required BuildContext context,
  }) async {
    final imageBytes = await WidgetToImageUtil.widgetToImageByte(widget,
        size: size, context: context);
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(path: path, mode: _NOverlayImageMode.widget);
  }

  @override
  NPayload toNPayload() => NPayload.make({
        "path": _path,
        "mode": _mode,
      });

  @override
  String toString() => "NOverlayImage{from: ${_mode.toExplainString()}";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NOverlayImage &&
          runtimeType == other.runtimeType &&
          _path == other._path &&
          _mode == other._mode;

  @override
  int get hashCode => _path.hashCode ^ _mode.hashCode;
}
