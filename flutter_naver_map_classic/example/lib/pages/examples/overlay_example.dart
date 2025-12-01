import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../design/theme.dart';
import '../../util/overlay_portal_util.dart';
import '../../util/string_util.dart';
import '../../design/custom_widget.dart';
import '../others/example_page_data.dart';

class NOverlayExample extends StatefulWidget {
  static const ExamplePageData pageData = ExamplePageData(
    title: "오버레이 추가 / 제거",
    description: "마커/경로/도형 등을 띄워봐요",
    icon: Icons.add_location_alt_rounded,
    route: "/overlay",
  );

  final NInfoOverlayPortalController nOverlayInfoOverlayPortalController;
  final Stream<NCameraUpdateReason> onCameraChangeStream;
  final NaverMapController mapController;

  const NOverlayExample({
    Key? key,
    required this.mapController,
    required this.nOverlayInfoOverlayPortalController,
    required this.onCameraChangeStream,
  }) : super(key: key);

  @override
  State<NOverlayExample> createState() => _NOverlayExampleState();
}

class _NOverlayExampleState extends State<NOverlayExample> {
  NOverlayType willCreateOverlayType = NOverlayType.marker;
  NAddableOverlay? willCreateOverlay;

  NaverMapController get mapController => widget.mapController;

  void attachOverlay() async {
    final cameraPosition = mapController.nowCameraPosition;
    final overlay = NOverlayMakerUtil.makeOverlay(
        type: willCreateOverlayType, cameraPosition: cameraPosition);
    final latLng = cameraPosition.target;
    for (final o in overlay) {
      final position = o is NClusterableMarker ? o.position : latLng;
      o.setOnTapListener((overlay) {
        mapController.latLngToScreenLocation(position).then((point) =>
            addFlutterFloatingOverlay(
                point: point, overlay: overlay, latLng: latLng));
      });
    }
    mapController.addOverlayAll(overlay.toSet());
  }

  void addFlutterFloatingOverlay({
    required NOverlay<dynamic> overlay,
    required NPoint point,
    required NLatLng latLng,
  }) {
    widget.nOverlayInfoOverlayPortalController.openWithWidget(
        screenPointStream: widget.onCameraChangeStream.asyncMap((event) async =>
            await mapController.latLngToScreenLocation(latLng)),
        builder: (context, mapController, controller, back) {
          Widget header() => Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text(overlay.runtimeType.toString(),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: getTextTheme(context).titleSmall)),
                    InkWell(
                        onTap: back, child: const Icon(Icons.close_rounded)),
                  ]));

          return Column(children: [
            header(),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                  Text(
                      overlay.info.id == overlay.info.parseIdAsTimeString()
                          ? "id: ${overlay.info.id}"
                          : "${overlay.info.parseIdAsTimeString().replaceFirst(":", "시 ").replaceFirst(":", "분 ")}초에 생성됨",
                      style: getTextTheme(context).bodySmall),
                  Text("${latLng.toShortString()}에 위치함",
                      style: getTextTheme(context).bodySmall),
                  const SizedBox(height: 4),
                  Text(
                      "zIndex: ${overlay.zIndex} (global: ${overlay.globalZIndex})\n"
                      "${overlay.minZoom} ${overlay.isMinZoomInclusive ? "≤" : "<"}"
                      " [보이는 줌 범위] ${overlay.isMaxZoomInclusive ? "≤" : "<"} ${overlay.maxZoom}\n",
                      style: getTextTheme(context).bodySmall),
                ])),
            SmallButton("오버레이 지우기",
                icon: Icons.delete_forever_outlined,
                radius: 0,
                color: Colors.red.shade600, onTap: () {
              mapController.deleteOverlay(overlay.info);
              controller.hide();
            }),
          ]);
        },
        screenPoint: point,
        overlay: overlay);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
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
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Row(children: [
              Expanded(
                  child: SimpleButton(
                      text: "${willCreateOverlayType.koreanName}만 모두 지우기",
                      color: Colors.orange,
                      margin: EdgeInsets.zero,
                      action: () => mapController.clearOverlays(
                          type: willCreateOverlayType))),
              const SizedBox(width: 12),
              Expanded(
                  child: SimpleButton(
                      text: "모두 지우기",
                      color: Colors.red,
                      margin: EdgeInsets.zero,
                      action: () => mapController.clearOverlays())),
            ])),
        const BottomPadding(),
      ]),
    );
  }
}

