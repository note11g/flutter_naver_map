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
          // ExpensiveAndroidView (Hybrid composition) :
          // 1. render error (1px * 1px smaller than flutter view) : https://github.com/flutter/flutter/issues/118544
          // 2. android 5.0 (API 21) ~ android 7.1 (API 25) render issue (GLSurfaceView rendered under flutter view)
          // TextureSurfaceComposition (SurfaceAndroidView) :
          // 1. can't serve touch gesture NaverLogoButton and More Contents...

          // initAndroidView : auto detect.
          // but Android 10 or higher, use TextureSurfaceComposition.

          const hybridView = PlatformViewsService.initExpensiveAndroidView;
          const autoView = PlatformViewsService.initAndroidView;

          // android 10 (API 29) or higher, use Hybrid Composition.
          // else, use Auto Detected Composition. (99% use Virtual Display Composition)
          final usingView = androidSdkVersion! >= 29 ? hybridView : autoView;

          final view = usingView.call(
              id: params.id,
              viewType: viewType,
              layoutDirection: layoutDirection,
              creationParams: creationParams.json,
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
        creationParams: creationParams.json,
        creationParamsCodec: creationParamsCodec,
        onPlatformViewCreated: onPlatformViewCreated,
      );
    } else {
      throw PlatformException(code: "unsupportedPlatform");
    }
  }
}
