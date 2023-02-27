# 좌표

위도와 경도를 통해 위치 혹은 범위를 나타낼 수 있습니다

## NLatLng (위도, 경도)

이 객체는 위도와 경로를 이용하여 위치를 나타냅니다.
다음은 위도가 37.5666, 경도가 126.979인 서울특별시청의 위치를 나타내는 NLatLng을 생성하는 예제입니다.

```dart
const latLng = NLatLng(37.5666, 126.979);
```

## NLatLngBounds (범위)

이 객체는 남서쪽의 좌표와 북동쪽의 좌표를 이용하여 직사각형의 범위를 나타냅니다. (Minimum Bounding Rectangle)

다음은 서울특별시의 범위를 나타내는 NLatLngBounds를 생성하는 예제입니다.

```dart
const bounds = NLatLngBounds(
  southWest: NLatLng(37.413294, 126.764166),
  northEast: NLatLng(37.701749, 127.181111),
);
```

혹은 다음과 같이 NLatLng의 리스트를 이용하여 생성할 수도 있습니다.

그러면, 리스트의 모든 NLatLng의 위치를 포함하는 최소한의 직사각형 범위를 생성합니다.

다음은 신분당선의 강남-정자 구간의 범위를 나타내는 NLatLngBounds를 생성하는 예제입니다.

```dart
const bounds = NLatLngBounds.from([
  NLatLng(37.497175, 127.027926), // 강남
  NLatLng(37.484147, 127.034631), // 양재
  NLatLng(37.470023, 127.038573), // 양재 시민의 숲
  NLatLng(37.447211, 127.055664), // 청계산 입구
  NLatLng(37.394761, 127.111217), // 판교
  NLatLng(37.367381, 127.108847), // 정자
]);
```

--- 

## NLatLng 메서드

### offsetByMeter

`NLatLng offsetByMeter(double northMeter, double eastMeter)`

이 객체를 기준으로 northMeter만큼 북쪽으로, eastMeter만큼 동쪽으로 이동한 좌표를 반환합니다. (단위 : 미터)

다음은 서울특별시청의 위치를 기준으로 200m 남쪽, 100m 동쪽으로 이동한 위치를 나타내는 NLatLng을 생성하는 예제입니다.

```dart
const latLng = NLatLng(37.5666, 126.979);
const offsetLatLng = latLng.offsetByMeter(northMeter: -200, eastMeter: 100);
```

### distanceTo

`double distanceTo(NLatLng other)`

이 객체와 다른 객체 사이의 거리를 미터(M) 단위로 반환합니다.

다음은 서울특별시청의 위치와 서울역의 위치 사이의 거리를 구하는 예제입니다.

```dart
const latLng = NLatLng(37.5666, 126.979);
const seoulStationLatLng = NLatLng(37.555759, 126.972939);
final distance = latLng.distanceTo(seoulStationLatLng);
```

### isWithinCoverage

`bool isWithinCoverage()`

이 객체가 세계 지도의 범위 안에 있는지 여부를 반환합니다.

즉, 올바른 위치인지 판단할 수 있습니다.


--- 

## NLatLngBounds 메서드

### containsPoint

`bool containsPoint(NLatLng point)`

bounds가 point를 포함하는지 여부를 반환합니다.

### containsBounds

`bool containsBounds(NLatLngBounds bounds)`

bounds가 다른 bounds를 포함하는지 여부를 반환합니다.

### expand

`NLatLngBounds expand(NLatLng point)`

bounds와 point를 포함하는 최소한의 bounds를 반환합니다.

### union

`NLatLngBounds union(NLatLngBounds bounds)`

bounds와 다른 bounds를 포함하는 최소한의 bounds를 반환합니다.

### intersection

`NLatLngBounds? intersection(NLatLngBounds bounds)`

bounds와 다른 bounds가 겹치는 부분의 bounds를 반환합니다.

두 영역이 겹치지 않는다면 null을 반환합니다.