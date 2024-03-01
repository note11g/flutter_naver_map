part of flutter_naver_map;

// todo 1 : 재사용 식별자(Identifier) 사용

/// 지도에서 사용할 수 있는 이미지 객체입니다.
///
/// 에셋, 파일, byteArray, 위젯을 통해 생성할 수 있습니다.
///
/// 메모리의 효율적인 사용을 위해, 한번 생성한 객체는 되도록 재사용해주세요.
class NOverlayImage with NMessageableWithMap {
  final String _path;
  final _NOverlayImageMode _mode;

  const NOverlayImage._({
    required String path,
    required _NOverlayImageMode mode,
  })  : _path = path,
        _mode = mode;

  /// 이미지 에셋으로 지도에서 사용할 이미지를 생성합니다. (jpg, png supported)
  const NOverlayImage.fromAssetImage(String assetName)
      : _path = assetName,
        _mode = _NOverlayImageMode.asset;

  /// 이미지 파일으로 지도에서 사용할 이미지를 생성합니다. (jpg, png supported)
  NOverlayImage.fromFile(File file)
      : _path = file.path,
        _mode = _NOverlayImageMode.file;

  /// ByteArray로 지도에서 사용할 이미지를 생성합니다. (캐시를 사용합니다)
  static Future<NOverlayImage> fromByteArray(Uint8List imageBytes) async {
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(path: path, mode: _NOverlayImageMode.temp);
  }

  /// 위젯을 지도의 이미지로 생성합니다. (캐시를 사용합니다)
  ///
  /// 위젯을 이미지로 변환한 후 사용하므로, 인터렉션이 불가능함을 알아두세요.
  static Future<NOverlayImage> fromWidget({
    required Widget widget,
    required Size size,
    required BuildContext context,
  }) async {
    assert(
        widget.runtimeType != Image,
        "Do not use Image widget.\n"
        "Instead, using `NOverlayImage.fromAssetImage` or `.fromFile` or `.fromByteArray` Constructor.");
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
  String toString() => "NOverlayImage{from: ${_mode.toExplainString()}}";

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
