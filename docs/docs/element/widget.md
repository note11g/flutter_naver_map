# 위젯

export const Highlight = ({children, color, to}) => (
<a style={{display: 'inline-block'}} href={to}>
<span style={{ backgroundColor: color, borderRadius: '4px', color: '#fff', padding: '0.2rem', fontSize: '0.825rem',
fontWeight: '700' }}>{children}</span>
</a>
);

export const IndoorSupported = () => (
<Highlight color="#EDD06B" to="#실내-지도-활성화-indoorenable">실내지도 지원</Highlight>
);

export const NightModeSupported = () => (
<Highlight color="#494949" to="#litemode경량모드-활성화-litemodeenable">NightMode 지원</Highlight>
);

export const LiteModeSupported = () => (
<Highlight color="#4DBBF9" to="#야간모드-활성화-nightmodeenable">LiteMode 지원</Highlight>
);

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

이 페이지에서는, `options`와 `forceGesture`을 알아보도록 하겠습니다.

`onMapTapped`나, `onMapReady`와 같은 콜백 함수들은, [이벤트](./event.md) 페이지에서 다루도록 하겠습니다.

---

## NaverMapViewOptions

:::tip
`NaverMapViewOptions`에는  [오버레이](./overlay.md), [좌표](./coord.md), [카메라](./camera.md), [이벤트](./event.md) 구성요소가 사용됩니다.

먼저, 해당 요소들의 설명을 보고 오시면, 이해가 쉬울 것입니다.
:::

`NaverMapViewOptions`는 말 그대로, 네이버 맵의 View에 대한 속성을 지정하는 객체입니다.

어떤 옵션을 지정할 수 있는지 살펴보도록 하겠습니다.

<details>
<summary>전체 옵션 보기</summary>

| 옵션 이름                      | 간단 설명                              | 타입 (단위)                 | 기본값                           |
|----------------------------|------------------------------------|-------------------------|-------------------------------|
| `initialCameraPosition`    | 첫 로딩시 CameraPosition               | `NCameraPosition?`      | `null`                        |          
| `extent`                   | 지도의 제한 영역                          | `NLatLngBounds?`        | `null`                        |
| `mapType`                  | 지도 유형                              | `NMapType`              | `NMapType.basic`              | 
| `liteModeEnable`           | 라이트 모드(저사양 모드,<br/>지도유형 basic만 지원) | `bool`                  | `false`                       |
| `nightModeEnable`          | 나이트 모드<br/>(지도유형 navi만 지원)         | `bool`                  | `false`                       |
| `indoorEnable`             | 실내 지도 활성화 여부                       | `bool`                  | `false`                       |
| `activeLayerGroups`        | 활성화 할 레이어 그룹                       | `List<NLayerGroup>`     | `[NLayerGroup.building]`      |
| `buildingHeight`           | 건물 3D 높이 배율 (`0`: 2D ~ `1`)        | `double` (배)            | `1`                           |
| `lightness`                | 명도 (`-1`: 검정색 ~ `1`: 흰색)           | `double`                | `0`                           |
| `symbolScale`              | 심볼의 크기 배율 (`0` ~ `2`: 2배)          | `double` (배)            | `1`                           |
| `symbolPerspectiveRatio`   | 심볼의 원근 계수 (`0`~ `1`)               | `double`                | `1`                           |
| `indoorFocusRadius`        | 실내지도 영역 포커스 유지 반경                  | `double` (LogicalPixel) | `defaultIndoorFocusDp` (`55`) |
| `pickTolerance`            | `pickable`의 터치 반경                  | `double` (LogicalPixel) | `defaultPickTolerance` (`2`)  |
| `rotationGesturesEnable`   | 회전 제스처 활성화 여부                      | `bool`                  | `true`                        |
| `scrollGesturesEnable`     | 스크롤 제스처 활성화 여부                     | `bool`                  | `true`                        |
| `tiltGesturesEnable`       | 틸트 제스처 활성화 여부                      | `bool`                  | `true`                        |
| `zoomGesturesEnable`       | 줌 제스처 활성화 여부                       | `bool`                  | `true`                        |
| `stopGesturesEnable`       | 스톱 제스처 활성화 여부                      | `bool`                  | `true`                        |
| `scrollGesturesFriction`   | 스크롤 제스처 마찰 계수 (`0`~ `1`)           | `double`                | `defaultGestureFriction`      |
| `zoomGesturesFriction`     | 줌 제스처 마찰 계수 (`0`~ `1`)             | `double`                | `defaultGestureFriction`      |
| `rotationGesturesFriction` | 회전 제스처 마찰 계수 (`0`~ `1`)            | `double`                | `defaultGestureFriction`      |
| `consumeSymbolTapEvents`   | 심볼 탭 이벤트 소비 여부                     | `bool`                  | `true`                        |
| `scaleBarEnable`           | 축적 바 활성화 여부                        | `bool`                  | `true`                        |
| `indoorLevelPickerEnable`  | 실내 지도 레벨 피커 활성화 여부                 | `bool`                  | `true`                        |
| `locationButtonEnable`     | 위치 버튼 활성화 여부                       | `bool`                  | `false`                       |
| `logoClickEnable`          | 로고 클릭 활성화 여부                       | `bool`                  | `true`                        |
| `logoAlign`                | 로고 정렬 위치                           | `NLogoAlign`            | `NLogoAlign.leftBottom`       |
| `logoMargin`               | 로고 마진                              | `EdgeInsets?`           | `null`                        |
| `contentPadding`           | 콘텐츠 패딩                             | `EdgeInsets`            | `EdgeInsets.zero`             |
| `minZoom`                  | 최소 줌 레벨                            | `double`                | `minimumZoom` (`0`)           |
| `maxZoom`                  | 최대 줌 레벨                            | `double`                | `maximumZoom` (`21`)          |
| `maxTilt`                  | 최대 틸트 각도                           | `double` (도)            | `63`                          |
| `locale`                   | 지도 언어                              | `Locale`                | `NLocale.systemLocale`        |

