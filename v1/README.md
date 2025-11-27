# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![latest release](https://img.shields.io/github/v/release/note11g/flutter_naver_map?include_prereleases&label=latest&color=green)](https://github.com/note11g/flutter_naver_map/releases)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)


> **[중요 마이그레이션 안내]**
>
> 1.3.1부터 Naver Cloud Platform의 지도 서비스가 일부 변경됨에 따라, 신규 인증 API가 추가되었습니다.
>
> 기존 인증 방식(API)으로 제공되는 서비스는 25년 7월 1일부터 무료 이용량 제공이 중단될 예정이니
>
> 이점 참고하시어, 빠르게 마이그레이션 하시길 권장드립니다.
>
> [신규 서비스 인증 관련 상세 내용 보기 >](https://github.com/note11g/flutter_naver_map/issues/311)


## Getting Started

### 0. 네이버 클라우드 플랫폼 콘솔에서 사용 신청

<details>
<summary>Mobile Dynamic Map 서비스 사용 신청 방법 자세히 보기</summary>

#### 1. Console에서 [Services > Application Services > Maps](https://console.ncloud.com/maps/application) 으로 이동
![](https://cdn.jsdelivr.net/gh/note11g/flutter_naver_map@main/docs_asset/start_0_1.png)

#### 2. Application 등록하기
Application 등록 > Application 이름 입력 > API 선택에서 “Dynamic Map” 선택 > 서비스 환경 등록 - Android 앱 패키지 이름, iOS Bundle ID 입력 > 등록
![](https://cdn.jsdelivr.net/gh/note11g/flutter_naver_map@main/docs_asset/start_0_2.png)

#### 3. 등록한 Application의 “인증정보”에서 “Client ID”를 확인
![](https://cdn.jsdelivr.net/gh/note11g/flutter_naver_map@main/docs_asset/start_0_3.png)

</details>

### 1. 버전 호환성 확인

flutter_naver_map은 Android 6.0(SDK 23), iOS 12.0부터 지원합니다.

이 라이브러리를 사용하기 위해서는, Minimum SDK 버전을 해당 버전으로 올려주세요.

### 2. 초기화 함수 실행

네이버 클라우드 플랫폼 콘솔에서 가져온 Client ID를 사용합니다. (Client ID 확인 방법은 [0-3 섹션](#0-네이버-클라우드-플랫폼-콘솔에서-사용-신청) 참고)

```dart
// 꼭 main 함수에서 실행할 필요는 없으나, 
// 최초로 NaverMap 위젯이 실행되기 이전에 초기화가 꼭 필요합니다.
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // runApp 실행 이전이면 필요

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


## Version Up Guide

- **`1.2.3` 이상 버전으로 업데이트하시면, 다음 과정을 한번 수행해주셔야 합니다.**

  (`1.3.0` -> `1.3.1`, `1.3.1` -> `1.4.0`, `1.4.0` -> `1.4.1` 포함)

    ```shell
    cd ios # 프로젝트의 ios 폴더로 이동
    pod update NMapsMap
  
    cd .. # 프로젝트 루트로 이동 (optional)
  
    cd android # 프로젝트의 android 폴더로 이동
    ./gradlew clean
    ./gradlew --refresh-dependencies
    ```

  이 명령어를 프로젝트 루트에서 실행하면, 한번에 수행하실 수 있습니다.
    <details>
    <summary>MacOS</summary>

    ```shell
    (cd ios && pod update NMapsMap) && (cd android && ./gradlew clean && ./gradlew --refresh-dependencies)
    ```
    </details>
    <details>
    <summary>Windows</summary> 
    
    ```shell
    cd android && gradlew.bat clean && gradlew.bat --refresh-dependencies
    ```
    </details>
