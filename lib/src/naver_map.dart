
part of flutter_naver_map;

/// ### 네이버지도
/// 네이버 지도는 네이버 SDK 를 flutter 에서 사용할 수 있게 하는 주요 widget 이다.
class NaverMap extends StatefulWidget {
  const NaverMap({
    Key? key,
    this.onMapCreated,
    this.onMapTap,
    this.onMapLongTap,
    this.onMapDoubleTap,
    this.onMapTwoFingerTap,
    this.onSymbolTap,
    this.onCameraChange,
    this.onCameraIdle,
    this.pathOverlays,
    this.initialCameraPosition,
    this.mapType = MapType.Basic,
    this.liteModeEnable = false,
    this.nightModeEnable = false,
    this.indoorEnable = false,
    this.activeLayers = const [MapLayer.LAYER_GROUP_BUILDING],
    this.buildingHeight = 1.0,
    this.symbolScale = 1.0,
    this.symbolPerspectiveRatio = 1.0,
    this.rotationGestureEnable = true,
    this.scrollGestureEnable = true,
    this.tiltGestureEnable = true,
    this.zoomGestureEnable = true,
    this.locationButtonEnable = false,
    this.logoClickEnabled = false,
    this.useSurface = false,
    this.initLocationTrackingMode = LocationTrackingMode.NoFollow,
    this.contentPadding,
    this.markers = const [],
    this.circles = const [],
    this.polygons = const [],
    this.minZoom = 0.0,
    this.maxZoom = 21.0,
  }) : super(key: key);

  /// 지도가 완전히 만들어진 후에 컨트롤러를 파라미터로 가지는 콜백.
  /// 해당 콜백이 호출되기 전에는 지도가 만들어지는 중이다.
  final MapCreateCallback? onMapCreated;

  /// 지도를 탭했을때 호출되는 콜백함수.
  ///
  ///
  /// 사용자가 선택한 지점의 [LatLng]을 파라미터로 가진다.
  final OnMapTap? onMapTap;

  /// ### 지도를 롱 탭했을때 호출되는 콜백함수. (Android only)
  ///
  /// 사용자가 선택한 지점의 [LatLng]을 파라미터로 가진다.
  final OnMapLongTap? onMapLongTap;

  /// 카메라가 움직일때 호출되는 콜백
  final OnCameraChange? onCameraChange;

  /// 카메라의 움직임이 완료되었을때 호출되는 콜백
  final VoidCallback? onCameraIdle;

  /// 카메라의 최초 포지션.
  /// </br>
  /// <p>initial tracking mode 가 [LocationTrackingMode.None]이거나 [LocationTrackingMode.NoFollow]인 경우에만 반영된디.</p>
  final CameraPosition? initialCameraPosition;

  /// 지도 타입 설정.
  final MapType mapType;

  /// 이 속성을 사용하면 라이트 모드를 활성화할 수 있습니다.
  /// 기본값은 false입니다.
  /// 라이트 모드가 활성화되면 지도의 로딩이 빨라지고 메모리 소모가 줄어듭니다.
  /// 그러나 다음과 같은 제약이 생깁니다.
  ///
  /// - 지도의 전반적인 화질이 하락합니다.
  /// - Navi 지도 유형을 사용할 수 없습니다.
  /// - 레이어 그룹을 활성화할 수 없습니다.
  /// - 실내지도, 야간 모드를 사용할 수 없습니다.
  /// - 디스플레이 옵션을 변경할 수 없습니다.
  /// - 카메라가 회전하거나 기울어지면 지도 심벌도 함께 회전하거나 기울어집니다.
  /// - 줌 레벨이 커지거나 작아지면 지도 심벌도 일정 정도 함께 커지거나 작아집니다.
  /// - 지도 심벌의 클릭 이벤트를 처리할 수 없습니다.
  /// - 마커와 지도 심벌 간 겹침을 처리할 수 없습니다.
  final bool liteModeEnable;

  /// 속성을 사용하면 야간 모드를 활성화할 수 있습니다. 야간 모드가 활성화되면 지도의
  /// 전반적인 스타일이 어두운 톤으로 변경됩니다. 단, 지도 유형이 야간 모드를 지원하지
  /// 않을 경우 야간 모드를 활성화하더라도 아무런 변화가 일어나지 않습니다.
  /// Navi 지도 유형만이 야간 모드를 지원합니다.
  /// 기본값은 fasle 입니다.
  final bool nightModeEnable;