</details>

---

### 첫 로딩시 카메라 포지션 지정

`initialCameraPosition` 속성을 통해 첫 로딩시 카메라의 위치를 지정할 수 있습니다.

```dart
NaverMapViewOptions(
  initialCameraPosition: NCameraPosition(
    target: NLatLng(latitude, longitude),
    zoom: 10,
    bearing: 0,
    tilt: 0
  ),
)
```

---

### 지도 유형 지정

지도 유형은 `mapType` 속성을 통해 지정할 수 있습니다.
유형은 아래 5가지를 지원합니다.

- `NMapType.basic` : 기본 지도 (기본 값) <IndoorSupported/> <LiteModeSupported/>
- `NMapType.navi` : 네비게이션 지도 <NightModeSupported/>
- `NMapType.satellite` : 위성 지도 (위성 사진만 노출) <LiteModeSupported/>
- `NMapType.hybrid` : 하이브리드 지도 (위성 지도 + 심볼 + 도로) <LiteModeSupported/>
- `NMapType.terrain` : 지형 지도 <IndoorSupported/> <LiteModeSupported/>

다음은 지도 유형을 네비게이션 지도로 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  mapType: NMapType.navi,
)
```

<details>
<summary>실내 지도 (indoorEnable, indoorFocusRadius)</summary>

#### 실내 지도 활성화 (indoorEnable)

`indoorEnable` 속성을 `true`로 설정하면 실내지도를 사용할 수 있습니다.

다음은 실내 지도를 활성화하는 예제입니다.

```dart
NaverMapViewOptions(
  indoorEnable: true,
)
```

#### 실내지도 영역 포커스 유지 반경 (indoorFocusRadius)

실내지도 영역 포커스 유지 반경은 `indoorFocusRadius` 속성을 통해 지정할 수 있습니다.

다음은 실내지도 영역 포커스 유지 반경을 30 LogicalPixel로 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  indoorEnable: true,
  indoorFocusRadius: 30, // default is 55
)
```

</details>

<details>
<summary>LiteMode(경량모드) 활성화</summary>

#### LiteMode(경량모드) 활성화 (`liteModeEnable`)

경량 모드는 메모리 소모가 적고, 빠른 지도 로딩을 위해 사용할 수 있습니다.
하지만, 다음과 같은 제약사항이 존재합니다. 따라서, 라이트 모드를 사용할 때는 이를 고려해야 합니다.

