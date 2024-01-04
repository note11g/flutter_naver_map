import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map_example/design/custom_widget.dart';
import 'package:flutter_naver_map_example/pages/example_base.dart';
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
    print("w/h: ${widget.mapEndPoint}");
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const InnerSimpleTitle(
              title: "지도에 표시되는 심볼 및 오버레이들",
              description: "controller.pickAll(NPoint, radius)",
              direction: Axis.vertical),
          const SizedBox(height: 8),
          Expanded(
              child: ListView(
                  children: pickables.map((e) => _pickableItem(e)).toList())),
        ]));
  }

  Widget _pickableItem(NPickableInfo info) {
    if (info is NOverlayInfo) {
      return Text(info.toString());
    } else if (info is NSymbolInfo) {
      return Text(info.caption);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _nowCameraPositionWidget());
  }

  // --- worker ---

  NaverMapController get _mapController => widget.mapController;
  StreamSubscription? onCameraChangeStreamSubscription;

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
    super.dispose();
  }
}
