part of "../../../../flutter_naver_map.dart";

// todo 1 : 재사용 식별자(Identifier) 사용

/// 지도에서 사용할 수 있는 이미지 객체입니다.
///
/// 에셋, 파일, byteArray, 위젯을 통해 생성할 수 있습니다.
///
/// 메모리의 효율적인 사용을 위해, 한번 생성한 객체는 되도록 재사용해주세요.
class NOverlayImage with NMessageableWithMap {
  final String _path;
  final Uint8List _data;
  final _NOverlayImageMode _mode;

  const NOverlayImage._({
    required String path,
    required Uint8List data,
    required _NOverlayImageMode mode,
  })  : _path = path,
        _data = data,
        _mode = mode;

  /// 이미지 에셋으로 지도에서 사용할 이미지를 생성합니다. (jpg, png supported)
  NOverlayImage.fromAssetImage(String assetName)
      : _path = assetName,
        _data = Uint8List(0),
        _mode = _NOverlayImageMode.asset;

  /// 이미지 파일으로 지도에서 사용할 이미지를 생성합니다. (jpg, png supported)
  NOverlayImage.fromFile(File file)
      : _path = file.path,
        _data = Uint8List(0),
        _mode = _NOverlayImageMode.file;

  /// ByteArray로 지도에서 사용할 이미지를 생성합니다. (캐시를 사용합니다)
  static Future<NOverlayImage> fromByteArray(Uint8List imageBytes) async {
    final path = await ImageUtil.saveImage(imageBytes);
    return NOverlayImage._(
      path: path,
      data: Uint8List(0),
      mode: _NOverlayImageMode.temp,
    );
  }

  /// 위젯을 지도의 이미지로 생성합니다. (캐시를 사용합니다)
  ///
  /// 위젯을 이미지로 변환한 후 사용하므로, 인터렉션이 불가능함을 알아두세요.
  ///
  /// 위젯의 내부에 절대 이미지 위젯을 사용하지 마세요. (성능 이슈 및 로드가 되지 않는 현상이 발생합니다)
  /// 대신 `NOverlayImage.fromAssetImage` 또는 `.fromFile` 혹은 `.fromByteArray` 생성자를 사용하세요.
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
    return NOverlayImage._(
      path: path,
      data: Uint8List(0),
      mode: _NOverlayImageMode.widget,
    );
  }

  /// ByteArray로 지도에서 사용할 이미지를 생성합니다.
  static Future<NOverlayImage> fromData(Uint8List imageBytes) async {
    return NOverlayImage._(
      path: "",
      data: imageBytes,
      mode: _NOverlayImageMode.data,
    );
  }

  @override
  NPayload toNPayload() => NPayload.make({
        "path": _path,
        "data": _data,
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
          listEquals(_data, other._data) &&
          _mode == other._mode;

  @override
  int get hashCode => _path.hashCode ^ _mode.hashCode;
}
