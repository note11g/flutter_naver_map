import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import "package:get_it/get_it.dart";
import 'package:go_router/go_router.dart';

import '../../main.dart' show FNMapPage;
import '../examples/camera_example.dart';
import '../examples/controller_example.dart';
import '../examples/options_example.dart';
import '../examples/overlay_example.dart';
import '../examples/pick_example.dart';
import 'example_bottom_main.dart';
import 'example_page_data.dart';
import 'new_window_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final bottomRouteObserver = CommonRouteObserver();
final sharedOptionState = StreamController<NaverMapViewOptions>.broadcast()
  ..add(const NaverMapViewOptions());

final goRouter =
    GoRouter(initialLocation: "/", navigatorKey: _rootNavigatorKey, routes: [
  ShellRoute(
      navigatorKey: shellNavigatorKey,
      observers: [bottomRouteObserver],
      builder: (context, state, child) => FNMapPage(
          bottomSheetPage: child,
          sharedMapViewOptionChangeStream: sharedOptionState.stream,
          pageObserveStream: bottomRouteObserver.pageDataStream),
      routes: [
        GoRoute(
            path: "/",
            builder: (context, state) =>
                const ExampleMain(pages: ExamplePageList.all)),
        GoRoute(
            path: NaverMapViewOptionsExample.pageData.route!,
            builder: (context, state) => NaverMapViewOptionsExample(
                sharedMapViewOptionChangeState: sharedOptionState,
                canScroll: true)),
        GoRoute(
            path: NOverlayExample.pageData.route!,
            builder: (context, state) => NOverlayExample(
                onCameraChangeStream: GetIt.I.get(),
                mapController: GetIt.I.get(),
                nOverlayInfoOverlayPortalController: GetIt.I.get())),
        GoRoute(
            path: CameraUpdateExample.pageData.route!,
            builder: (context, state) => CameraUpdateExample(
                mapController: GetIt.I.get(),
                onCameraChangeStream: GetIt.I.get())),
        GoRoute(
            path: NaverMapPickExample.pageData.route!,
            builder: (context, state) => NaverMapPickExample(
                mapController: GetIt.I.get(),
                onCameraChangeStream: GetIt.I.get())),
        GoRoute(
            path: NaverMapControllerExample.pageData.route!,
            builder: (context, state) {
              return NaverMapControllerExample(
                  mapController: GetIt.I.get(),
                  onCameraChangeStream: GetIt.I.get());
            }),
      ]),
  GoRoute(
    path: NewWindowTestPage.pageData.route!,
    builder: (context, state) => const NewWindowTestPage(),
  ),
]);

class CommonRouteObserver extends NavigatorObserver {
  Stream<String> get pathStream => _streamController.stream;

  Stream<ExamplePageData?> get pageDataStream =>
      pathStream.map((path) => ExamplePageList.findPageByPath(path));

  final _streamController = StreamController<String>.broadcast();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final nowRoute = route.settings.name;
    if (nowRoute != null) _streamController.add(nowRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _streamController.add(previousRoute?.settings.name ?? "/");
  }
}

interface class ExamplePageList {
  static const all = [
    NaverMapViewOptionsExample.pageData,
    NOverlayExample.pageData,
    CameraUpdateExample.pageData,
    NaverMapPickExample.pageData,
    NaverMapControllerExample.pageData,
    NewWindowTestPage.pageData,
  ];

  static ExamplePageData? findPageByPath(String path) {
    if (path == "/") return null;
    for (final page in all) {
      if (page.route == path) return page;
    }
    return null;
  }
}
