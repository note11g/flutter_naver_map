# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)

<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/82e86cd1-7011-490d-bdc1-c6ef6312e83f"/></a>


<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/f3c9c433-0a45-4d35-95b6-3baf753878e0"/></a><a href="https://github.com/note11g/flutter_naver_map/issues" alt="go to github issue page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/89efa17d-bf96-413d-b910-0f38e9c36c3f"/></a><a href="https://github.com/users/note11g/projects/2/views/2" alt="go to issue tracker page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/4bb00306-85e6-4e4d-9329-6129d6f344f6"/></a>

## Version Up Guide
`1.1.1` 이상으로 업그레이드 할 경우, 해당 코드를 다음과 같이 지워주세요.<br>(편의상 주석처리로 표시해두었지만, 그냥 지워주세요)

[관련 이슈](https://github.com/note11g/flutter_naver_map/issues/56)가 해결되어, 더 이상 필요하지 않습니다.

```kotlin 
// android/app/main/.../MainActivity.kt
class MainActivity : FlutterActivity() // {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        intent.putExtra("background_mode", "transparent")
//        super.onCreate(savedInstanceState)
//    }
// }
```

## Known issues

- Android Impeller Engine 지원 안함 (Android 기본 값은 Skia) [#133](https://github.com/note11g/flutter_naver_map/issues/133)

이슈 제보는 언제나 환영입니다:)

## Contribution Guide

곧 추가할 예정입니다.