- 지도 화질이 떨어짐
- `NMapType.navi` 지도 유형 사용 불가
- 레이어 그룹 사용 불가
- 디스플레이 옵션 변경 불가
- 실내지도 사용 불가
- 카메라 줌/회전/틸트시 지도 심벌도 함께 줌/회전/틸트됨
- 심벌 터치 이벤트 처리 불가
- 마커/심벌 겹침 처리 불가

다음은 경량 모드를 활성화하는 예제입니다.

```dart
NaverMapViewOptions(
  mapType: NMapType.basic,
  liteModeEnable: true,
)
```

</details>


<details>
<summary>NightMode(야간모드) 활성화</summary>

#### 야간모드 활성화 (`nightModeEnable`)

야간모드는 `NMapType.navi` 지도 유형에서만 사용할 수 있습니다.

다음은 야간모드를 활성화하는 예제입니다.

```dart
NaverMapViewOptions(
  mapType: NMapType.navi,
  nightModeEnable: true,
)
```

</details>




---

### 표시할 정보 레이어 선택하기 (레이어 그룹)

지도 유형에 따라 표시할 정보 레이어를 선택할 수 있습니다.

- `NLayerGroup.building` : 건물 레이어 (건물 형상, 주소 심벌 등)
- `NLayerGroup.traffic` : 실시간 교통정보 레이어
- `NLayerGroup.transit` : 대중교통 레이어 (철도, 지하철 노선, 버스정류장 등)
- `NLayerGroup.bicycle` : 자전거 레이어 (자전거 도로, 자전거 주차대 등)
- `NLayerGroup.mountain` : 등산 레이어 (등산로, 등고선 등)
- `NLayerGroup.cadastral` : 지적 편집도 레이어

지도 유형에 따라 지원되는 정보 레이어가 다르며, 지도 유형에 따라 지원하지 않는 레이어는 무시됩니다.

| basic | navi                      | satellite                                                                | hybrid, terrain                                             |
|-------|---------------------------|--------------------------------------------------------------------------|-------------------------------------------------------------|
| 모두 지원 | `building`,<br/>`traffic` | `traffic`,<br/>`transit`,<br/>`bicycle`,<br/>`mountain`,<br/>`cadastral` | 모두 지원.<br/>(단, `building` 레이어는<br/>건물 주소, 입구 등에 대한 심벌만 노출됨) |

다음은 건물 레이어와 대중교통 레이어를 노출하는 예제입니다.

```dart
NaverMapViewOptions(
  mapType: NMapType.basic,
  activeLayerGroups: [
    NLayerGroup.building,
    NLayerGroup.transit
  ], // default : [NLayerGroup.building]
)
```

---

### 오버레이와 심볼의 터치 반경 (pickTolerance)

`pickable`인 오버레이와 심볼은 터치 이벤트를 처리할 수 있습니다.

이때, 터치 이벤트를 처리할 수 있는 반경을 `pickTolerance` 속성을 통해 지정할 수 있습니다.

다음은 터치 반경을 8 LogicalPixel 으로 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  pickTolerance: 8, // default is 2 LogicalPixel
)
```

---

### 심볼 이벤트 소비 여부

`consumeSymbolTapEvents` 속성을 통해 심볼의 터치 이벤트를 소비할지 여부를 지정할 수 있습니다.

터치 이벤트를 소비하면, 심볼의 터치 이벤트는 발생하지만 지도의 터치 이벤트는 발생하지 않습니다.
소비하지 않으면, 심볼의 터치 이벤트와 지도의 터치 이벤트가 모두 발생합니다.

---

### 제스처 (Gestures)

제스처에는 회전, 스크롤, 틸트(기울기), 줌(확대), 스톱이 있습니다.

#### 제스처 활성화/비활성화

다음은 모든 제스처를 비활성화하는 예제입니다.

```dart
NaverMapViewOptions(
  rotationGesturesEnable: false,
  scrollGesturesEnable: false,
  tiltGesturesEnable: false, 
  zoomGesturesEnable: false,
  stopGesturesEnable: false,
)
```

#### 제스처 마찰계수

제스처의 마찰계수를 지정합니다. 마찰계수는 0.0 ~ 1.0 사이의 값을 가집니다.

0에 가까울 수록 마찰이 없기에 미끄럽게 움직이고, 1에 가까울 수록 마찰이 많아 뻑뻑하게 움직입니다.

스크롤, 줌, 회전 제스처가 마찰 계수 지정을 지원합니다.

기본값은 각각 다르기에, 기본값을 의미하는 `defaultGestureFriction`을 지정하면 기본값이 적용됩니다.

다음은 제스처의 마찰을 가장 뻑뻑하게 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  scrollGesturesFriction: 1.0,
  zoomGesturesFriction: 1.0,
  rotationGesturesFriction: 1.0,
)
```

