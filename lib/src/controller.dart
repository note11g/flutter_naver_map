part of flutter_naver_map;

class NaverMapController {
  NaverMapController._(this._channel, CameraPosition? initialCameraPosition,
      this._naverMapState) {
    _channel.setMethodCallHandler(_handleMethodCall);
    locationOverlay = LocationOverlay(this);
  }

  static Future<NaverMapController> init(
      int id,
      CameraPosition? initialCameraPosition,
      _NaverMapState naverMapState) async {
    final MethodChannel channel = MethodChannel(VIEW_TYPE + '_$id');

    await channel.invokeMethod<void>('map#waitForMap');
    return NaverMapController._(
      channel,
      initialCameraPosition,
      naverMapState,
    );
  }

  final MethodChannel _channel;

  final _NaverMapState _naverMapState;

  void Function(String? path)? _onSnapShotDone;

  /// <h2>위치 오버레이</h2>
  /// <p>위치 오버레이는 사용자의 위치를 나타내는 데 특화된 오버레이이로, 지도상에 단 하나만
  /// 존재합니다. 사용자가 바라보는 방향을 손쉽게 지정할 수 있고 그림자, 강조용 원도 나타낼 수 있습니다.</p>
  LocationOverlay? locationOverlay;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'map#clearMapView':
        clearMapView();
        break;
      case 'marker#onTap':
        String markerId = call.arguments['markerId'];
        int? iconWidth = call.arguments['iconWidth'] as int?;
        int? iconHeight = call.arguments['iconHeight'] as int?;
        _naverMapState._markerTapped(markerId, iconWidth, iconHeight);
        break;
      case 'path#onTap':
        String pathId = call.arguments['pathId'];
        _naverMapState._pathOverlayTapped(pathId);
        break;
      case 'circle#onTap':
        String overlayId = call.arguments['overlayId'];
        _naverMapState._circleOverlayTapped(overlayId);
        break;
      case 'polygon#onTap':
        String overlayId = call.arguments['polygonOverlayId'];
        _naverMapState._polygonOverlayTapped(overlayId);
        break;
      case 'map#onTap':
        LatLng latLng = LatLng._fromJson(call.arguments['position'])!;
        _naverMapState._mapTap(latLng);
        break;
      case 'map#onLongTap':
        LatLng latLng = LatLng._fromJson(call.arguments['position'])!;
        _naverMapState._mapLongTap(latLng);
        break;
      case 'map#onMapDoubleTap':
        LatLng latLng = LatLng._fromJson(call.arguments['position'])!;
        _naverMapState._mapDoubleTap(latLng);
        break;
      case 'map#onMapTwoFingerTap':
        LatLng latLng = LatLng._fromJson(call.arguments['position'])!;
        _naverMapState._mapTwoFingerTap(latLng);
        break;
      case 'map#onSymbolClick':
        LatLng? position = LatLng._fromJson(call.arguments['position']);
        String? caption = call.arguments['caption'];
        _naverMapState._symbolTab(position, caption);
        break;
      case 'camera#move':
        LatLng? position = LatLng._fromJson(call.arguments['position']);
        final reason = CameraChangeReason.values[call.arguments['reason']];
        final isAnimated = call.arguments['animated'];
        _naverMapState._cameraMove(position, reason, isAnimated);
        break;
      case 'camera#idle':
        _naverMapState._cameraIdle();
        break;
      case 'snapshot#done':
        if (_onSnapShotDone != null) {
          _onSnapShotDone!(call.arguments['path']);
          _onSnapShotDone = null;
        }
        break;
    }
  }

  /// 네이버 맵 위젯의 메모리 할당을 해제합니다
  /// 현재, IOS 기기에서 네이버 맵 인스턴스 해제가 되지 않는 이슈가 있어, 이 Method는 IOS 플랫폼에서만 지원 합니다.
  /// (안드로이드 기기는 자동 해제됩니다.)
  /// Ex) Platform.isIOS 조건문 이용
  Future<void> clearMapView() async {
    await _channel.invokeMethod<List<dynamic>>('map#clearMapView');
  }

  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) async {
    await _channel.invokeMethod(
      'map#update',
      <String, dynamic>{
        'options': optionsUpdate,
      },
    );
  }

  Future<void> _updateMarkers(_MarkerUpdates markerUpdate) async {
    await _channel.invokeMethod<void>(
      'markers#update',
      markerUpdate._toMap(),
    );
  }

  Future<void> _updatePathOverlay(
      _PathOverlayUpdates pathOverlayUpdates) async {
    await _channel.invokeMethod(
      'pathOverlay#update',
      pathOverlayUpdates._toMap(),
    );
  }

  Future<void> _updateCircleOverlay(
      _CircleOverlayUpdate circleOverlayUpdate) async {
    await _channel.invokeMethod(
      'circleOverlay#update',
      circleOverlayUpdate._toMap(),
    );
  }

  Future<void> _updatePolygonOverlay(
      _PolygonOverlayUpdate polygonOverlayUpdate) async {
    await _channel.invokeMethod(
      'polygonOverlay#update',
      polygonOverlayUpdate._toMap(),
    );
  }

  /// 현재 지도에 보여지는 영역에 대한 [LatLngBounds] 객체를 리턴.
  Future<LatLngBounds> getVisibleRegion() async {
    final Map<String, dynamic> latLngBounds = (await _channel
        .invokeMapMethod<String, dynamic>('map#getVisibleRegion'))!;
    final LatLng southwest = LatLng._fromJson(latLngBounds['southwest'])!;
    final LatLng northeast = LatLng._fromJson(latLngBounds['northeast'])!;

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  /// 현재 지도의 중심점 좌표에 대한 [CameraPosition] 객체를 리턴.
  Future<CameraPosition> getCameraPosition() async {
    final Map position = (await _channel.invokeMethod<Map>('map#getPosition'))!;
    return CameraPosition(
      target: LatLng._fromJson(position['target'])!,
      zoom: position['zoom'],
      tilt: position['tilt'],
      bearing: position['bearing'],
    );
  }

  /// 지도가 보여지는 view 의 크기를 반환.
  /// Map<String, double>로 반환.
  ///
  /// ['width' : 가로 pixel, 'height' : 세로 pixel]
  Future<Map<String, int?>> getSize() async {
    final Map size = (await _channel.invokeMethod<Map>('map#getSize'))!;
    return <String, int?>{'width': size['width'], 'height': size['height']};
  }

  /// <h2>카메라 이동</h2>
  /// <p>카메라를 이동시키는 가장 주요 메서드이다. [CameraUpdate]의 static 생성자를 이용해서
  /// 인자를 전달한다.</p>
  Future<void> moveCamera(CameraUpdate cameraUpdate, { bool enableAnimation = true }) async {
    await _channel.invokeMethod<void>('camera#move', <String, dynamic>{
      'cameraUpdate': cameraUpdate._toJson(),
      'animation': enableAnimation
    });
  }

  /// <h2>카메라 추적모드 변경</h2>
  /// <p>[NaverMap]을 생성할 때 주어진 [initialLocationTrackingMode]의 인자로 전달된 값이
  /// 기본값으로 설정되어 있으며, 이후 controller 를 이용해서 변경하는 메서드이다.</p>
  Future<void> setLocationTrackingMode(LocationTrackingMode mode) async {
    await _channel.invokeMethod('tracking#mode', <String, dynamic>{
      'locationTrackingMode': mode.index,
    });
  }

  /// ### 지도의 유형 변경
  /// [MapType]을 전달하면 해당 유형으로 지도의 타일 유형이 변경된다.
  Future<void> setMapType(MapType type) async {
    await _channel.invokeMethod('map#type', {'mapType': type.index});
  }

  /// <h3>현재 지도의 모습을 캡쳐하여 cache file 에 저장하고 완료되면 [onSnapShotDone]을 통해 파일의 경로를 전달한다.</h3>
  /// <br/>
  /// <p>네이티브에서 실행중 문제가 발생시에 [onSnapShotDone]의 파라미터로 null 이 들어온다</p>
  void takeSnapshot(void Function(String? path) onSnapShotDone) async {
    _onSnapShotDone = onSnapShotDone;
    _channel.invokeMethod<String>('map#capture');
  }

  /// <h3>지도의 content padding 을 설정한다.</h3>
  /// <p>인자로 받는 값의 단위는 DP 단위이다.</p>
  Future<void> setContentPadding(
      {double? left, double? right, double? top, double? bottom}) async {
    await _channel.invokeMethod('map#padding', <String, dynamic>{
      'left': left ?? 0.0,
      'right': right ?? 0.0,
      'top': top ?? 0.0,
      'bottom': bottom ?? 0.0,
    });
  }

  /// <h2>현재 지도의 축적을 미터/DP 단위로 반환합니다.</h2>
  /// <p>dp 단위를 미터로 환산하는 경우 해당 메서드를 통해서 확인할 수 있다.</p>
  Future<double> getMeterPerDp() async {
    final result = await _channel.invokeMethod<double>('meter#dp');
    return result ?? 0.0;
  }

  /// <h2>현재 지도의 축적을 미터/Pixel 단위로 반환합니다.</h2>
  /// <p>픽셀 단위를 미터로 환산하는 경우 해당 메서드를 통해서 확인할 수 있다.</p>
  Future<double> getMeterPerPx() async {
    final result = await _channel.invokeMethod<double>('meter#px');
    return result ?? 0.0;
  }
}

