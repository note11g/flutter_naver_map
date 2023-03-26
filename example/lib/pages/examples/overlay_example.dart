import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../design/custom_widget.dart';

class NOverlayExample extends StatefulWidget {
  final bool isClosed;
  final NaverMapController mapController;

  const NOverlayExample({
    Key? key,
    required this.mapController,
    required this.isClosed,
  }) : super(key: key);

  @override
  State<NOverlayExample> createState() => _NOverlayExampleState();
}

class _NOverlayExampleState extends State<NOverlayExample> {
  NOverlayType willCreateOverlayType = NOverlayType.marker;
  NAddableOverlay? willCreateOverlay;

  NaverMapController get mapController => widget.mapController;

  void attachOverlay() async {
    final point = await mapController.getCameraPosition().then((p) => p.target);
    final marker = NMarker(id: "1", position: point);
    marker.setOnTapListener((m) {
      print(m);
      mapController.latLngToScreenLocation(m.position).then((point) {
        print("화면상 위치 : $point");
        addFlutterFloatingOverlay(point);
      });
    });
    mapController.addOverlay(marker);
  }

  OverlayEntry? entry;

  void addFlutterFloatingOverlay(NPoint point) {
    // final p;
    final screenSize = MediaQuery.of(context).size;
    final x = (point.x) - 12;

    entry = OverlayEntry(builder: (context) {
      return Positioned.fill(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                removeFlutterFloatingOverlay();
              },
              child: Stack(children: [
                Positioned(
                    left: x,
                    top: point.y,
                    child: Balloon(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text("마커를 클릭하셨습니다."),
                          Text("이 오버레이는 Flutter 위젯으로 생성되었습니다."),
                        ],
                      ),
                      //     Material(
                      //       borderRadius: BorderRadius.circular(8),
                      //       color: getColorTheme(context).background,
                      //       child: Container(
                      //         padding: const EdgeInsets.all(8),
                      //   child: Column(
                      //     children: [
                      //       Text("마커를 클릭하셨습니다."),
                      //       Text("이 오버레이는 Flutter 위젯으로 생성되었습니다."),
                      //     ],
                      //   ),
                      // ),
                    )),
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
          description: "오버레이를 클릭하면 속성을 변경할 수도 있어요.",
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
          text: "${getOverlayKoreanName(willCreateOverlayType)} 생성",
          margin: const EdgeInsets.fromLTRB(24, 12, 24, 8),
          action: attachOverlay),
      if (!widget.isClosed)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(children: [
            Expanded(
              child: SimpleButton(
                  text: "${getOverlayKoreanName(willCreateOverlayType)}만 모두 지우기",
                  color: Colors.orange,
                  margin: EdgeInsets.zero,
                  action: () =>
                      mapController.clearOverlays(type: willCreateOverlayType)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SimpleButton(
                  text: "모두 지우기",
                  color: Colors.red,
                  margin: EdgeInsets.zero,
                  action: () => mapController.clearOverlays()),
            ),
          ]),
        ),
      const BottomPadding(),
    ]);
  }

  List<Widget> markerOptions() => [];

  String get timeBasedId => "${DateTime.now().millisecondsSinceEpoch}";
  static const mockLatLng = NLatLng(0, 0);
  static const mockLatLngBounds =
      NLatLngBounds(southWest: NLatLng(0, 0), northEast: NLatLng(0, 0));
  static const assetImage =
      NOverlayImage.fromAssetImage('assets/images/overlay.png'); // todo

  String getOverlayKoreanName(NOverlayType type) {
    switch (type) {
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
        throw Exception("locationOverlay is not supported");
    }
  }
}