  /// 해당 속성을 사용하면 실내지도를 활성화할 수 있습니다.
  /// 기본값은 false 입니다.
  /// 실내지도가 활성화되면 줌 레벨이 일정 수준 이상이고 실내지도가 있는 영역에 지도의
  /// 중심이 위치할 경우 자동으로 해당 영역에 대한 실내지도가 나타납니다.
  /// 단, 지도 유형이 실내지도를 지원하지 않으면 실내지도를 활성화하더라도 아무런 변화가
  /// 일어나지 않습니다. Basic, Terrain 지도 유형만이 실내지도를 지원합니다.
  final bool indoorEnable;

  /// 바닥 지도 위에 부가적인 정보를 나타내는 레이어 그룹을 활성화 할 수 있습니다.
  /// 지도의 타입마다 설정가능한 레이어 그룹이 다릅니다.
  ///
  /// ***
  /// null 인경우 [MapLayer.LAYER_GROUP_BUILDING]이 기본값으로 설정됩니다.
  ///
  /// 건물레이어를 지우고 싶으면 빈 리스트를 파라미터로 넘겨주세요.
  final List<MapLayer> activeLayers;

  /// 지도가 기울어지면 건물이 입체적으로 표시됩니다. buildingHeight 속성을 사용하면
  /// 입체적으로 표현되는 건물의 높이를 지정할 수 있습니다.
  /// 값은 0~1의 비율로 지정할 수 있으며, 0으로 지정하면 지도가 기울어지더라도
  /// 건물이 입체적으로 표시되지 않습니다. 기본값은 1입니다.
  final double buildingHeight;

  /// 속성을 사용하면 심벌의 크기를 변경할 수 있습니다. 0~2의 비율로 지정할 수 있으며,
  /// 값이 클수록 심벌이 커집니다. 기본값은 1입니다. 0일때, 심볼이 표시되지 않습니다.
  final double symbolScale;

  /// 지도를 기울이면 가까이 있는 심벌은 크게, 멀리 있는 심벌은 작게 그려집니다.
  /// symbolPerspectiveRatio 속성을 사용하면 심벌의 원근 효과를 조절할 수 있습니다.
  /// 0~1의 비율로 지정할 수 있으며, 값이 작을수록 원근감이 줄어들어 0이 되면
  /// 원근 효과가 완전히 사라집니다. 기본값은 1입니다.
  final double symbolPerspectiveRatio;

  /// NaveraMap 최초 생성 이후,
  /// flutter에서 setState() 함수로 값을 변경해도 반영 되지 않는다.
  ///
  /// 이 속성을 이용해서 지도의 회전을 불가능하게 할 수 있다.
  /// 기본값은 true이다.
  ///
  /// [rotationGestureEnable], [scrollGestureEnable], [tiltGestureEnable],
  ///
  /// [zoomGestureEnable], [locationButtonEnable] 5가지는 초기화시에만 반영된다.
  final bool rotationGestureEnable;

  /// NaveraMap 최초 생성 이후,
  /// flutter에서 setState() 함수로 값을 변경해도 반영 되지 않는다.
  ///
  /// 이 속성을 이용해서 지도의 이동을 불가능하게 할 수 있다.
  /// 기본값은 true이다.
  final bool scrollGestureEnable;

  /// NaveraMap 최초 생성 이후,
  /// flutter에서 setState() 함수로 값을 변경해도 반영 되지 않는다.
  ///
  /// 이 속성을 이용해서 지도의 기울임을 불가능하게 할 수 있다.
  /// 기본값은 true이다.
  final bool tiltGestureEnable;

  /// NaveraMap 최초 생성 이후,
  /// flutter에서 setState() 함수로 값을 변경해도 반영 되지 않는다.
  ///
  /// 이 속성을 이용해서 지도의 확대를 불가능하게 할 수 있다.
  /// 기본값은 true이다.
  final bool zoomGestureEnable;

  /// <h2> Naver Map에서 기본적으로 제공하는 현위치 버튼을 활성화시킨다.</h2>
  /// <br/>
  /// <p>기본값은 [false]이다.</p>
  final bool locationButtonEnable;

  /// <h2> Naver Map 로고 버튼의 활성화 여부를 바꿀 수 있습니다.</h2>
  /// <br/>
  /// <p>현재는 Android에서만 동작합니다.</p>
  /// <p>기본값은 [false]이다. [true]일 경우, 현재는 Crash가 발생합니다.</p>
  final bool logoClickEnabled;

  /// 지도에 표시될 마커의 리스트입니다.
  final List<Marker> markers;

