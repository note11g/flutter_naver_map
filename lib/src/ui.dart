part of flutter_naver_map;

/// 지도의 유형을 지정하는 enum.
/// 네이버 SDK가 지원하는 지도 유형은 5가지 입니다. [MapType.Basic], [MapType.Navi],
/// [MapType.Satellite], [MapType.Hybrid], [MapType.Terrain]
enum MapType {
  /// 일반 지도입니다. 하천, 녹지, 도로, 심벌 등 다양한 정보를 노출합니다.
  Basic,

  /// 차량용 내비게이션에 특화된 지도입니다.
  Navi,

  /// 위성 지도입니다. 심벌, 도로 등 위성 사진을 제외한 요소는 노출되지 않습니다.
  Satellite,

  /// 위성 사진과 도로, 심벌을 함께 노출하는 하이브리드 지도입니다.
  Hybrid,

  /// 지형도입니다. 산악 지형을 실제 지형과 유사하게 입체적으로 표현합니다.
  Terrain,
}

/// 레이어 그룹은 지도 유형과 달리 동시에 두 개 이상을 활성화할 수 있습니다.
/// 단, 지도 유형에 따라 표현 가능한 레이어 그룹이 정해져 있습니다.
/// 지도 유형이 특정 레이어 그룹을 지원하지 않으면 활성화하더라도 해당하는
/// 요소가 노출되지 않습니다. 지도 유형별로 표현할 수 있는 레이어 그룹은 다음과 같습니다.
///
/// -
///
/// 실시간 교통정보 - BASIC, NAVI, SATELLITE, HYBRID, TERRAIN
///
/// 건물 - BASIC, NAVI, HYBRID, TERRAIN
///
/// 대중교통 - BASIC, SATELLITE, HYBRID, TERRAIN
///
/// 자전거 - BASIC, SATELLITE, HYBRID, TERRAIN
///
/// 등산로 - BASIC, SATELLITE, HYBRID, TERRAIN
///
/// 지적편집도 - BASIC, SATELLITE, HYBRID, TERRAIN
enum MapLayer {
  /// 건물 그룹입니다. 활성화할 경우 건물 형상, 주소 심벌 등 건물과 관련된 요소가 노출됩니다. 기본적으로 활성화됩니다.
  LAYER_GROUP_BUILDING,

  /// 실시간 교통정보 그룹입니다. 활성화할 경우 실시간 교통정보가 노출됩니다.
  LAYER_GROUP_TRAFFIC,

  /// 대중교통 그룹입니다. 활성화할 경우 철도, 지하철 노선, 버스정류장 등 대중교통과 관련된 요소가 노출됩니다.
  LAYER_GROUP_TRANSIT,

  /// 자전거 그룹입니다. 활성화할 경우 자전거 도로, 자전거 주차대 등 자전거와 관련된 요소가 노출됩니다.
  LAYER_GROUP_BICYCLE,

  /// 등산로 그룹입니다. 활성화할 경우 등산로, 등고선 등 등산과 관련된 요소가 노출됩니다.
  LAYER_GROUP_MOUNTAIN,

  /// 지적편집도 그룹입니다. 활성화할 경우 지적편집도가 노출됩니다.
  LAYER_GROUP_CADASTRAL,
}
