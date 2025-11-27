part of "../../../flutter_naver_map.dart";

/// 지도에서 보여주는 영역 혹은 위치를 바꿀 때의 애니메이션 종류를 나타내는 enum 입니다.
enum NCameraAnimation with NMessageableWithEnum { easing, fly, linear, none }

/// 지도의 종류를 나타내는 enum입니다.
enum NMapType with NMessageableWithEnum {
  /// 기본 지도입니다.
  basic,

  /// 네비게이션 지도입니다.
  navi,

  /// 위성 지도입니다.
  satellite,

  /// 위성 지도와 기본 지도를 겹쳐서 한번에 볼 수 있는 혼합 지도입니다.
  hybrid,

  /// 위성 지도와 네비게이션 지도를 겹쳐서 한번에 볼 수 있는 혼합 지도입니다.
  naviHybrid,

  /// 지형도입니다.
  terrain,
  none
}

/// 바닥 지도 위에 부가적인 정보를 나타내는 레이어를 의미하는 enum입니다.
enum NLayerGroup with NMessageableWithEnum {
  /// 건물 그룹
  building._("building"),

  /// 실시간 교통정보 그룹
  traffic._("ctt"),

  /// 대중교통 그룹
  transit._("transit"),

  /// 자전거 도로 그룹
  bicycle._("bike"),

  /// 등산로 그룹 (등산로, 등고선 등)
  mountain._("mountain"),

  /// 지적편집도 그룹
  cadastral._("landparcel");

  @override
  final String payload;

  const NLayerGroup._(this.payload);
}

/// 사용자의 위치를 실시간으로 보여줄 때 사용하는 모드를 나타내는 enum입니다.
enum NLocationTrackingMode with NMessageableWithEnum {
  /// 위치와 방위에 따라 지도가 움직입니다.
  face,

  /// 위치에 따라 지도가 움직입니다.
  follow,

  /// 사용자의 위치를 실시간으로 보여줍니다.
  ///
  /// 카메라가 따라서 이동하지 않습니다.
  noFollow,

  /// 실시간으로 사용자의 위치를 보여주지 않습니다.
  none;

  factory NLocationTrackingMode._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

enum NAlign with NMessageableWithEnum {
  center,
  left,
  right,
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;
}

enum NLogoAlign with NMessageableWithEnum {
  leftBottom,
  rightBottom,
  leftTop,
  rightTop;

  bool get isLeft => this == leftBottom || this == leftTop;
  bool get isRight => this == rightBottom || this == rightTop;
  bool get isTop => this == leftTop || this == rightTop;
  bool get isBottom => this == leftBottom || this == rightBottom;
}

/// 지도에서 사용자에게 보여주는 위치/영역이 바뀐 이유를 나타내는 enum입니다.
enum NCameraUpdateReason with NMessageableWithEnum {
  /// 개발자가 API를 호출하여 이동함을 의미합니다.
  /// [NCameraUpdate] 객체를 생성하였을 때의 기본 값입니다.
  developer._(0),

  /// 사용자의 제스처에 의해 이동함을 의미합니다.
  gesture._(-1),

  /// 사용자 컨트롤 UI(줌 컨트롤러 등) 의해 이동함을 의미합니다.
  control._(-2),

  /// 사용자 위치 추적 기능에 의해 이동함을 의미합니다. ([NaverMapController.setLocationTrackingMode])
  location._(-3),

  /// 콘텐츠 패딩의 변경에 의해 카메라가 이동함을 의미합니다.
  contentPadding._(-4);

  @override
  final int payload;

  const NCameraUpdateReason._(this.payload);

  factory NCameraUpdateReason._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);
}

/// 마커의 종류를 나타내는 enum입니다.
enum NOverlayType with NMessageableWithEnum {
  marker._("ma"),
  infoWindow._("in"),
  circleOverlay._("ci"),
  groundOverlay._("gr"),
  polygonOverlay._("pg"),
  polylineOverlay._("pl"),
  pathOverlay._("pa"),
  multipartPathOverlay._("mp"),
  arrowheadPathOverlay._("ah"),
  locationOverlay._("lo"),
  clusterableMarker._("cm");

  @override
  final String payload;

  const NOverlayType._(this.payload);

  factory NOverlayType._fromMessageable(dynamic m) =>
      values.firstWhere((value) => value.payload == m);

  @override
  String toString() => "$runtimeType.$name";
}

/// [NPolylineOverlay]의 끝 점의 모양을 나타내는 enum입니다.
enum NLineCap with NMessageableWithEnum {
  /// 사각형, 좌표에 딱 맞추어 잘림.
  butt,

  /// 둥글게 마무리. 좌표보다 두께의 반만큼 연장됨. (반원의 중점에 좌표가 위치함)
  round,

  /// 사각형, 좌표보다 두께의 반만큼 연장됨.
  square;
}

/// [NPolylineOverlay]의 연결 점의 모양을 나타내는 enum입니다.
enum NLineJoin with NMessageableWithEnum {
  /// 뾰족하게 그려짐.
  bevel,

  /// 뾰족한 부분이 직선으로 잘림.
  miter,

  /// 둥글게 이어짐.
  round;
}

/* ----- Private ----- */

enum _NOverlayImageMode with NMessageableWithEnum {
  asset,
  file,
  temp,
  widget;

  String toExplainString() =>
      this == _NOverlayImageMode.temp ? "byteArray" : name;
}