  /// 지도에 표시될 [PathOverlay]의 [Set] 입니다..
  final Set<PathOverlay>? pathOverlays;

  /// 지도에 표시될 [CircleOverlay]의 [List]입니다.
  final List<CircleOverlay> circles;

  /// 지도에 표시될 [PolygonOverlay]의 [List]입니다.
  final List<PolygonOverlay> polygons;

  /// 지도가 더블탭될때 콜백되는 메서드. (Android only)
  final OnMapDoubleTap? onMapDoubleTap;

  /// 최초 지도 생성시에 위치추적모드를 선택할 수 있습니다.
  ///
  /// 기본값은 [LocationTrackingMode.NoFollow] 입니다.
  final LocationTrackingMode initLocationTrackingMode;

  /// 지도가 두 손가락으로 탭 되었을때 호출되는 콜백 메서드. (Android only)
  final OnMapTwoFingerTap? onMapTwoFingerTap;

  /// <h2>심볼 탭 이벤트</h2>
  /// <p>빌딩을 나타내는 심볼이나, 공공시설을 표시하는 심볼등을 선택했을 경우 호출된다.</p>
  final OnSymbolTap? onSymbolTap;

  /// ## 콘텐트 패딩
  /// Stack 구조의 화면에서 지도 상에 UI요소가 지도의 일부를 덮을 경우, 카메라는 지도
  /// 뷰의 중심에 위치하므로 실제 보이는 지도의 중심과 카메라의 위치가 불일치하게 됩니다.
  final EdgeInsets? contentPadding;

  /// ## 안드로이드에서 GLSurfaceView 사용 여부
  /// 값이 true인 경우, 안드로이드에서 naver map을 [GLSurfaceView]를 사용해서 렌더링하고,
  /// 반대인 경우 [TextureView]를 사용해서 렌더링한다.
  /// [GLSurfaceView]를 사용할 경우 지도의 속도는 원활해지나, android 기기에서 hot reload시,
  /// naver map SDK 내부 binary 에서 발생하는 에러로 app crash 가 발생한다.
  ///
  /// > 또한 [GLSurfaceView]를 사용하여 지도가 렌더링 되는 동안, [TextField]에 포커스가
  /// 이동하면 app crash가 발생한다. Flutter Engine에서 [TextField]의 변화를 업데이트할 때,
  /// [GLThread]를 사용하는데, 이 과정에서 [DeadObjectException]이 발생한다.
  ///
  /// 만약 [GLSurfaceView]를 사용하는 [NaverMap]가 생성된 상태에서 [TextField]를 사용하지
  /// 않는다면 다음과 같이 사용하면 release mode로 build된 app에서 더 좋은 성능을 기대할 수 있다.
  ///
  /// ```dart
  /// import 'package:flutter/foundation.dart';
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return NaverMap(
  ///     useSurface: kReleaseMode,
  ///   );
  /// }
  /// ```
  ///
  /// - 기본값은 false 이다.
  final bool useSurface;

  /// ## 최소 줌 레벨 제한 ##
  /// default 0.0
  final double minZoom;

  /// ## 최대 줌 레벨 제한 ##
  /// default 21.0
  final double maxZoom;

  @override
  _NaverMapState createState() => _NaverMapState();
}

class _NaverMapState extends State<NaverMap> {
  Completer<NaverMapController> _controller = Completer<NaverMapController>();
  late _NaverMapOptions _naverMapOptions;

  Map<String, Marker> _markers = <String, Marker>{};
  Map<String, CircleOverlay> _circles = <String, CircleOverlay>{};
  Map<PathOverlayId, PathOverlay> _paths = <PathOverlayId, PathOverlay>{};
  Map<String, PolygonOverlay> _polygons = <String, PolygonOverlay>{};

  @override
  void initState() {
    super.initState();
    _naverMapOptions = _NaverMapOptions.fromWidget(widget);
    _markers = _keyByMarkerId(widget.markers);
    _paths = _keyByPathOverlayId(widget.pathOverlays);
    _circles = _keyByCircleId(widget.circles);
    _polygons = _keyByPolygonId(widget.polygons);
  }

  @override
  void dispose() {
    if(Platform.isIOS) _controller.future.then((c) => c.clearMapView());
    super.dispose();
  }

