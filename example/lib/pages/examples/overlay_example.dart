import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/theme.dart';
import 'package:flutter_naver_map_example/pages/examples/example_base.dart';

import '../../design/custom_widget.dart';

class NOverlayExample extends ExampleBasePage {
  const NOverlayExample({
    Key? key,
    required super.mapController,
    required super.canScroll,
  }) : super(key: key);

  @override
  State<NOverlayExample> createState() => _NOverlayExampleState();
}

class _NOverlayExampleState extends State<NOverlayExample> {
  NOverlayType willCreateOverlayType = NOverlayType.marker;
  NAddableOverlay? willCreateOverlay;

  NaverMapController get mapController => widget.mapController;

  void attachOverlay() async {
    final cameraPosition = await mapController.getCameraPosition();
    final overlay = NOverlayMakerUtil.makeOverlay(
        type: willCreateOverlayType, cameraPosition: cameraPosition);
    overlay.setOnTapListener((overlay) {
      final latLng = cameraPosition.target;
      mapController.latLngToScreenLocation(latLng).then(
          (point) => addFlutterFloatingOverlay(point: point, overlay: overlay));
    });
    mapController.addOverlay(overlay);
  }

  OverlayEntry? entry;

  void addFlutterFloatingOverlay({
    required NOverlay<dynamic> overlay,
    required NPoint point,
  }) {
    entry = OverlayEntry(builder: (context) {
      final xPosition = (point.x) - 28;
      return Positioned.fill(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => removeFlutterFloatingOverlay(),
              child: Stack(children: [
                Positioned(
                    left: xPosition < 0 ? 0 : xPosition,
                    top: point.y < 0 ? 0 : point.y,
                    child: Balloon(
                        size: const Size(200, 200),
                        padding: const EdgeInsets.all(8),
                        backgroundColor: getColorTheme(context).background,
                        child: ListView(children: [
                          Text(overlay.toString()),
                          SimpleButton(
                              text: "지우기",
                              action: () {
                                mapController.deleteOverlay(overlay.info);
                                removeFlutterFloatingOverlay();
                              })
                        ])))
              ])));
    });
    Overlay.of(context).insert(entry!);
  }

  void removeFlutterFloatingOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SimpleTitle("화면 중앙에 오버레이가 생성됩니다.",
          description: "생성된 오버레이를 터치하면 속성을 변경할 수 있어요.",
          direction: Axis.vertical,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24)),
      SelectorWithTitle("오버레이 유형",
          description: "NOverlayType",
          selector: (context) => EasyDropdown(
              items: NOverlayType.values
                  .where((t) => t != NOverlayType.locationOverlay)
                  .toList(),
              value: willCreateOverlayType,
              onChanged: (v) => setState(() => willCreateOverlayType = v))),
      SimpleButton(
          text: "${willCreateOverlayType.koreanName} 생성",
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          action: attachOverlay),
      if (widget.canScroll)
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Row(children: [
              Expanded(
                child: SimpleButton(
                    text: "${willCreateOverlayType.koreanName}만 모두 지우기",
                    color: Colors.orange,
                    margin: EdgeInsets.zero,
                    action: () => mapController.clearOverlays(
                        type: willCreateOverlayType)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SimpleButton(
                    text: "모두 지우기",
                    color: Colors.red,
                    margin: EdgeInsets.zero,
                    action: () => mapController.clearOverlays()),
              )
            ])),
      const BottomPadding(),
    ]);
  }

  @override
  void dispose() {
    removeFlutterFloatingOverlay();
    super.dispose();
  }
}

extension NOverlayExtension on NOverlayType {
  String get koreanName {
    switch (this) {
      case NOverlayType.marker:
        return "마커";
      case NOverlayType.infoWindow:
        return "정보창";
      case NOverlayType.circleOverlay:
        return "원 오버레이";
      case NOverlayType.groundOverlay:
        return "지상 오버레이";
      case NOverlayType.polygonOverlay:
        return "다각형 오버레이";
      case NOverlayType.polylineOverlay:
        return "선 오버레이";
      case NOverlayType.pathOverlay:
        return "경로 오버레이";
      case NOverlayType.multipartPathOverlay:
        return "경로(멀티파트) 오버레이";
      case NOverlayType.arrowheadPathOverlay:
        return "경로(화살표) 오버레이";
      case NOverlayType.locationOverlay:
        return "위치 오버레이";
    }
  }
}

