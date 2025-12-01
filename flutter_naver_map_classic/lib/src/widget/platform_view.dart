part of "../../flutter_naver_map.dart";

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
    bool? forceHybridComposition,
    bool? forceGLSurfaceView,
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
          final usingView = forceHybridComposition == true
              ? PlatformViewsService.initExpensiveAndroidView
              : PlatformViewsService.initAndroidView;

          final rawCreationParameters = creationParams.map;

          // RenderView(Impl Android Side), Display Mode
          // API 23 ~ 29, 33 ~ 34 : TextureView, Texture Layer Hybrid Composition.
          // API 30 ~ 32 : GLSurfaceView, Texture Layer Hybrid Composition.
          // related issue : https://github.com/note11g/flutter_naver_map/issues/152
          /// by default, only android 11\~12L (SDK 30\~32) using GLSurfaceView.
          if (forceGLSurfaceView != null) {
            rawCreationParameters.addAll({"glsurface": forceGLSurfaceView});
          }

          final view = usingView.call(
              id: params.id,
              viewType: viewType,
              layoutDirection: layoutDirection,
              creationParams: rawCreationParameters,
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