  Future<void> onPlatformViewCreated(int id) async {
    final NaverMapController controller = await NaverMapController.init(
      id,
      widget.initialCameraPosition,
      this,
    );
    if (_controller.isCompleted) _controller = Completer<NaverMapController>();
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> createParams = <String, dynamic>{
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'options': _naverMapOptions.toMap(),
      'markers': _serializeMarkerSet(widget.markers) ?? [],
      'paths': _serializePathOverlaySet(widget.pathOverlays) ?? [],
      'circles': _serializeCircleSet(widget.circles) ?? [],
      'polygons': _serializePolygonSet(widget.polygons) ?? [],
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidView view = AndroidView( // virtual screen
        viewType: VIEW_TYPE,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: createParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
      return view;

      /// todo: waiting for most people use flutter version higher than 1.22.2
      /// hybrid composition
      // return PlatformViewLink(
      //   viewType: VIEW_TYPE,
      //   surfaceFactory: (context, controller) => AndroidViewSurface(
      //     controller: controller,
      //     hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      //     gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      //   ),
      //   onCreatePlatformView: (params) {
      //     return PlatformViewsService.initSurfaceAndroidView(
      //       id: params.id,
      //       viewType: params.viewType,
      //       creationParams: createParams,
      //       creationParamsCodec: const StandardMessageCodec(),
      //       layoutDirection: TextDirection.ltr,
      //     )
      //       ..addOnPlatformViewCreatedListener(onPlatformViewCreated)
      //       ..create();
      //   },
      // );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final view = UiKitView(
        viewType: VIEW_TYPE,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: createParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
      return view;
    }

    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }

  @override
  void didUpdateWidget(NaverMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateMarkers();
    _updatePathOverlay();
    _updateCircleOverlay();
    _updatePolygonOverlay();
  }

  void _updateOptions() async {
    final _NaverMapOptions newOption = _NaverMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates = _naverMapOptions.updatesMap(newOption);
    if (updates.isEmpty) return;
    final NaverMapController controller = await _controller.future;
    controller._updateMapOptions(updates);
    _naverMapOptions = newOption;
  }

  void _updateMarkers() async {
    final NaverMapController controller = await _controller.future;
    controller._updateMarkers(_MarkerUpdates.from(
      _markers.values.toSet(),
      widget.markers.toSet(),
    ));
    _markers = _keyByMarkerId(widget.markers);
  }

  void _updatePathOverlay() async {
    final NaverMapController controller = await _controller.future;
    controller._updatePathOverlay(_PathOverlayUpdates.from(
        _paths.values.toSet(), widget.pathOverlays?.toSet()));
    _paths = _keyByPathOverlayId(widget.pathOverlays);
  }

  void _updateCircleOverlay() async {
    final NaverMapController controller = await _controller.future;
    controller._updateCircleOverlay(_CircleOverlayUpdate.from(
      _circles.values.toSet(),
      widget.circles.toSet(),
    ));
    _circles = _keyByCircleId(widget.circles);
  }

  void _updatePolygonOverlay() async {
    final NaverMapController controller = await _controller.future;
    controller._updatePolygonOverlay(_PolygonOverlayUpdate.from(
      _polygons.values.toSet(),
      widget.polygons.toSet(),
    ));
    _polygons = _keyByPolygonId(widget.polygons);
  }

  void _markerTapped(String markerId, int? iconWidth, int? iconHeight) {
    if (_markers[markerId]?.onMarkerTab != null) {
      _markers[markerId]!.onMarkerTab!(
        _markers[markerId],
        <String, int?>{'width': iconWidth, 'height': iconHeight},
      );
    }
  }

  void _pathOverlayTapped(String pathId) {
    PathOverlayId pathOverlayId = PathOverlayId(pathId);
    if (_paths[pathOverlayId]?.onPathOverlayTab != null) {
      _paths[pathOverlayId]!.onPathOverlayTab!(pathOverlayId);
    }
  }

  void _circleOverlayTapped(String overlayId) {
    if (_circles[overlayId]?.onTap != null) {
      _circles[overlayId]!.onTap!(overlayId);
    }
  }

  void _polygonOverlayTapped(String overlayId) {
    if (_polygons[overlayId]?.onTap != null) {
      _polygons[overlayId]!.onTap!(overlayId);
    }
  }

  void _mapTap(LatLng position) {
    widget.onMapTap?.call(position);
  }

  void _mapLongTap(LatLng position) {
    widget.onMapLongTap?.call(position);
  }

  void _mapDoubleTap(LatLng position) {
    widget.onMapDoubleTap?.call(position);
  }

  void _mapTwoFingerTap(LatLng position) {
    widget.onMapTwoFingerTap?.call(position);
  }

  void _symbolTab(LatLng? position, String? caption) {
    assert(position != null && caption != null);
    if (widget.onSymbolTap != null) widget.onSymbolTap!(position, caption);
  }

  void _cameraMove(
      LatLng? position, CameraChangeReason reason, bool? isAnimated) {
    if (widget.onCameraChange != null)
      widget.onCameraChange!(position, reason, isAnimated);
  }

  void _cameraIdle() {
    if (widget.onCameraIdle != null) widget.onCameraIdle!();
  }
}

class _NaverMapOptions {
  _NaverMapOptions({
    this.mapType,
    this.liteModeEnable,
    this.nightModeEnable,
    this.indoorEnable,
    this.activeLayers,
    this.buildingHeight,
    this.symbolScale,
    this.symbolPerspectiveRatio,
    this.zoomGestureEnable,
    this.tiltGestureEnable,
    this.scrollGestureEnable,
    this.rotationGestureEnable,
    this.initLocationTrackingMode,
    this.locationButtonEnable,
    this.logoClickEnabled,
    this.contentPadding,
    this.useSurface,
    this.maxZoom,
    this.minZoom,
  });

