# 오버레이

지도에 그릴 수 있는 것으로, 대표적으로 마커나 경로가 있습니다.

오버레이는 `NLocationOverlay`를 제외하면 모두 개발자가 직접 생성하여 지도에 추가할 수 있습니다.

오버레이에는 여러가지 종류가 있습니다.

- 마커 ([NMarker](./marker))
- 정보창 ([NInfoWindow](./info_window))
- 도형 오버레이 ([NCircleOverlay](./shape_overlay#ncircleoverlay), [NPolygonOverlay](./shape_overlay#npolygonoverlay),
  [NPolylineOverlay](./shape_overlay#npolylineoverlay))
- 지상 오버레이 ([NGroundOverlay](./ground_overlay))
- 경로
  오버레이 ([NPathOverlay](./path_overlay#npathoverlay), [NMultipartPathOverlay](./path_overlay#nmultipartpathoverlay), [NArrowheadPathOverlay](./path_overlay#narrowheadpathoverlay))
- 위치 오버레이 ([NLocationOverlay](./location_overlay))

하나씩 살펴보기 전, 오버레이가 공통적으로 가지는 특징에 대해 알아보도록 하겠습니다.

## 오버레이의 공통 특징

- [겹침 우선순위](#겹침-우선순위)를 지정할 수 있습니다.
- [지도에서 숨길](#지도에서-숨김) 수 있습니다.
- [보이는 줌 레벨의 범위](#보여지는-줌-레벨의-범위-지정)를 지정할 수 있습니다.
- [터치 이벤트](#터치-이벤트)를 지정할 수 있습니다.
- [오버레이 이미지](#오버레이에-이미지-지정)를 지정할 수 있습니다. (icon이 있는 오버레이 한정)

### 생성/지도에 추가/지도에서 제거

:::tip
추가할 수 있는 오버레이는 `id`를 가지며, 이를 통해 특정 오버레이만 지도에서 제거할 수 있습니다.
`id`는 오버레이 종류별로 구분되므로, 같은 `id`를 가진 오버레이를 여러 종류의 오버레이에 추가할 수 있습니다.

같은 종류이면서, 같은 `id`를 가지는 오버레이를 여러번 지도에 추가할 경우, 마지막에 추가한 오버레이만 지도에 표시됩니다.
:::

위치 오버레이를 제외한 모든 오버레이는 직접 개발자가 생성하여 지도에 추가할 수 있습니다.

```dart
// 세개의 오버레이 생성
final marker1 = NMarker(id: '1', position: latLng1);
final marker2 = NMarker(id: '2', position: latLng2);
final circle = NCircleOverlay(id: '1', center: latLng3);

// 지도에 하나씩 추가
mapController.addOverlay(marker1);
// 혹은 한번에 추가할 경우 (여러개를 추가할 때에는 이 방법을 사용하는 것을 권장합니다.)
mapController.addOverlayAll({marker2, circle}); // Set<NOverlay> 타입을 인자로 받습니다.

// 특정 id를 가진 지도에서 제거
mapController.deleteOverlay(NOverlayInfo(type: NOverlayType.marker, id: '2'));
// 혹은 특정 종류의 오버레이만 제거
mapController.clearOverlays(type: NOverlayType.circleOverlay);
// 혹은 모든 오버레이 제거
mapController.clearOverlays();
```

### 겹침 우선순위

오버레이는 지도에 그려질 때, 겹칠 수 있습니다.

이때, 겹친 오버레이들은 겹침 우선순위에 따라서 값이 클 수록 위에, 작을 수록 아래에 그려집니다.

겹침 우선순위는 전역 우선순위와 보조 우선순위가 있습니다.

#### 전역 우선순위 (GlobalZIndex)

전역 우선순위는 **오버레이의 종류에 따라** 지정할 수 있습니다.

지정하게 되면, 지도에 추가되어있는 같은 종류의 오버레이들의 겹침 우선순위가 모두 변경됩니다.

다음은 오버레이들과 심볼, 그리고 지도배경의 전역 겹침 우선순위의 기본값입니다.

| 유형                                                                                                                                                                       | 기본값     |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|
| 정보창 ([NInfoWindow](./info_window))                                                                                                                                       | 400000  |
| 위치 오버레이 ([NLocationOverlay](./location_overlay))                                                                                                                         | 300000  |
| 마커 ([NMarker](./marker))                                                                                                                                                 | 200000  |
| 화살표 경로 오버레이 ([NArrowheadPathOverlay](./path_overlay#narrowheadpathoverlay))                                                                                              | 100000  |
| 심볼                                                                                                                                                                       | 0       |
| 경로 오버레이<br/>([NPathOverlay](./path_overlay#npathoverlay), [NMultipartPathOverlay](./path_overlay#nmultipartpathoverlay))                                                 | -100000 |
| 도형 오버레이<br/>([NCircleOverlay](./shape_overlay#ncircleoverlay), [NPolygonOverlay](./shape_overlay#npolygonoverlay), [NPolylineOverlay](./shape_overlay#npolylineoverlay)) | -200000 |
| 지상 오버레이 ([NGroundOverlay](./ground_overlay))                                                                                                                             | -300000 |
| 지도 배경                                                                                                                                                                    | 최하단     |

다음 예시는 아래 조건을 토대로 전역 겹침 우선순위를 지정한 것입니다.

- NCircleOverlay -> 심볼 -> NMarker

```dart
circleOverlay.setGlobalZIndex(10000);
// 심볼의 전역 겹침 우선순위는 0입니다. (수정 불가)
marker.setGlobalZIndex(-10000);
```

#### 보조 우선순위 (ZIndex)

보조 우선순위는 전역 우선순위가 같은 경우에 사용됩니다.

앞서 설명한 전역 우선순위는 **오버레이의 종류에 따라** 지정할 수 있었지만, 보조 우선순위는 **오버레이의 인스턴스마다** 지정할 수 있습니다.

예를 들면, 마커의 전역 우선순위는 모두 같습니다. 그런데, A마커는 B마커보다 위에 그려지고 싶다면, A마커의 보조 우선순위를 더 높게 지정하면 됩니다.

```dart
markerA.setZIndex(100);
markerB.setZIndex(0);
```

보조 우선순위의 기본값은 오버레이의 종류와 관계없이 0이므로, 위 예시는 다음처럼 작성할 수도 있습니다.

```dart
markerA.setZIndex(100);
// B 마커는 기본값이 0이므로 생략 가능
```

### 지도에서 숨김

오버레이를 지도에서 숨길 수 있습니다. 숨겨지더라도, 오버레이는 지도에 남아있으며, 다시 보이게 할 수 있습니다.

```dart
marker.setIsVisible(false);
```

### 보여지는 줌 레벨의 범위 지정

줌 레벨에 따라 오버레이가 보이거나 숨겨지도록 할 수 있습니다.

12 ≤ 줌 레벨 < 18일 때만 마커가 보이도록 설정한 예시입니다.

```dart
marker
  .setMinZoom(12)
  .setMaxZoom(18)
  .setIsMinZoomInclusive(true)
  .setIsMaxZoomInclusive(false);
```

### 터치 이벤트

오버레이에 터치 이벤트를 지정할 수 있습니다.

```dart
marker.setOnTapListener((NMarker marker) {
  print("마커가 터치되었습니다. id: ${marker.info.id});
});
```

지정된 터치 이벤트를 직접 실행하려면, `overlay.performClick` 메서드를 사용하면 됩니다.

### 오버레이에 이미지 지정

오버레이에 icon 속성이 있다면, 이미지를 지정할 수 있습니다.

`NOverlayImage`를 사용하여 이미지 객체를 생성합니다.

`NOverlayImage`는 여러가지 생성자를 제공합니다.

- `NOverlayImage.fromAsset` : flutter 에셋을 이용해 만들 수 있습니다.
- `NOverlayImage.fromFile` : `File`을 이용해 만들 수 있습니다.
- `NOverlayImage.fromByteArray` : `Uint8List`를 이용해 만들 수 있습니다. (`Future<NOverlayImage>` 반환)
- `NOverlayImage.fromWidget` : `Widget`을 이용해 만들 수 있습니다. (`Future<NOverlayImage>` 반환)

다음은 `FlutterLogo` 위젯을 활용하여 새로 생성하는 마커의 아이콘을 지정하는 예시입니다.

```dart
final iconImage = await NOverlayImage.fromWidget(
      widget: const FlutterLogo(),
      size: const Size(24, 24),
      context: context);
                                
final marker = NMarker(id: "icon_test",
            position: latLng, icon: iconImage);
```
