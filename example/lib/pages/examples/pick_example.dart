import 'dart:async';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../design/custom_widget.dart';
import '../others/example_page_data.dart';
import 'overlay_example.dart';

class NaverMapPickExample extends StatefulWidget {
  static const ExamplePageData pageData = ExamplePageData(
    title: "주변 Pickable 보기",
    description: "주변 심볼, 오버레이를 찾아봐요",
    icon: Icons.domain_rounded,
    route: "/pickable",
  );

  final Stream<NCameraUpdateReason> onCameraChangeStream;
  final NaverMapController mapController;

  const NaverMapPickExample({
    super.key,
    required this.mapController,
    required this.onCameraChangeStream,
  });

  @override
  State<NaverMapPickExample> createState() => _NaverMapControllerExampleState();
}

class _NaverMapControllerExampleState extends State<NaverMapPickExample> {
  final List<NPickableInfo> pickables = [];

  void onCameraChange() async {
    if (screenSize == null) return;

    final nowLocation = _mapController.nowCameraPosition.target;
    final center = await _mapController.latLngToScreenLocation(nowLocation);

    final isTrustWithErrorMargin =
        (center.x - screenSize!.width / 2).abs() < 1.0;
    if (!isTrustWithErrorMargin) return;

    final pickables =
        await _mapController.pickAll(center, radius: max(center.x, center.y));
    this.pickables
      ..clear()
      ..addAll(pickables);
    setState(() {});
  }

  Widget _nowCameraPositionWidget() {
    return Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const InnerSimpleTitle(
              title: "지도에 표시되는 심볼 및 오버레이들",
              description: "controller.pickAll(NPoint, radius)",
              direction: Axis.vertical),
          const SizedBox(height: 8),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: 8 + MediaQuery.paddingOf(context).bottom),
            child: HalfActionButtonGrid(
                buttons: pickables.map((e) => _pickableItem(e)).toList()),
          )),
        ]));
  }

  Widget _pickableItem(NPickableInfo info) {
    final String title;
    final String description;
    final IconData icon;
    final void Function() action;

    if (info is NOverlayInfo) {
      title = info.type.koreanName;
      description = info.parseIdAsTimeString();

      icon = switch (info.type) {
        NOverlayType.marker => Icons.place_rounded,
        NOverlayType.infoWindow => Icons.chat_bubble_rounded,
        NOverlayType.circleOverlay => Icons.circle_outlined,
        NOverlayType.groundOverlay => Icons.square,
        NOverlayType.polygonOverlay => Icons.star,
        NOverlayType.polylineOverlay => Icons.polyline_rounded,
        NOverlayType.pathOverlay => Icons.route_rounded,
        NOverlayType.multipartPathOverlay => Icons.route_sharp,
        NOverlayType.arrowheadPathOverlay => Icons.arrow_right_alt_rounded,
        NOverlayType.locationOverlay => Icons.my_location_rounded,
        NOverlayType.clusterableMarker => Icons.share_location_rounded,
      };
      action = () {};
    } else if (info is NSymbolInfo) {
      title = info.caption.replaceAll("\n", " ");
      description =
          "${info.position.latitude.toStringAsFixed(5)}, ${info.position.longitude.toStringAsFixed(5)}";
      icon = Icons.apartment_rounded;
      action = () => _mapController
          .updateCamera(NCameraUpdate.scrollAndZoomTo(target: info.position));
    } else {
      return const SizedBox();
    }

    return HalfActionButton(
        action: action, icon: icon, title: title, description: description);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.sizeOf(context);
    return _nowCameraPositionWidget();
  }

  // --- worker ---

  Size? screenSize;

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription<NCameraUpdateReason>? onCameraChangeStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // need to cameraChange when first screenSize initialized.
      onCameraChange();
      onCameraChangeStreamSubscription =
          widget.onCameraChangeStream.listen((_) => onCameraChange());
    });
  }

  @override
  void dispose() {
    onCameraChangeStreamSubscription?.cancel();
    onCameraChangeStreamSubscription = null;
    super.dispose();
  }
}
