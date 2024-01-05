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
          // RenderView(Impl Android Side), Display Mode
          // API 23 ~ 29 : TextureView, Texture Layer Hybrid Composition.
          // API 30 ~ : GLSurfaceView, Hybrid Composition (TLHC cause issue: flutter#98865)

          final usingView = androidSdkVersion! <= 29
              ? PlatformViewsService.initAndroidView
              : PlatformViewsService.initExpensiveAndroidView;

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
