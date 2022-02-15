part of flutter_naver_map;

/// ### 다각형을 면으로 나타내는 오버레이
/// 외부 링과 내부 링으로 구성되며, 간단한 삼각형이나 사각형을 비롯해 구멍 뚫인 다각형 등
/// 다양한 형태의 도형을 표현할 수 있습니다.
///
/// 다음의 요소들을 설정 할 수 있습니다.
/// - 다각형 지점([LatLng]의 [List]형태)
/// - 면 색상
/// - 테두리 두께
/// - 테두리 색상
class PolygonOverlay {
  /// ### 각각의 [PolygonOverlay]를 식별하기 위한 식별자
  /// ***값이 [null]일 경우 에러가 발생한다.***
  /// 같은 값을 가진 여러 객체가 추가될 경우 마지막으로 추가된 객체만 적용된다.
  final String polygonOverlayId;

  /// ### [polygonOverlay]의 좌표열
  /// ***배열의 길이가 3 미만인 경우 다각형을 이룰 수 없으므로, 에러가 발생한다.***
  ///
  /// 각각의 좌표([LatLng])로 이루어진 리스트이다.
  /// #### 주의!!!
  ///  - android 에서는 [LatLng]의 순서에 때라 선이 그려진다.
  ///  - iOS 에서는 좌표의 순서가 시계 방향이 아닌 경우, 선이 제대로 그려지지 않거나, 이벤트를 못받는 경우가 있다.
  ///     - 따라서 외곽선을 이루는 [coordinates]는 가능한 시계방향 순으로 입력해야 한다.
  List<LatLng> coordinates;

  /// ### [polygonOverlay]의 면 색상
  /// 아무 값도 없는 경우 기본 색상은 [Colors.white]이다.
  Color? color;

  /// ### [polygonOverlay]의 외곽선 색상
  /// 테두리의 색상을 지정합니다.
  /// 기본 색상은 [Colors.black]입니다.
  Color? outlineColor;

  /// ### [polygonOverlay]의 외곽선 두깨
  /// 테두리의 두께를 지정합니다. 0일 경우 테두리가 그려지지 않습니다.
  ///
  /// 단위는 dp 이며, 기본값은 0입니다.
  int? outlineWidth;

  /// ### [polygonOverlay]의 전역 z index
  int? globalZIndex;

  /// ### [polygonOverlay]의 내부 구멍
  /// 각각의 구멍에 대한 좌표열들로 구성된 배열이다.
  ///
  /// ***각각의 좌표열 또한 다각형을 이루기 위해서 배열의 크기가 3이상이어야 한다.***
  /// #### 주의!!!
  ///  - android 에서는 [LatLng]의 순서에 때라 선이 그려진다.
  ///  - iOS 에서는 좌표의 순서가 반 시계 방향이 아닌 경우, 선이 제대로 그려지지 않거나, 이벤트를 못받는 경우가 있다.
  ///     - 따라서 외곽선을 이루는 [coordinates]는 가능한 반시계방향 순으로 입력해야 한다.
  ///     - [coordinates]의 반대 방향으로!
  List<List<LatLng>>? holes;

  /// ### 다각형 오버레이에 대한 탭 이벤트
  /// 각 [PolygonOverlay]의 아이디를 파라미터로 전달 한다.
  void Function(String polygonOverlayId)? onTap;

  /// ### 폴리곤 오버레이 생성
  /// 기본적으로 [polygonOverlayId]와 [coordinates]는 필수적으로 필요하며,
  /// 그 외의 속성은 optional parameter 로 전달한다.
  PolygonOverlay(
    this.polygonOverlayId,
    this.coordinates, {
    this.color,
    this.outlineColor,
    this.outlineWidth,
    this.globalZIndex,
    this.holes,
    this.onTap,
  })  : assert(coordinates.length >= 3);

  /// 인자로 넘어오는 속성들이 적용된 새로운 [PolygonOverlay]객체를 생성합니다.
  PolygonOverlay copyWith(
          {List<LatLng>? coordsParam,
          Color? colorParam,
          Color? outlineColorParam,
          int? outlineWidthParam,
          int? globalZIndexParam,
          List<List<LatLng>>? holesParam,
          void Function(String polygonOverlayId)? onTapParam}) =>
      PolygonOverlay(polygonOverlayId, coordsParam ?? coordinates,
          color: colorParam ?? color,
          outlineColor: outlineColorParam ?? outlineColor,
          outlineWidth: outlineWidthParam ?? outlineWidth,
          globalZIndex: globalZIndexParam ?? globalZIndex,
          holes: holesParam ?? holes,
          onTap: onTapParam ?? onTap);

  /// 완전히 같은 속성값을 가진 [PolygonOverlay]객체를 생성합니다.
  PolygonOverlay clone() =>
      copyWith(coordsParam: List<LatLng>.from(coordinates));

  Map<String, dynamic> _toJson() {
    assert(coordinates.length >= 3);

    final Map<String, dynamic> json = {};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    List<List<double>> _serializeLatLngList(List<LatLng> list) =>
        list.map<List<double>>((e) => e._toJson()).toList();

    addIfPresent('polygonOverlayId', polygonOverlayId);
    addIfPresent('coords', _serializeLatLngList(coordinates));
    addIfPresent('color', color?.value);
    addIfPresent('outlineColor', outlineColor?.value);
    addIfPresent('outlineWidth', outlineWidth);
    addIfPresent('globalZIndex', globalZIndex);
    addIfPresent('holes', holes?.map((e) => _serializeLatLngList(e)).toList());
    return json;
  }

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    return other is PolygonOverlay
        ? polygonOverlayId == other.polygonOverlayId &&
            listEquals(coordinates, other.coordinates) &&
            color == other.color &&
            outlineColor == other.outlineColor &&
            outlineWidth == other.outlineWidth &&
            globalZIndex == other.globalZIndex &&
            listEquals(holes, other.holes) &&
            onTap == other.onTap
        : false;
  }

  @override
  int get hashCode => polygonOverlayId.hashCode;
}

Map<String, PolygonOverlay> _keyByPolygonId(Iterable<PolygonOverlay> polygons) {
  if (polygons.isEmpty) return {};
  return Map<String, PolygonOverlay>.fromEntries(polygons.map(
      (e) => MapEntry<String, PolygonOverlay>(e.polygonOverlayId, e.clone())));
}

List<Map<String, dynamic>?>? _serializePolygonSet(
    Iterable<PolygonOverlay?>? polygons) {
  if (polygons == null || polygons.isEmpty) return null;
  return polygons.map<Map<String, dynamic>?>((e) => e?._toJson()).toList();
}
