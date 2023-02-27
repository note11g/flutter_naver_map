# 이벤트

지도의 상태 변경, 사용자의 터치 이벤트 등을 받을 수 있습니다.

## 이벤트 종류

### `NaverMap` 위젯에서 설정

- [onMapReady](#onmapready) : 지도가 준비되었을 때 발생합니다.
- [onMapTapped](#onmaptapped) : 지도를 클릭했을 때 발생합니다.
- [onSymbolTapped](#onsymboltapped) : 심볼을 클릭했을 때 발생합니다.
- [onCameraChange](#oncamerachange) : 카메라가 이동중일 때 발생합니다.
- [onCameraIdle](#oncameraidle) : 카메라가 이동이 끝났을 때 발생합니다.
- [onSelectedIndoorChanged](#onselectedindoorchanged) : 선택된 실내지도 구역 혹은 층이 변경될 때 발생합니다.

### 다른 방법으로 설정

- [오버레이 탭 이벤트](#오버레이-탭-이벤트) : 오버레이를 클릭했을 때 발생합니다.

---

## 이벤트 사용법

### OnMapReady

```dart
NaverMap(
  onMapReady: (NaverMapController controller) {
    // 지도가 준비되었을 때 실행할 코드
    // 여기서 NaverMapController 객체를 얻을 수 있습니다.
  },
)
```

### OnMapTapped

```dart
NaverMap(
  onMapTapped: (NPoint point, NLatLng latLng) {
    // 지도를 클릭했을 때 실행할 코드
  },
)
```

### OnSymbolTapped

```dart
NaverMap(
  onSymbolTapped: (NSymbol symbol) {
    // 심볼을 클릭했을 때 실행할 코드
  },
)
```

### OnCameraChange

NCameraUpdateReason에는 다음과 같은 값이 있습니다.

- `developer` : 개발자가 카메라를 이동시켰을 경우
- `gesture` : 사용자가 카메라를 이동시켰을 경우
- `contol` : 사용자의 버튼 선택으로 인해 카메라가 움직였을 경우
- `location` : 내장 위치 추적 기능으로 인하여 카메라가 움직였을 경우

```dart
NaverMap(
  onCameraChange: (NCameraUpdateReason reason, bool animated) {
    // 카메라가 이동중일 때 실행할 코드
  },
)
```

### OnCameraIdle

```dart
NaverMap(
  onCameraIdle: () {
    // 카메라가 이동이 끝났을 때 실행할 코드
  },
)
```

### OnSelectedIndoorChanged

```dart
NaverMap(
  onSelectedIndoorChanged: (NSelectedIndoor? selectedIndoor) {
    // 선택된 실내지도 구역 혹은 층이 변경될 때 실행할 코드
    // 선택된 실내지도가 없을 경우 null이 전달됩니다.
  },
)
```

### 오버레이 탭 이벤트

오버레이 객체에 `setOnTapListener` 메서드를 사용하여 이벤트를 설정할 수 있습니다.

다음은 마커에 탭 이벤트를 설정하는 예제입니다.

```dart
final marker = NMarker(id: latLng.toString(), position: latLng);

marker.setOnTapListener((NMarker marker) {
  // 마커를 클릭했을 때 실행할 코드
});
```