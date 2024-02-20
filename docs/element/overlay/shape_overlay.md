# 도형 오버레이

## NCircleOverlay

원을 그리는 오버레이입니다.

```dart
NCircleOverlay(id: "test", center: target);
```

## NPolygonOverlay

다각형을 그리는 오버레이입니다.

```dart
NPolygonOverlay(
    id: "test", 
    coords: [...testTargets, target], // 처음과 마지막 좌표는 같아야 합니다. 
    // holes: [] // 안쪽에 홀을 뚫을 수 있습니다. 
);
```

## NPolylineOverlay

선을 그리는 오버레이입니다.

```dart
NPolylineOverlay(id: "test", coords: testTargets);
```