class NOverlayMakerUtil {
  static NAddableOverlay makeOverlay({
    required NOverlayType type,
    required NCameraPosition cameraPosition,
    String? id,
  }) {
    final overlayId = id ?? _timeBasedId;

    final point = cameraPosition.target;
    final heartCoords = NOverlayMakerUtil.getHeartCoordinates(
        cameraPosition.target,
        zoomLevel: cameraPosition.zoom);
    final pathCoords = [
      point,
      point.offsetByMeter(northMeter: -100, eastMeter: 100),
      point.offsetByMeter(northMeter: -200),
      point.offsetByMeter(northMeter: -300, eastMeter: 100),
    ];
    final secondPathCoords = [
      pathCoords.last,
      pathCoords.last.offsetByMeter(northMeter: -100, eastMeter: -100),
      pathCoords.last.offsetByMeter(northMeter: -200),
    ];

    switch (type) {
      case NOverlayType.marker:
        return NMarker(id: overlayId, position: point);
      case NOverlayType.infoWindow:
        return NInfoWindow.onMap(
            id: overlayId, position: point, text: '인포 윈도우');
      case NOverlayType.circleOverlay:
        return NCircleOverlay(
            id: overlayId,
            center: point,
            color: Colors.green.withOpacity(0.3),
            radius: 100,
            outlineColor: Colors.greenAccent,
            outlineWidth: 2);
      case NOverlayType.groundOverlay:
        final bounds = NLatLngBounds(
            southWest: point,
            northEast: point.offsetByMeter(northMeter: 422, eastMeter: 818));
        print(bounds);
        const img = NOverlayImage.fromAssetImage('assets/ground_img.png');
        return NGroundOverlay(
            id: overlayId, bounds: bounds, image: img, alpha: 1);
      case NOverlayType.polygonOverlay:
        return NPolygonOverlay(
            id: overlayId,
            coords: heartCoords,
            color: Colors.redAccent.withOpacity(0.5));
      case NOverlayType.polylineOverlay:
        return NPolylineOverlay(
            id: overlayId, coords: heartCoords, color: Colors.red);
      case NOverlayType.pathOverlay:
        return NPathOverlay(
            id: overlayId, coords: pathCoords, color: Colors.green);
      case NOverlayType.multipartPathOverlay:
        return NMultipartPathOverlay(id: overlayId, paths: [
          NMultipartPath(coords: pathCoords, color: Colors.amber),
          NMultipartPath(coords: secondPathCoords, color: Colors.redAccent)
        ]);
      case NOverlayType.arrowheadPathOverlay:
        return NArrowheadPathOverlay(
            id: overlayId, coords: pathCoords, color: Colors.purple);
      case NOverlayType.locationOverlay:
        throw Exception("locationOverlay is not supported");
    }
  }

  static List<NLatLng> getHeartCoordinates(NLatLng centerPoint,
      {required double zoomLevel}) {
    final radius = 20.0 / (1 + math.exp(0.75 * (zoomLevel - 14.5))) - 1.0;
    final List<NLatLng> heartCoords = [];

    for (double angle = 0; angle <= 2 * math.pi; angle += 0.01) {
      final double x = radius * 16 * math.pow(math.sin(angle), 3);
      final double y = radius *
          (13 * math.cos(angle) -
              5 * math.cos(2 * angle) -
              2 * math.cos(3 * angle) -
              math.cos(4 * angle));
      final coord = centerPoint.offsetByMeter(northMeter: y, eastMeter: x);
      heartCoords.add(coord);
    }

    return heartCoords..add(heartCoords.first);
  }

  static String get _timeBasedId => "${DateTime.now().millisecondsSinceEpoch}";

  NOverlayMakerUtil._();
}
