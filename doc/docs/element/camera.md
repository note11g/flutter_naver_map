# 카메라

지도 영역이 어떻게 보일지 컨트롤할 수 있습니다.

다음 두 객체를 이용해, 카메라를 컨트롤 할 수 있습니다.

- [NCameraPosition](#ncameraposition) : 카메라의 위치를 나타내는 객체입니다.
- [NCameraUpdate](#ncameraupdate) : 변경할 카메라의 위치를 나타내는 객체입니다.

---

## NCameraPosition

카메라의 위치를 나타내는 객체입니다.

`NCameraPosition`은 다음과 같은 속성을 지닙니다.

- `target` : 카메라의 중심 좌표입니다.
- `zoom` : 카메라의 줌 레벨입니다. (0 ~ 21)
- `bearing` : 카메라의 방향입니다. (0도는 북쪽을 가리킵니다.)
- `tilt` : 카메라의 기울기입니다. (0도 ~ 63도)

다음은 서울특별시청을 중심으로 하고, 줌 레벨은 15, 방향은 45도, 기울기는 30도인 카메라를 나타내는 `NCameraPosition`입니다.

```dart
final cameraPosition = NCameraPosition(
  target: NLatLng(37.5666102, 126.9783881),
  zoom: 15,
  bearing: 45,
  tilt: 30,
)
```

---

### NCameraPosition을 활용하는 메서드

#### 1. `NaverMapViewOptions` 객체의 `initialCameraPosition` 속성

`NaverMapViewOptions`의 `initialCameraPosition` 에 `NCameraPosition` 객체를 넣어 초기 카메라 위치를 설정할 수 있습니다.

다음은 위에서 만든 `cameraPosition`을 초기 카메라 위치로 설정한 예제입니다.

```dart
NaverMap(
  options: NaverMapViewOptions(
    initialCameraPosition: cameraPosition,
  ),
)
```

#### 2. `NaverMapController` 객체의 `getCameraPosition` 메서드

`NaverMapController`의 `getCameraPosition` 메서드를 이용해 현재 카메라의 위치를 가져올 수 있습니다.

다음은 현재 카메라의 위치를 가져오는 예제입니다.

```dart
final cameraPosition = await _controller.getCameraPosition();
```

---

## NCameraUpdate

카메라의 위치를 변경할 때 사용하는 객체입니다.

오직 `NaverMapController`의 `updateCamera`에서만 사용합니다.

### 생성자

`NCameraUpdate`는 다양한 생성자가 있습니다.

상황에 따라, 잘 맞춰 사용하시면 됩니다.

공통적으로 `xxx` 속성은 해당 값으로 바로 적용하지만, `xxxBy` 메서드는 현재 카메라의 위치의 상대적인 값으로 적용합니다.

줌 레벨을 예시로 들면, (이때, 현재 줌 레벨은 15라고 가정합니다.)

- `zoom : 3` : 변경시 3
- `zoomBy : 3` : 변경시 18 (15 + 3)

#### 1. NCameraUpdate.withParams

`target`, `zoom`, `bearing`, `tilt`를 모두 선택적으로 설정할 수 있는 생성자입니다.

이중, `zoom`, `bearing`, `tilt`는 `xxxBy` 속성을 이용해 상대적인 값으로 설정할 수 있습니다.

:::tip
단, 같은 속성에 대해서 `xxx` 속성과 `xxxBy` 속성을 같이 사용하면 안됩니다. (둘 다 사용하면, assertion 오류를 발생시킵니다.)

**올바르지 못한 예시** (오류 발생)

```dart
NCameraUpdate.withParams(
    zoom: 20,
    zoomBy: 3,
)
```

**올바른 예시 1** (둘 중 하나만 지정)

```dart
NCameraUpdate.withParams(
    zoom: 20,
)
```

**올바른 예시 2** (둘 중 하나만 지정, 다른 속성과 함께 사용)

```dart
NCameraUpdate.withParams(
    zoomBy: 3,
    tilt: 30,
)
```

:::

이 예제는 다음 조건을 만족하는 `NCameraUpdate`를 생성합니다.

- `target` : 서울특별시청 (37.5666102, 126.9783881)
- `zoom` : 현재 줌 레벨 - 2
- `bearing` : 남쪽 (180도)

```dart
final cameraUpdate = NCameraUpdate.withParams(
  target: NLatLng(37.5666102, 126.9783881),
  zoomBy: -2,
  bearing: 180,
)
```

#### 2. NCameraUpdate.scrollAndZoomTo

`target`과 `zoom`을 설정할 수 있는 생성자입니다.

단순히 **특정 좌표로의 이동**이나 **줌 레벨을 절대값으로 설정** 할 때 사용하는 것을 권장합니다.

- 줌 레벨을 18로 설정
    ```dart
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      zoom: 18,
    )
    ```

- 서울특별시청을 중심으로 설정
    ```dart
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: NLatLng(37.5666102, 126.9783881),
    )
    ```

- 서울특별시청을 중심으로 하고, 줌 레벨은 18로 설정
    ```dart
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: NLatLng(37.5666102, 126.9783881),
      zoom: 18,
    )
    ```

#### 3. NCameraUpdate.zoomIn / zoomOut / zoomBy

- `NCameraUpdate.zoomIn` : 줌 레벨을 1 증가시킵니다.
- `NCameraUpdate.zoomOut` : 줌 레벨을 1 감소시킵니다.
- `NCameraUpdate.zoomBy` : 줌 레벨을 상대적으로 설정합니다.

`zoomIn`은 `zoomBy(1)`과 같고, `zoomOut`은 `zoomBy(-1)`과 같습니다.

```dart
final cameraUpdate1 = NCameraUpdate.zoomBy(3); // 줌 레벨을 3만큼 증가시킵니다.
final cameraUpdate2 = NCameraUpdate.zoomBy(-3); // 줌 레벨을 3만큼 감소시킵니다.

final cameraUpdate3 = NCameraUpdate.zoomIn(); // 줌 레벨을 1만큼 증가시킵니다.
final cameraUpdate4 = NCameraUpdate.zoomOut(); // 줌 레벨을 1만큼 감소시킵니다.
```

#### 4. NCameraUpdate.fromCameraPosition

`NCameraPosition` 객체를 이용해 `NCameraUpdate` 객체를 생성합니다.

```dart
final cameraPosition = NCameraPosition(target: NLatLng(37.5666102, 126.9783881));
final cameraUpdate = NCameraUpdate.fromCameraPosition(cameraPosition);
```

#### 5. NCameraUpdate.fitBounds

`NLatLngBounds`에 해당하는 영역을 온전하게 보여주는 `NCameraUpdate` 객체를 생성합니다.

이때, `tilt`와 `bearing`은 0으로 설정됩니다.

`padding` 속성을 통해, 영역과 화면 경계 사이의 여백을 설정할 수도 있습니다.

다음은 신분당선의 강남-정자 구간을 모두 포함하는 영역을 온전하게 보여주는 `NCameraUpdate` 객체를 생성하는 예제입니다.

```dart
const bounds = NLatLngBounds.from([
  NLatLng(37.497175, 127.027926), // 강남
  NLatLng(37.484147, 127.034631), // 양재
  NLatLng(37.470023, 127.038573), // 양재 시민의 숲
  NLatLng(37.447211, 127.055664), // 청계산 입구
  NLatLng(37.394761, 127.111217), // 판교
  NLatLng(37.367381, 127.108847), // 정자
]);

final cameraUpdate = NCameraUpdate.fitBounds(bounds);
final cameraUpdateWithPadding =
      NCameraUpdate.fitBounds(bounds, padding: EdgeInsets.all(50));
```

---

### 피봇

기본적으로는 카메라가 움직일 때, 기준점은 화면 중앙입니다.

예를 들어, `NCameraUpdate`의 `target`을 서울특별시청으로 지정하였다면, 카메라는 서울특별시청을 화면의 중앙에 위치하도록 이동합니다.
하지만, `pivot`을 설정한다면, **카메라는 피봇을 기준으로 이동합니다.**

이처럼, 피봇은 카메라의 이동 기준점을 의미합니다.

피봇은 `NCameraUpdate` 객체를 생성한 후, `setPivot` 메서드를 이용하여 피봇 지점을 설정할 수 있습니다.

화면 좌측 상단의 좌표를 `NPoint(0, 0)`, 오른쪽 하단의 좌표를 `NPoint(1, 1)`이 기준입니다.

화면 중앙은 `NPoint(0.5, 0.5)`입니다.

:::tip
피봇은 `fitBounds`로 생성한 `NCameraUpdate` 객체에는 적용되지 않습니다.
:::

다음은 가로 1/3, 세로 2/3 지점을 피봇으로 설정하는 예제입니다.

```dart
final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
  target: NLatLng(37.5666102, 126.9783881),
  zoom: 18,
);

cameraUpdate.setPivot(NPoint(1 / 3, 2 / 3));

// 혹은 다음 문법으로도 가능합니다.

final cameraUpdate2 = NCameraUpdate.scrollAndZoomTo(
    target: NLatLng(37.5666102, 126.9783881),
  )..setPivot(NPoint(1 / 3, 2 / 3));
```

---

### 애니메이션

`NCameraUpdate` 객체를 이용해 카메라를 이동시킬 때, 애니메이션을 설정할 수 있습니다.

애니메이션은 `NCameraUpdate` 객체를 생성한 후, `setAnimation` 메서드를 이용하여 설정할 수 있습니다.

애니메이션 유형과, 애니메이션의 지속 시간을 설정할 수 있습니다.

애니메이션 유형은 다음 4가지가 존재합니다.

- `NCameraAnimation.easing` : 부드럽게 가감속하며 이동합니다. (근거리 이동에 적합)
- `NCameraAnimation.fly` : 부드럽게 축소되었다 확대되며 이동하는 애니메이션입니다. (원거리 이동에 적합)
- `NCameraAnimation.linear` : 일정한 속도로 이동하는 애니메이션입니다.
- `NCameraAnimation.none` : 애니메이션 없이 이동합니다.

에니메이션 유형의 기본값은 `easing`이며, 지속 시간의 기본값은 0.8초입니다.

다음은 `NCameraAnimation.fly` 유형의 애니메이션을 2초 동안 실행하도록 설정하는 예제입니다.

```dart
final cameraUpdate = NCameraUpdate.scrollAndZoomTo(target: NLatLng(37.5666102, 126.9783881));

cameraUpdate.setAnimation(NCameraAnimation.fly, duration: Duration(seconds: 2));
```