extension NOverlayTypeExtension on NOverlayType {
  String get koreanName {
    return switch (this) {
      NOverlayType.marker => "마커",
      NOverlayType.infoWindow => "정보창",
      NOverlayType.circleOverlay => "원 오버레이",
      NOverlayType.groundOverlay => "지상 오버레이",
      NOverlayType.polygonOverlay => "다각형 오버레이",
      NOverlayType.polylineOverlay => "선 오버레이",
      NOverlayType.pathOverlay => "경로 오버레이",
      NOverlayType.multipartPathOverlay => "경로(멀티파트) 오버레이",
      NOverlayType.arrowheadPathOverlay => "경로(화살표) 오버레이",
      NOverlayType.locationOverlay => "위치 오버레이",
      NOverlayType.clusterableMarker => "클러스터블 마커 25개"
    };
  }
}

extension NOverlayInfoExtension on NOverlayInfo {
  String parseIdAsTimeString() {
    final idForCreatedAt = int.tryParse(id);
    if (idForCreatedAt == null) return id;
    try {
      return DateTime.fromMillisecondsSinceEpoch(idForCreatedAt)
          .toIso8601String()
          .split("T")
          .last;
    } catch (_) {
      return id;
    }
  }
}

class NOverlayMakerUtil {
  static List<NAddableOverlay> makeOverlay({
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
        return [NMarker(id: overlayId, position: point)];
      case NOverlayType.infoWindow:
        return [
          NInfoWindow.onMap(id: overlayId, position: point, text: '인포 윈도우')
        ];
      case NOverlayType.circleOverlay:
        return [
          NCircleOverlay(
              id: overlayId,
              center: point,
              color: Colors.green.withOpacity(0.3),
              radius: 100,
              outlineColor: Colors.greenAccent,
              outlineWidth: 2)
        ];
      case NOverlayType.groundOverlay:
        final bounds = NLatLngBounds(
            southWest: point,
            northEast: point.offsetByMeter(northMeter: 422, eastMeter: 818));
        print(bounds);
        const img = NOverlayImage.fromAssetImage('assets/ground_img.png');
        return [
          NGroundOverlay(id: overlayId, bounds: bounds, image: img, alpha: 1)
        ];
      case NOverlayType.polygonOverlay:
        return [
          NPolygonOverlay(
              id: overlayId,
              coords: heartCoords,
              color: Colors.redAccent.withOpacity(0.5))
        ];
      case NOverlayType.polylineOverlay:
        return [
          NPolylineOverlay(
              id: overlayId, coords: heartCoords, color: Colors.red)
        ];
      case NOverlayType.pathOverlay:
        return [
          NPathOverlay(id: overlayId, coords: pathCoords, color: Colors.green)
        ];
      case NOverlayType.multipartPathOverlay:
        return [
          NMultipartPathOverlay(id: overlayId, paths: [
            NMultipartPath(coords: pathCoords, color: Colors.amber),
            NMultipartPath(coords: secondPathCoords, color: Colors.redAccent)
          ])
        ];
      case NOverlayType.arrowheadPathOverlay:
        return [
          NArrowheadPathOverlay(
              id: overlayId, coords: pathCoords, color: Colors.purple)
        ];
      case NOverlayType.locationOverlay:
        throw Exception("locationOverlay is not supported");
      case NOverlayType.clusterableMarker:
        return [
          for (int i = 0; i < 5; i++)
            for (int j = 0, c = (i * 5 + 1); j < 5; j++, c++)
              NClusterableMarker(
                id: "${overlayId}_$c",
                position:
                    point.offsetByMeter(northMeter: i * -80, eastMeter: j * 80),
                caption: NOverlayCaption(text: "$c"),
                iconTintColor: Colors.blueAccent,
              )
        ];
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
