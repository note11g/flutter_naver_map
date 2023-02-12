part of flutter_naver_map;

class NOverlayImage implements NMessageable {
  final String _path;
  final _NOverlayImageMode _mode;

  const NOverlayImage._({
    required String path,
    required _NOverlayImageMode mode,
  })  : _path = path,
        _mode = mode;

  const NOverlayImage.fromAssetImage(String assetName)
      : _path = assetName,
        _mode = _NOverlayImageMode.asset;

  NOverlayImage.fromFile(File file)
      : _path = file.path,
        _mode = _NOverlayImageMode.file;

  static Future<NOverlayImage> fromByteArray(Uint8List imageBytes) async {
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(path: path, mode: _NOverlayImageMode.temp);
  }

  static Future<NOverlayImage> fromWidget({
    required Widget widget,
    required Size size,
    required BuildContext context,
  }) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final imageBytes = await WidgetToImageUtil.widgetToImageByte(widget,
        size: size, pixelRatio: pixelRatio);
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(path: path, mode: _NOverlayImageMode.widget);
  }

  factory NOverlayImage._fromMessageable(dynamic m) {
    final nOverlayImage = NOverlayImage._(
      path: m["path"],
      mode: _NOverlayImageMode._fromMessageable(m["mode"]),
    );

    if (nOverlayImage != _none) {
      throw NUnknownTypeCastException(
          unknownValue: nOverlayImage.toNPayload().m.toString());
    }

    return _none;
  }

  static const _none = NOverlayImage._(path: "", mode: _NOverlayImageMode.temp);

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
