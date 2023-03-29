# 컨트롤러

배치된 지도를 컨트롤할 수 있어요

[onMapReady](event.md#onmapready)에서 제공하는 `NaverMapController` 객체가 컨트롤러입니다.


### [카메라](camera.md) 관련 메서드
```dart
/// 카메라를 업데이트시킬 수 있어요
Future<bool> updateCamera(NCameraUpdate cameraUpdate);

/// 카메라가 애니메이션과 함께 이동할 때, 이동 도중 애니메이션을 멈출 수 있어요 
Future<void> cancelTransitions({NCameraUpdateReason reason = NCameraUpdateReason.developer});

/// 카메라 포지션(정보)를 가져올 수 있어요.
Future<NCameraPosition> getCameraPosition();

/// 지금 카메라로 보고 있는 컨텐츠 영역을 가져올 수 있어요.
/// withPadding이 true면, NaverMapViewOptions.contentPadding이 적용된 영역만 가져올 수 있어요.
/// getContentBounds와 getContentRegion은 반환 타입만 달라요.
Future<NLatLngBounds> getContentBounds({bool withPadding = false});
Future<List<NLatLng>> getContentRegion({bool withPadding = false});
```

### [오버레이](overlay/overlay.md) 관련 메서드
```dart
/// 위치 오버레이는 직접 생성할 수 없기에, 해당 메서드를 통해 가져올 수 있어요.
Future<NLocationOverlay> getLocationOverlay();

/// 오버레이를 하나만 추가할 수 있어요.
Future<void> addOverlay(NAddableOverlay overlay);

/// 오버레이 여러개를 한번에 추가할 수 있어요.
Future<void> addOverlayAll(Set<NAddableOverlay> overlays);

/// 특정 오버레이를 하나만 지울 수 있어요.
Future<void> deleteOverlay(NOverlayInfo info);

/// 오버레이를 모두 지울 수 있어요.
/// type을 지정하면, 해당 타입의 오버레이만 지울 수 있어요.
Future<void> clearOverlays({NOverlayType? type});

/// 화면 좌표를 이용해서, 해당 좌표 근처의 오버레이나, 심벌 정보를 가져올 수 있어요.
Future<List<NPickableInfo>> pickAll(NPoint point, {double radius = 0});
```

### 이외 메서드들

#### 화면 좌표 <-> 지도 좌표
```dart
/// 화면 좌표를 위경도 좌표로 변환할 수 있어요.
Future<NLatLng> screenLocationToLatLng(NPoint point);

/// 위경도 좌표를 화면 좌표로 변환할 수 있어요.
Future<NPoint> latLngToScreenLocation(NLatLng latLng);

/// 1DP (Logical Pixel와 동일)당 몇 미터인지 알 수 있어요.
/// latitude와 zoom을 지정하지 않으면 모두 현재 카메라의 값을 사용해요.
/// 현재 카메라의 좌표가 아닌, 특정 좌표에서의 값을 알아야 한다면, latitiude를 지정해주어야 하고,
/// 현재 카메라의 줌 레벨이 아닌, 특정 줌 레벨에서의 값을 알아야 한다면, zoom을 지정해주어야 해요. 
Future<double> getMeterPerDp({double? latitude, double? zoom});
```

#### Location Tracking Mode 관련 메서드

```dart
/// Location Tracking Mode를 설정할 수 있어요.
Future<void> setLocationTrackingMode(NLocationTrackingMode mode);

/// Location Tracking Mode를 가져올 수 있어요.
Future<NLocationTrackingMode> getLocationTrackingMode();
```

#### 스크린샷 찍기
```dart
/// 현재 보이는 지도를 캡쳐할 수 있어요.
/// `showControls`는 내 위치 버튼, 실내 지도 피커 등의 컨트롤 UI도 캡쳐할지 여부를 지정해요.
/// `compressQuality`는 캡쳐한 이미지의 품질을 지정해요. (100=원본)
Future<File> takeSnapshot({bool showControls = true, int compressQuality = 80});      
```