# 위젯

네이버 지도를 플러터에서 배치할 수 있는 있는 요소입니다.

`NaverMap` 위젯은 다음처럼 사용합니다.

```dart
NaverMap(
    options: const NaverMapViewOptions(), // 지도 옵션을 설정할 수 있습니다.
    forceGesture: false, // 지도에 터치 이벤트를 강제로 전달할지 여부를 설정합니다.
    onMapReady: (controller) {},
    onMapTapped: (point, latLng) {},
    onSymbolTapped: (symbol) {},
    onCameraChange: (position, reason) {},
    onCameraIdle: () {},
    onSelectedIndoorChanged: (indoor) {},
)
```

`NaverMap` 위젯 자체에는 기본값이 지정되어 있어, 필수 인자가 없습니다.

따라서, 다음처럼 사용할 수도 있습니다.

```dart
NaverMap()
```

---

이 페이지에서는, 이벤트를 제외한 `options`와 `forceGesture`을 알아보도록 하겠습니다.

## NaverMapViewOptions

:::tip
`NaverMapViewOptions`에는  [오버레이](./overlay.md), [좌표](./coord.md), [카메라](./camera.md) 구성요소가 사용됩니다.

먼저, 해당 요소들의 설명을 보고 오시면, 이해가 쉬울 것입니다.
:::

`NaverMapViewOptions`는 말 그대로, 네이버 맵의 View에 대한 속성을 지정하는 객체입니다.

어떤 옵션을 지정할 수 있는지 살펴보도록 하겠습니다.

<details>
<summary>전체 옵션 보기</summary>

| 옵션 이름                      | 간단 설명                              | 타입 (단위)                 | 기본값                      |
|----------------------------|------------------------------------|-------------------------|--------------------------|
| `initialCameraPosition`    | 첫 로딩시 CameraPosition               | `NCameraPosition?`      | `null`                   |          
| `extent`                   | 지도의 제한 영역                          | `NLatLngBounds?`        | `null`                   |
| `mapType`                  | 지도 유형                              | `NMapType`              | `NMapType.basic`         | 
| `liteModeEnable`           | 라이트 모드(저사양 모드,<br/>지도유형 basic만 지원) | `bool`                  | `false`                  |
| `nightModeEnable`          | 나이트 모드<br/>(지도유형 navi만 지원)         | `bool`                  | `false`                  |
| `indoorEnable`             | 실내 지도 활성화 여부                       | `bool`                  | `false`                  |
| `activeLayerGroups`        | 활성화 할 레이어 그룹                       | `List<NLayerGroup>`     | `[NLayerGroup.building]` |
| `buildingHeight`           | 건물 3D 높이 배율 (`0`: 2D ~ `1`)        | `double` (배)            | `1`                      |
| `lightness`                | 명도 (`-1`: 검정색 ~ `1`: 흰색)           | `double`                | `0`                      |
| `symbolScale`              | 심볼의 크기 배율 (`0` ~ `2`: 2배)          | `double` (배)            | `1`                      |
| `symbolPerspectiveRatio`   | 심볼의 원근 계수 (`0`~ `1`)               | `double`                | `1`                      |
| `indoorFocusRadius`        | 실내지도 영역 포커스 유지 반경                  | `double` (LogicalPixel) | `defaultIndoorFocusDp`   |
| `pickTolerance`            | `pickable`의 터치 반경                  | `double` (LogicalPixel) | `defaultPickTolerance`   |
| `rotationGesturesEnable`   | 회전 제스처 활성화 여부                      | `bool`                  | `true`                   |
| `scrollGesturesEnable`     | 스크롤 제스처 활성화 여부                     | `bool`                  | `true`                   |
| `tiltGesturesEnable`       | 틸트 제스처 활성화 여부                      | `bool`                  | `true`                   |
| `zoomGesturesEnable`       | 줌 제스처 활성화 여부                       | `bool`                  | `true`                   |
| `stopGesturesEnable`       | 스톱 제스처 활성화 여부                      | `bool`                  | `true`                   |
| `scrollGesturesFriction`   | 스크롤 제스처 마찰 계수 (`0`~ `1`)           | `double`                | `defaultGestureFriction` |
| `zoomGesturesFriction`     | 줌 제스처 마찰 계수 (`0`~ `1`)             | `double`                | `defaultGestureFriction` |
| `rotationGesturesFriction` | 회전 제스처 마찰 계수 (`0`~ `1`)            | `double`                | `defaultGestureFriction` |
| `consumeSymbolTapEvents`   | 심볼 탭 이벤트 소비 여부                     | `bool`                  | `true`                   |
| `scaleBarEnabled`          | 축적 바 활성화 여부                        | `bool`                  | `true`                   |
| `indoorLevelPickerEnabled` | 실내 지도 레벨 피커 활성화 여부                 | `bool`                  | `true`                   |
| `locationButtonEnable`     | 위치 버튼 활성화 여부                       | `bool`                  | `false`                  |
| `logoClickEnabled`         | 로고 클릭 활성화 여부                       | `bool`                  | `true`                   |
| `logoAlign`                | 로고 정렬 위치                           | `NLogoAlign`            | `NLogoAlign.leftBottom`  |
| `logoMargin`               | 로고 마진                              | `EdgeInsets?`           | `null`                   |
| `contentPadding`           | 콘텐츠 패딩                             | `EdgeInsets`            | `EdgeInsets.zero`        |
| `minZoom`                  | 최소 줌 레벨                            | `double`                | `minimumZoom` (`0`)      |
| `maxZoom`                  | 최대 줌 레벨                            | `double`                | `maximumZoom` (`21`)     |
| `maxTilt`                  | 최대 틸트 각도                           | `double` (도)            | `63`                     |
| `locale`                   | 지도 언어                              | `Locale`                | `NLocale.systemLocale`   |

</details>

### 첫 로딩시 카메라 포지션 지정

### 지도 유형 지정

    ### 라이트 모드 활성화 (liteModeEnable)
    ### 나이트 모드 활성화 (nightModeEnable)
    ### 실내 지도 활성화 (indoorEnable)

### 표시할 정보 레이어 선택하기

### `pickable`의 터치 반경 (pickTolerance)

### 제스처 (Gestures)

    제스처에는 회전, 스크롤, 틸트, 줌, 스톱이 있습니다.
    마찰 계수도 여기 포함
    ### 최대/최소 줌 레벨 제한/틸트 각도 제한

### 지도 영역 제한

### 실내지도

    ### 실내지도 영역 포커스 유지 반경

### 언어 지정

### 기타

    ### 건물 3D 높이 배율
    ### 명도
    ### 심볼의 크기 배율
    ### 심볼의 원근 계수
    ### 축적 바 활성화 여부
    ### 로고 클릭 활성화 여부

---

## forceGesture

이 옵션은 Scroll이 가능한 위젯 (`ListView`, `GridView`, `SingleChildScrollView` ...) 안에서

스크롤 제스처가 `NaverMap`의 제스처보다 우선시되어, `NaverMap`에 전달되는 제스처가 무시되는 현상을 방지하기 위해 사용합니다.

**forceGesture 사용 예시**

```dart
ListView(
    children: [
        // ... some widgets
        NaverMap(
            // ... other options
            forceGesture: true,
        ),
    ],
)
```

