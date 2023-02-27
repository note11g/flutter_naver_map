# 사용하기

지도 위젯은 다음처럼 사용하실 수 있습니다.

:::danger
만약, flutter_naver_map 이전 버전을 사용하셨었다면, 반드시 [iOS에서 네이버맵 최신버전 유지](#ios에서-네이버맵-최신버전-유지) 섹션을 수행하세요!!
:::

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: NaverMap(
      options: const NaverMapViewOptions(),
      onMapReady: (controller) {
        print("네이버 맵 로딩됨!");
      },
    ),
  );
}
```

---

### iOS에서 네이버맵 최신버전 유지

:::danger
**만약, flutter_naver_map 이전 버전을 사용하셨었다면, 꼭!! 따라해주세요!**
(0.x대 버전 사용자 or 1.0 dev preview 사용자)

**이전 버전의 Naver Map iOS SDK와 충돌할 가능성이 있습니다.**
:::



따라서, 다음 단계를 따라해주세요.

1. iOS 기기에서 한번 실행을 해주세요.
2. 빌드가 완료되고, 실행이 되면 정지해주세요. (pod에 최신버전의 flutter_naver_map이 추가됩니다.)
3. 다음 명령어를 실행해주세요.

```bash
cd ios # ios 폴더로 이동
pod update NMapsMap
```

이 명령어를 실행하면, Naver Map iOS SDK가 flutter_naver_map에서 정의한 버전으로 자동으로 업데이트 됩니다.


---

축하합니다! 초기설정을 끝마쳤습니다.
