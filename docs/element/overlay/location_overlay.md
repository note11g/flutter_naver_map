# 위치 오버레이

현 위치를 나타내는 오버레이입니다.

직접 생성할 수 없으며, 컨트롤러를 통해서 가져올 수 있습니다.

```dart
final locationOverlay = await mapController.getLocationOverlay();
```

위치를 바꾸거나, 아이콘/색상을 바꾸는 등의 커스텀을 할 수 있습니다.