---
slug: /start
---

# 시작하기

flutter_naver_map을 사용해주셔서 감사드립니다.

이 플러그인은 Flutter에서 [네이버 지도](https://www.ncloud.com/product/applicationService/maps)를 사용할 수 있도록 하기 위해 만들어졌습니다.

Android와 iOS 플랫폼을 지원하며, 호환 가능한 버전은 다음과 같습니다.

- Flutter : **Flutter 3.0 이상**, Dart 2.18.4 이상
- Android : API 23 (Android 6.0) 이상
- iOS : iOS 11 이상

---

본격적으로 시작하기 앞서, [Naver Cloud Platform Console](https://console.ncloud.com/naver-service/application) 에서, 앱을 Android / iOS
플랫폼 모두 등록해주세요.

:::danger
Android Platform에서는 Impeller Engine을 활용한 렌더링을 지원하지 않습니다. 이점 유의해주세요. (iOS는 정상 지원)
플러터의 Android 렌더링 엔진 기본값은 Skia Engine 이므로, 별도의 설정을 하지 않으셨다면 따로 설정하실 필요가 없습니다.
:::
