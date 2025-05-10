# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)

## Getting Started

###  1. 네이버 클라우드 플랫폼 콘솔에서 사용 신청

![네이버 클라우드 플랫폼 콘솔 사용 신청 방법](/docs_asset/start_1.png)

### 2. 초기화 함수 실행

1-3에서 가져온 Client ID를 사용합니다.

```dart
// 꼭 main 함수에서 실행할 필요는 없으나, 
// 최초로 NaverMap 위젯이 실행되기 이전에 초기화가 꼭 필요합니다.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 실행할 때만 필요

  await FlutterNaverMap().init(
      clientId: '방금 발급받은 Client ID',
      onAuthFailed: (ex) {
        switch (ex) {
          case NQuotaExceededException(:final message):
            print("사용량 초과 (message: $message)");
            break;
          case NUnauthorizedClientException() ||
                NClientUnspecifiedException() ||
                NAnotherAuthFailedException():
            print("인증 실패: $ex");
            break;
        }
      });

  runApp(const MyApp());
}
```

### 3. `NaverMap` 위젯 사용

다음은 전체 화면으로 NaverMap 위젯을 띄우는 예제입니다.

- 첫 화면은 서울시청 (37.5666, 126.979), 줌 레벨 14 으로 보여집니다.

- 서울시청에 마커를 표시합니다.

```dart
@override
Widget build(BuildContext context) {
    const seoulCityHall = NLatLng(37.5666, 126.979);
    final safeAreaPadding = MediaQuery.paddingOf(context); 
    return Scaffold(
        body: NaverMap(
            options: NaverMapViewOptions(
                contentPadding: safeAreaPadding, // 화면의 SafeArea에 중요 지도 요소가 들어가지 않도록 설정하는 Padding. 필요한 경우에만 사용하세요.
                initialCameraPosition: NCameraPosition(target: seoulCityHall, zoom: 14),
            ), 
            onMapReady: (controller) {
                final marker = NMarker(
                    id: "city_hall", // Required
                    position: seoulCityHall, // Required
                    caption: NOverlayCaption(text: "서울시청"), // Optional
                );
                controller.addOverlay(marker); // 지도에 마커를 추가
                print("naver map is ready!");
            },
        ),
    );
}
```