import "dart:typed_data" show Uint8List;
import "dart:ui" show ImageByteFormat;

import "package:flutter/rendering.dart"
    show
        PipelineOwner,
        RenderPositionedBox,
        RenderRepaintBoundary,
        RenderView,
        ViewConfiguration;
import "package:flutter/widgets.dart";

class WidgetToImageUtil {
  static Widget _setSizeAndTextDirection(Widget widget, Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: widget,
      ),
    );
  }

  static Future<Uint8List> widgetToImageByte(
    Widget widget, {
    required Size size,
    required double pixelRatio,
    required BuildContext context,
  }) async {
    final renderBox = RenderRepaintBoundary();
    final renderView = RenderView(
        view: View.of(context),
        configuration:
            ViewConfiguration(size: size, devicePixelRatio: pixelRatio),
        child:
            RenderPositionedBox(alignment: Alignment.center, child: renderBox));

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();

    final buildOwner = BuildOwner(focusManager: FocusManager());
    final renderToWidget = RenderObjectToWidgetAdapter(
            container: renderBox, child: _setSizeAndTextDirection(widget, size))
        .attachToRenderTree(buildOwner);
    buildOwner
      ..buildScope(renderToWidget)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final image = await renderBox.toImage(pixelRatio: pixelRatio);
    return image
        .toByteData(format: ImageByteFormat.png)
        .then((b) => b!.buffer.asUint8List());
  }

  WidgetToImageUtil._();
}
