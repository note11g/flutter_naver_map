part of "../../../../flutter_naver_map.dart";

/// 마커에 텍스트로 부가정보를 나타낼 때 사용할 수 있는 캡션 객체입니다.
///
/// 캡션의 크기나, 색깔, 캡션의 테두리 색깔, 폭, 보이는 줌 범위를 지정할 수 있습니다.
class NOverlayCaption with NMessageableWithMap {
  /// 캡션 텍스트
  final String text;

  /// 캡션 텍스트 사이즈
  ///
  /// 기본값은 `12`입니다.
  final double textSize;

  /// 캡션 텍스트 색상
  ///
  /// 기본값은 [Colors.black]입니다.
  final Color color;

  /// 캡션 테두리 색상
  ///
  /// 기본값은 [Colors.white]입니다.
  final Color haloColor;

  /// 캡션이 보이는 최소 줌 레벨
  ///
  /// 기본 값은 지도의 최소 줌 레벨인 [NaverMapViewOptions.minimumZoom] (0)입니다.
  final double minZoom;

  /// 캡션이 보이는 최대 줌 레벨
  ///
  /// 기본 값은 지도의 최대 줌 레벨인 [NaverMapViewOptions.maximumZoom] (21)입니다.
  final double maxZoom;

  /// 개행될 너비를 지정합니다.
  /// 단위는 플러터에서 사용하는 것과 동일한 DP(논리픽셀)입니다.
  ///
  /// 개행은 어절단위로 이루어집니다.
  ///
  /// 기본 값은 제한하지 않음을 의미하는 `0`입니다.
  final double requestWidth;

  const NOverlayCaption({
    required this.text,
    this.textSize = 12.0,
    this.color = Colors.black,
    this.haloColor = Colors.white,
    this.minZoom = NaverMapViewOptions.minimumZoom,
    this.maxZoom = NaverMapViewOptions.maximumZoom,
    this.requestWidth = 0,
  });

  @override
  NPayload toNPayload() => NPayload.make({
        "text": text,
        "textSize": textSize,
        "color": color,
        "haloColor": haloColor,
        "minZoom": minZoom,
        "maxZoom": maxZoom,
        "requestWidth": requestWidth,
      });
}
