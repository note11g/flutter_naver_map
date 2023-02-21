# 초기 설정

## 1. 종속성 설정

먼저, pubspec.yaml에 다음처럼 종속성을 선언합니다.

```yaml
dependencies:
  flutter_naver_map: ^1.0.0
```

그리고, `pub get`을 실행합니다.

---

## 2. iOS 설정

iOS에서는, 대용량 파일을 받기 위해 [git-lfs](https://git-lfs.github.com/) 설치가 필요합니다.

터미널을 열고, 다음 커맨드를 실행해주세요.

`brew install git-lfs`

그리고, git-lfs 사용을 위해 다음의 커맨드를 실행해주세요.

`git lfs install`

---

## 3. Client Id 지정하기

flutter_naver_map에서는 두가지의 인증 방법을 지원합니다.

둘 중 하나의 방법을 택하여 Client Id를 지정해주세요.

- **지도 초기화 메서드 실행 시, client Id 지정** (권장됨)
    - 아래의 [초기화하기](#4-지도-초기화하기) 챕터에서 설명합니다.


- `AndroidManifest.xml`과 `Info.plist`에 client Id 지정
    - `AndroidManifest.xml`에 지정
        ```xml
        <manifest>
           <application>
               <meta-data
                   android:name="com.naver.maps.map.CLIENT_ID"
                   android:value="YOUR_CLIENT_ID" />
           </application>
        </manifest>
        ```
    - `info.plist`에 지정
        ```text
        <key>NMFClientId</key>
        <string>YOUR_CLIENT_ID</string>
        ```

---

## 4. 지도 초기화하기

지도 초기화 메서드를 **지도 위젯 사용 전에** 실행하여 초기화할 수 있습니다.

client Id를 지정하지 않는 경우에도, **꼭 초기화가 필요합니다**.

```dart
await NaverMapSdk.instance.initialize(clientId: "your client id");
```

초기화와 동시에 client Id를 지정하지 않는 경우에는, 다음과 같이 작성하면 됩니다.

```dart
await NaverMapSdk.instance.initialize();
```

초기화 메서드는 `main` 함수에서 실행하는 것을 권장하지만, 지도 실행 전이라면 언제 실행해도 상관없습니다.

다음은 main 함수에서 지도를 초기화하는 예제입니다.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'your client id');
  runApp(MyApp());
}
```

### 인증 실패 처리

초기화 메서드에서 인증 실패 결과를 받아볼 수도 있습니다.

```dart
await NaverMapSdk.instance.initialize(
      clientId: 'your client id',
      onAuthFailed: (ex) {
        print("********* 네이버맵 인증오류 : $ex *********");
      });
```

인증 실패에 따른 Exception code는 다음과 같습니다.

| 코드  | 설명                                                                     |
|-----|------------------------------------------------------------------------|
| 401 | - 잘못된 클라이언트 ID 지정<br/> - 잘못된 클라이언트 유형을 사용<br/> - 콘솔에 등록된 앱 패키지 이름과 미일치 |
| 429 | - 콘솔에서 Maps 서비스를 선택하지 않음<br/> - 사용 한도 초과                               |
| 800 | - 클라이언트 ID 미지정                                                         |