---

### 이동 제한

#### 줌/틸트 제한

최소/최대 줌 레벨과 틸트 각도를 제한할 수 있습니다.

- 줌 레벨은 0 ~ 21 사이의 값을 가집니다.
- 틸트 각도는 0도 ~ 63도 사이의 값을 가집니다.

다음은 최소 줌 레벨을 10으로, 최대 줌 레벨을 16으로, 최대 틸트 각도를 30도로 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  minZoom: 10, // default is 0
  maxZoom: 16, // default is 21
  maxTilt: 30, // default is 63
)
```

#### 지도 영역 제한

지도 영역을 제한할 수 있습니다.

다음은 지도 영역을 한반도 인근으로 제한하는 예제입니다.

```dart
NaverMapViewOptions(
  extent: NLatLngBounds(
    southWest: NLatLng(31.43, 122.37),
    northEast: NLatLng(44.35, 132.0),
  ),
)
```

---

### 언어 지정

지도에 표시되는 언어를 지정할 수 있습니다.

다음은 지도에 표시되는 언어를 영어로 지정하는 예제입니다.

```dart
NaverMapViewOptions(
  locale: Locale('en'),
)
```

---

### 기타

#### 명도

`lightness` 옵션을 통해, 지도의 명도를 지정할 수 있습니다. -1 ~ 1 사이의 값을 가집니다.

-1(검정색)에 가까울 수록 어두워지고, 1(흰색)에 가까울 수록 밝아집니다.

기본값은 0입니다.

#### 건물 3D 높이 배율

`buildingHeight` 옵션을 통해, 건물의 3D 높이 배율을 지정할 수 있습니다. 0 ~ 1 사이의 값을 가집니다.

0일 경우, 지도를 기울여도, 건물은 2D로 표시됩니다.

기본값은 1입니다.

#### 심볼의 크기 배율

`symbolScale` 옵션을 통해, 심볼의 크기 배율을 지정할 수 있습니다. 0 ~ 2 사이의 값을 가집니다.

기본값은 1입니다.

#### 심볼의 원근 계수

`symbolPerspectiveRatio` 옵션을 통해, 심볼의 원근 계수를 지정할 수 있습니다. 0 ~ 1 사이의 값을 가집니다.

기울였을 때, 심볼의 원근 효과가 0에 가까울 수록 줄어듭니다.

기본값은 1입니다.

#### UI 요소

- **콘텐츠 패딩** : `contentPadding` 옵션을 통해, 지도의 콘텐츠 패딩을 지정할 수 있습니다. (기본값 `EdgeInsets.zero`)
- **축적 바** : `scaleBarEnable` 옵션을 통해, 축적 바를 활성화/비활성화할 수 있습니다. (기본값 `true`)
- **내위치 버튼** : `locationButtonEnable` 옵션을 통해, 내위치 버튼을 활성화/비활성화할 수 있습니다. (기본값 `false`)
- **실내 지도 레벨 피커** : `indoorLevelPickerEnable` 옵션을 통해, 실내 지도 레벨 피커를 활성화/비활성화할 수 있습니다. (기본값 `true`)
- **네이버 로고** : `logoAlign` 속성과, `logoMargin` 속성을 통해 로고의 위치를 지정할 수 있습니다. `logoClickEnable` 속성을 `false`로 지정하면, 로고를 클릭해도
  NaverMap의 정보가 표시되지 않습니다. (기본값 `true`)
  :::caution
  네이버 지도 SDK를 사용하는 앱은 반드시 네이버 로고가 앱의 UI 요소에 가려지지 않도록 해야 합니다. (앞서 언급한 속성들을 이용하면 됩니다)

  로고 클릭을 비활성화한 앱은 반드시 앱 내에 네이버 맵 SDK의 법적공지와 오픈소스 라이선스 정보를 제공해야 합니다.
  :::

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
            forceGesture: true,
        ),
    ],
)
```

