# flutter_naver_map 1.0 Dev Preview

현재 이슈가 없는 모든 기능을 이용하실 수 있습니다.

플러터 3.0 이상, dart 2.18.4 이상을 사용하셔야 합니다.
android는 5.1 이상, iOS는 11.0 이상을 지원합니다.

## 간단 시작 가이드

Naver Cloud Platform 에서 앱을 등록하고, Android / iOS 플랫폼을 등록합니다.

그리고, pubspec.yaml에 다음처럼 종속성을 선언합니다.

```yaml
  flutter_naver_map:
    git:
      url: https://github.com/note11g/flutter_naver_map.git
      ref: dev_preview
```

사용하기 전, `NaverMapSdk.instance.initialize()` 를 호출하여 초기화를 해주셔야 합니다. (필수)
clientId는 필수가 아니며, 기존처럼 clientId를 AndroidManifest.xml이나, Info.plist에 넣어주셔도 됩니다.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'your client id');
  runApp(MyApp());
}
```

지도 위젯은 다음처럼 사용하실 수 있습니다.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: NaverMap(
      options: const NaverMapViewOptions(),
      onMapReady: (controller) {},
      onMapTapped: (point, latLng) {},
      onSymbolTapped: (symbol) {},
      onCameraChange: (reason, animated) {},
      onCameraIdle: () {},
      onSelectedIndoorChanged: (selectedIndoor) {},
    ),
  );
}
```

## 참고사항

이전 버전 (0.10)과 하위 호환성이 보장되지 않습니다.

완전히 새로 작성된 라이브러리이기 때문입니다. 이슈도 공유하지 않습니다.

1.0.0이 Stable으로 업데이트 되면, 구버전(0.x)의 지원이 중단될 예정입니다. 참고 바랍니다.

## 이슈

이슈탭에서 Label = 1.0을 이용해서 이슈를 확인 / 등록 하실 수 있습니다. [바로가기](https://github.com/note11g/flutter_naver_map/labels/1.0)

### TODO

- [ ] 통합 테스트 작성
- [ ] 단위테스트 작성
- [ ] 예제 작성
- [ ] API DOCS 작성
- [ ] 클러스터링 구현 (추가 패키지로 제공될 예정입니다)