  static _NaverMapOptions fromWidget(NaverMap map) {
    return _NaverMapOptions(
      mapType: map.mapType,
      liteModeEnable: map.liteModeEnable,
      nightModeEnable: map.nightModeEnable,
      indoorEnable: map.indoorEnable,
      activeLayers: map.activeLayers,
      buildingHeight: map.buildingHeight,
      symbolScale: map.symbolScale,
      symbolPerspectiveRatio: map.symbolPerspectiveRatio,
      rotationGestureEnable: map.rotationGestureEnable,
      scrollGestureEnable: map.scrollGestureEnable,
      tiltGestureEnable: map.tiltGestureEnable,
      zoomGestureEnable: map.zoomGestureEnable,
      initLocationTrackingMode: map.initLocationTrackingMode,
      locationButtonEnable: map.locationButtonEnable,
      logoClickEnabled: map.logoClickEnabled,
      contentPadding: map.contentPadding,
      useSurface: map.useSurface,
      maxZoom: map.maxZoom,
      minZoom: map.minZoom,
    );
  }

  final MapType? mapType;
  final bool? liteModeEnable;
  final bool? nightModeEnable;
  final bool? indoorEnable;
  final List<MapLayer>? activeLayers;
  final double? buildingHeight;
  final double? symbolScale;
  final double? symbolPerspectiveRatio;
  final bool? rotationGestureEnable;
  final bool? scrollGestureEnable;
  final bool? tiltGestureEnable;
  final bool? zoomGestureEnable;
  final LocationTrackingMode? initLocationTrackingMode;
  final bool? locationButtonEnable;
  final bool? logoClickEnabled;
  final EdgeInsets? contentPadding;
  final bool? useSurface;
  final double? maxZoom;
  final double? minZoom;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> optionsMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        optionsMap[fieldName] = value;
      }
    }

    List<int> inactiveLayerIndices = [];
    activeLayers?.forEach((layer) => inactiveLayerIndices.add(layer.index));

    addIfNonNull('mapType', mapType?.index);
    addIfNonNull('liteModeEnable', liteModeEnable);
    addIfNonNull('nightModeEnable', nightModeEnable);
    addIfNonNull('indoorEnable', indoorEnable);
    addIfNonNull('activeLayers', inactiveLayerIndices);
    addIfNonNull('buildingHeight', buildingHeight);
    addIfNonNull('symbolScale', symbolScale);
    addIfNonNull('symbolPerspectiveRatio', symbolPerspectiveRatio);
    addIfNonNull('scrollGestureEnable', scrollGestureEnable);
    addIfNonNull('zoomGestureEnable', zoomGestureEnable);
    addIfNonNull('rotationGestureEnable', rotationGestureEnable);
    addIfNonNull('tiltGestureEnable', tiltGestureEnable);
    addIfNonNull('locationTrackingMode', initLocationTrackingMode?.index);
    addIfNonNull('locationButtonEnable', locationButtonEnable);
    addIfNonNull('logoClickEnabled', logoClickEnabled);
    addIfNonNull('useSurface', useSurface);
    addIfNonNull('maxZoom', maxZoom);
    addIfNonNull('minZoom', minZoom);
    addIfNonNull(
        'contentPadding',
        contentPadding != null
            ? [
                contentPadding!.left,
                contentPadding!.top,
                contentPadding!.right,
                contentPadding!.bottom,
              ]
            : null);
    return optionsMap;
  }

  Map<String, dynamic> updatesMap(_NaverMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere(
          (String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
