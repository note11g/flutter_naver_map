# flutter_naver_map

## 1.3.0 Beta Release

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=00B352&include_prereleases)](https://pub.dev/packages/flutter_naver_map/versions/1.3.0-beta.3)

해당 릴리즈는 `1.3.0`의 베타 버전입니다.

9월 중으로 테스트를 진행하며, 정식버전은 마지막주~10월 초에 배포할 예정입니다.

주요 기능은 [변경 사항 노트](https://github.com/note11g/flutter_naver_map/blob/dev/1.3.0/CHANGELOG.md#130-beta1)를 참고하세요.

---

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)

<a href="https://pub.dev/documentation/flutter_naver_map/1.3.0-beta.3/" alt="go to documentation page"><img width="676" src="https://raw.githubusercontent.com/note11g/flutter_naver_map/dev/1.3.0/readme_summary.webp"/></a>


<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/f3c9c433-0a45-4d35-95b6-3baf753878e0"/></a><a href="https://github.com/note11g/flutter_naver_map/issues" alt="go to github issue page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/89efa17d-bf96-413d-b910-0f38e9c36c3f"/></a><a href="https://github.com/users/note11g/projects/2/views/2" alt="go to issue tracker page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/4bb00306-85e6-4e4d-9329-6129d6f344f6"/></a>

## API Reference

현재는 문서보다, API Reference가 권장됩니다. 문서는 out-dated된 내용이 있으니, 참고하세요.

[API Reference 바로가기](https://pub.dev/documentation/flutter_naver_map/latest/)


## Version Up Guide

- **`1.2.3` 이상 버전으로 업데이트 하시려면, 다음 과정을 한번 수행해주셔야 합니다.**

  (`1.2.3` -> `1.3.0` 포함)

    ```shell
    cd ios # 프로젝트의 ios 폴더로 이동
    pod update NMapsMap
  
    cd .. # 프로젝트 루트로 이동 (optional)
  
    cd android # 프로젝트의 android 폴더로 이동
    ./gradlew clean
    ./gradlew --refresh-dependencies
    ```
  
    이 명령어를 프로젝트 루트에서 실행하면, 한번에 수행하실 수 있습니다.
    Mac
    ```shell
    (cd ios && pod update NMapsMap) && (cd android && ./gradlew clean && ./gradlew --refresh-dependencies)
    ```
    Windows
    ```shell
    cd android && gradlew.bat clean && gradlew.bat --refresh-dependencies
    ``` 


- `1.2.3`부터는 Flutter SDK 최소 지원 버전이 `3.22.0`으로 변경되었습니다.

- `1.3.0`부터는 iOS SDK 최소 지원 버전이 `12.0`으로 변경되었습니다.
  
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

~~- Android Impeller Engine 지원 안함 (Android 기본 값은 Skia) [#133](https://github.com/note11g/flutter_naver_map/issues/133)~~
  ~~- 해당 이슈에 대해 레포트를 받고 있습니다. 테스트 결과를 [이슈 페이지](https://github.com/note11g/flutter_naver_map/issues/133)에 코멘트로 남겨주시면 감사하겠습니다.~~
  - 해당 이슈에 대한 확인 중입니다. 정식 지원은 아니지만, 사용 가능한 것으로 확인되었습니다. 이슈가 있으신 분들은 [#133](https://github.com/note11g/flutter_naver_map/issues/133)으로 레포트 부탁드립니다.

이슈 제보는 언제나 환영입니다:)

## Contribution Guide

곧 추가할 예정입니다.