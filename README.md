# flutter_naver_map

[![pub package](https://img.shields.io/pub/v/flutter_naver_map.svg?color=4285F4)](https://pub.dev/packages/flutter_naver_map)

**[네이버 지도](https://www.ncloud.com/product/applicationService/maps)** 를 플러터에서 띄울 수 있는 플러그인입니다. 

Plug-in which shows naver map on flutter project support Android and iOS.

해당 플러그인은 원작자인 **[LBSTECH](https://www.lbstech.net/)** 의 허가하에,
**[해당 라이브러리](https://github.com/LBSTECH/naver_map_plugin)** 를 기반으로
여러 부분을 보완한 라이브러리입니다.

---

## 1.0.0 Dev Preview

새롭게 바뀐 1.0.0을 미리 사용해보실 수 있습니다. [바로가기](https://github.com/note11g/flutter_naver_map/tree/dev_preview)

---

## 시작하기 (공통)

해당 플러그인은 **[Naver Cloud PlatForm - Map](https://guide.ncloud-docs.com/docs/naveropenapiv3-maps-overview#mobile-dynamic-map-android-ios-sdk-30)** 에서 제공하는 Map SDK 서비스를 Android와 iOS 환경에서 보여주는 플러그인입니다. 

`pubspec.yaml`에서 dependencies에 작성

``` yaml
dependencies:
  flutter_naver_map: [최신버전]
```

---

## 시작하기(Android)

### 1. 권한 선언 및 Client ID 설정

`[프로젝트 폴더]/android/app/src/AndroidManifest.xml`에

다음과 같이 **권한을 선언하고** *(선택사항)* 과, **네이버 맵 SDK의 Client ID**를 넣습니다.

_권한 선언은 네이버 맵에서 현 위치 탐색 기능을 사용할 때만, 해당 권한 2개를 선언합니다._
``` xml
<manifest>
    <!-- 네이버 맵에서 현 위치 탐색 기능을 사용할 때만, 해당 권한 2개를 선언합니다 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

    <application>
        <activity> <!-- something --> </activity>
        
        <!-- 플러터 자동 생성. 지우시면 안 됩니다. -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2"/>
                
        <!-- 네이버 맵 SDK의 Client ID를 넣는 곳입니다. 필수로 넣어야, 지도가 동작합니다. -->        
        <meta-data
            android:name="com.naver.maps.map.CLIENT_ID"
            android:value="여기에 Map Sdk의 Client ID를 넣습니다" />
    </application>
</manifest>
```
  
### 2. 참고사항 (Android)
네이버 Map SDK의 경우 안드로이드에서 지도를 표시하기 위해 기본값으로 GLSurfaceView를 사용합니다.
하지만, flutter에서 Hot Reload 기능을 사용할 경우, 네이버 Map SDK의 binary에서 정확하지 않은 이유로 Crash가 발생합니다.

따라서, 기본 옵션은 TextureView를 사용하도록 되어있습니다.
성능이 좋은 GLSurfaceView를 사용하려면, **아래 예제**처럼 Hot Reload 기능을 사용하지 않는 Release 버전에서만 사용하도록 하시는 것을 권장드립니다.
```
NaverMap(
    useSurface: kReleaseMode, //해당 옵션은 Android에서만 적용됩니다.
    /* many other options */
)
```

단, TextField 위젯을 지도 위에서 사용하지 않는 경우에만 사용하시길 바랍니다.

> [GLSurfaceView]를 사용하여 지도가 렌더링 되는 동안, [TextField]에 포커스가
이동하면 app crash가 발생한다. Flutter Engine에서 [TextField]의 변화를 업데이트할 때,
[GLThread]를 사용하는데, 이 과정에서 [DeadObjectException]이 발생한다.


---

## 시작하기(iOS)

### 1. 라이브러리 의존성을 위한 설정
대용량 파일을 받기 위해 [git-lfs](https://git-lfs.github.com/) 설치가 필요합니다.
터미널을 열고, 다음 커맨드를 실행해주세요.

`$ brew install git-lfs`

그리고 git-lfs을 사용하기 위해 다음의 커맨드를 실행해주세요.

lfs 사용 설정이 안될 경우 Pod를 통한 dependency가 다운로드 되지않습니다.

`$ git lfs install`

### 2. 권한 선언 및 Client ID 설정
`[프로젝트 폴더]/ios/Runner/Info.plist`에

다음과 같이 **네이버 맵 SDK의 Client ID**를 넣습니다.

``` 
<dict>
    <key>NMFClientId</key>
    <string>여기에 Map Sdk의 Client ID를 넣습니다</string>
</dict>
```

권한 선언은 네이버 맵에서 **현 위치 탐색 기능을 사용할 때만** 선언하시면 됩니다.
``` 
<dict>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>여기에 위치 사용 목적을 적으시면 됩니다.</string>
</dict>
```

---

## Warning
- android에서 네이버 로고 버튼을 누를 시, App이 Crash되는 현상(AppCompat 때문)으로 해당 버튼을 비활성화 하였음. 

## 맺음말
이슈와 PR은 언제든 환영입니다!!
