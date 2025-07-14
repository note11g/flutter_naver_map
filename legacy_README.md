# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)
[![github](https://img.shields.io/github/stars/note11g/flutter_naver_map)](https://github.com/note11g/flutter_naver_map)

<a href="https://pub.dev/documentation/flutter_naver_map/" alt="go to documentation page"><img width="676" src="https://raw.githubusercontent.com/note11g/flutter_naver_map/main/readme_summary.webp"/></a>


<a href="https://note11.dev/flutter_naver_map" alt="go to documentation page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/f3c9c433-0a45-4d35-95b6-3baf753878e0"/></a><a href="https://github.com/note11g/flutter_naver_map/issues" alt="go to github issue page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/89efa17d-bf96-413d-b910-0f38e9c36c3f"/></a><a href="https://github.com/users/note11g/projects/2/views/2" alt="go to issue tracker page"><img src="https://github.com/note11g/flutter_naver_map/assets/67783062/4bb00306-85e6-4e4d-9329-6129d6f344f6"/></a>

## API Reference

현재는 문서보다, API Reference가 권장됩니다. 문서는 out-dated된 내용이 있으니, 참고하세요.

[API Reference 바로가기](https://pub.dev/documentation/flutter_naver_map/latest/)


## 1.3.1 변경사항

Naver Cloud Platform 신규 서비스 인증 지원 및 버그 수정이 이루어졌습니다.

신규 서비스 인증의 경우, 기존 레거시 인증 방식인 `NaverMapSdk.instance.initialize` 메서드가 곧 사용 중단되므로, 미리 대응 하시기 바랍니다.
신규 인증 API는 [API Reference](https://pub.dev/documentation/flutter_naver_map/latest/flutter_naver_map/FlutterNaverMap/init.html)를 참고하세요.

1.3.1 버전의 더 자세한 변경 사항은 [변경 사항 노트](https://github.com/note11g/flutter_naver_map/blob/main/CHANGELOG.md#131)를 참고하세요.


## Version Up Guide

- **`1.2.3` 이상 버전으로 업데이트 하시려면, 다음 과정을 한번 수행해주셔야 합니다.**

  (`1.3.0` -> `1.3.1` 포함)

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

## Contribution Guide

곧 추가할 예정입니다.
