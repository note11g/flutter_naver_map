import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/utils/example_base.dart';
import 'package:flutter_naver_map_example/pages/examples/overlay_example.dart';
import 'package:flutter_naver_map_example/util/alert_util.dart';

import '../../design/theme.dart';

class NaverMapPickExample extends ExampleBasePage {
  final Stream<void> onCameraChangeStream;
  final Point<double> mapEndPoint;

  const NaverMapPickExample({
    super.key,
    required super.mapController,
    required super.canScroll,
    required this.mapEndPoint,
    required this.onCameraChangeStream,
  });

  @override
  State<NaverMapPickExample> createState() => _NaverMapControllerExampleState();
}

class _NaverMapControllerExampleState extends State<NaverMapPickExample> {
  final List<NPickableInfo> pickables = [];

  void onCameraChange() async {
    final p = widget.mapEndPoint;
    final center = NPoint(p.x / 2, p.y / 2);
    final radius = max(p.x, p.y);
    final pickables = await _mapController.pickAll(center, radius: radius);
    this.pickables
      ..clear()
      ..addAll(pickables);
    setState(() {});
  }

  Widget _nowCameraPositionWidget() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
      final idForCreatedAt = int.tryParse(info.id);
      description = idForCreatedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(idForCreatedAt)
              .toIso8601String()
              .split("T")
              .last
          : info.id;
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
    return Expanded(child: _nowCameraPositionWidget());
  }

  // --- worker ---

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription<void>? onCameraChangeStreamSubscription;

  @override
  void initState() {
    super.initState();
    onCameraChange();
    onCameraChangeStreamSubscription =
        widget.onCameraChangeStream.listen((_) => onCameraChange());
  }

  @override
  void dispose() {
    onCameraChangeStreamSubscription?.cancel();
    onCameraChangeStreamSubscription = null;
    super.dispose();
  }
}
