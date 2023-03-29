# 정보창

마커나 지도에 띄울 수 있는 정보창입니다

### 마커에 띄울 수 있는 정보창

```dart
final marker = NMarker(id: "test", position: target);
controller.addOverlay(marker);

final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "인포윈도우 텍스트");
// 지도에 추가된 마커에만 정보창을 띄울 수 있습니다.
marker.openInfoWindow(onMarkerInfoWindow);
```

### 지도에 띄울 수 있는 정보창

```dart
final infoWindow = NInfoWindow.onMap(id: "test", position: target, text: "인포윈도우 텍스트");
controller.addOverlay(infoWindow);
```