/// <h2>위치 오버레이</h2>
/// <p>위치 오버레이는 사용자의 위치를 나타내는 데 특화된 오버레이이로, 지도상에 단 하나만
/// 존재합니다. 사용자가 바라보는 방향을 손쉽게 지정할 수 있고 그림자, 강조용 원도 나타낼 수 있습니다.</p>
class LocationOverlay {
  final MethodChannel _channel;

  /// 해당 객체를 참조하기 위햐서 [NaverMapController]의 맵버변수를 참조하거나,
  /// [NaverMapController]객체를 인자로 넘겨서 새롭게 생성하여 참조한다.
  LocationOverlay(NaverMapController controller)
      : _channel = controller._channel;

  /// 위치 오버레이의 좌표를 변경할 수 있습니다.
  /// 처음 생성된 위치 오버레이는 카메라의 초기 좌표에 위치해 있습니다.
  Future<void> setPosition(LatLng position) async {
    _channel.invokeMethod("LO#set#position", {
      'position': position._toJson(),
    });
  }

  /// __setBearing__ 을 이용하면 위치 오버레이의 베어링을 변경할 수 있습니다.
  /// flat이 true인 마커의 andgle속성과 유사하게 아이콘이 지도를 기준으로 회전합니다.
  /// > ***0.0은 정북쪽을 의미합니다.***
  ///
  /// 다음은 위치 오버레이의 베어링을 동쪽으로 변경하는 예제입니다.
  /// ```
  /// locaionOverlay.setBearing(90.0);
  /// ```
  Future<void> setBearing(double bearing) async {
    _channel.invokeMethod("LO#set#bearing", {'bearing': bearing});
  }
}
