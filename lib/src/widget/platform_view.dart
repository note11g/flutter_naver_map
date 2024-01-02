part of flutter_naver_map;

class _PlatformViewCreator {
  static StatefulWidget createPlatformView({
    required String viewType,
    TextDirection layoutDirection = TextDirection.ltr,
    required Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
    PlatformViewHitTestBehavior hitTestBehavior =
        PlatformViewHitTestBehavior.opaque,
    required NPayload creationParams,
    MessageCodec<dynamic> creationParamsCodec = const StandardMessageCodec(),
    required void Function(int id) onPlatformViewCreated,
    required int? androidSdkVersion,
  }) {
    if (Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (context, controller) => AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: gestureRecognizers,
          hitTestBehavior: hitTestBehavior,
        ),
        onCreatePlatformView: (params) {
          // issues
          // 1. android 5.0 (API 21) ~ android 7.1 (API 25) render issue (GLSurfaceView rendered under flutter view)
          // -> ExpensiveAndroidView, TextureSurfaceComposition (SurfaceAndroidView).
          // 2. "Unexpected platform view context for view ID 0;" issue. (+ minimum API 23)
          // -> AndroidView (virtual display)

          // initAndroidView : auto detect.
          // but Android 10 or higher, use TextureSurfaceComposition.

          const hybridView = PlatformViewsService.initExpensiveAndroidView;
          // const autoView = PlatformViewsService.initAndroidView;
          const autoView = PlatformViewsService.initSurfaceAndroidView;

          final usingView = androidSdkVersion! >= 26 ? hybridView : autoView;

          final view = usingView.call(
              id: params.id,
              viewType: viewType,
              layoutDirection: layoutDirection,
              creationParams: creationParams.map,
              creationParamsCodec: creationParamsCodec,
              onFocus: () => params.onFocusChanged(true));

          view.addOnPlatformViewCreatedListener((id) {
            params.onPlatformViewCreated(id);
            onPlatformViewCreated(id);
          });

          return view..create();
        },
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: layoutDirection,
        gestureRecognizers: gestureRecognizers,
        hitTestBehavior: hitTestBehavior,
        creationParams: creationParams.map,
        creationParamsCodec: creationParamsCodec,
        onPlatformViewCreated: onPlatformViewCreated,
      );
    } else {
      throw PlatformException(code: "unsupportedPlatform");
    }
  }
}
