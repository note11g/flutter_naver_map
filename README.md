# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)

<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/72307493-2498-4e29-b6a4-232e0db8a05b"/></a>


<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/f3c9c433-0a45-4d35-95b6-3baf753878e0"/></a><a href="https://github.com/note11g/flutter_naver_map/issues" alt="go to github issue page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/89efa17d-bf96-413d-b910-0f38e9c36c3f"/></a><a href="https://github.com/users/note11g/projects/2/views/2" alt="go to issue tracker page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/4bb00306-85e6-4e4d-9329-6129d6f344f6"/></a>

## Version Up Guide

`1.2.0`부터는 Flutter SDK 최소 지원 버전이 `3.19`로 변경되었습니다. 

- `1.1.0 이하` -> `1.1.1 이상`으로 업그레이드 할 경우, 해당 코드를 다음과 같이 지워주세요.<br>(편의상 주석처리로 표시해두었지만, 그냥 지워주세요)
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
  - 해당 이슈에 대해 레포트를 받고 있습니다. 테스트 결과를 [이슈 페이지](https://github.com/note11g/flutter_naver_map/issues/133)에 코멘트로 남겨주시면 감사하겠습니다.

이슈 제보는 언제나 환영입니다:)

## Contribution Guide

곧 추가할 예정입니다.