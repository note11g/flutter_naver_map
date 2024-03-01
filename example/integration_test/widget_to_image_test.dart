import "package:flutter/material.dart";
import "package:flutter_naver_map/src/util/widget_to_image.dart";
import "package:flutter_test/flutter_test.dart";
import "package:meta/meta.dart";

@isTestGroup
void widgetToImageTests() {
  testWidgets("NOverlayImage.fromWidget MemoryLeak test", (tester) async {
    const myAppPageKey = Key("MyApp");
    const stfulWidgetKey = Key("stfulA");
    await tester.pumpWidget(
        const _MyApp(key: myAppPageKey, stfulWidgetKey: stfulWidgetKey));

    await tester.pump();

    final stfulWidgetFinder = find.byKey(stfulWidgetKey);
    final _StFulTestWidgetState statefulWidgetState =
        tester.state(stfulWidgetFinder);

    expect(statefulWidgetState.count, 0);

    // dispose test : case normal attach to widgetTree
    final _MyAppState myAppState = tester.state(find.byKey(myAppPageKey));
    myAppState.disposeStfulTestWidget();
    await tester.pump();

    print(statefulWidgetState.mounted);
    expect(statefulWidgetState.mounted, false); // : isDisposed

    // dispose test : case attach to NOverlayImage.fromWidget inner canvas (virtual canvas)
    final buildContext = myAppState.context;
    final widgetToImageBytes = await WidgetToImageUtil.widgetToImageByte(
        const StFulTestWidget(),
        size: const Size(40, 80),
        context: buildContext);
    print(widgetToImageBytes.length);
    expect(widgetToImageBytes.length > 100, true); // successful created test

    print("test end");
  });
}

class _MyApp extends StatefulWidget {
  final Key stfulWidgetKey;

  const _MyApp({super.key, required this.stfulWidgetKey});

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: disposeSwitchFlag
          ? const SizedBox()
          : StFulTestWidget(key: widget.stfulWidgetKey),
    ));
  }

  bool disposeSwitchFlag = false;

  void disposeStfulTestWidget() {
    disposeSwitchFlag = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    print("_MyApp dispose");
  }
}

class StFulTestWidget extends StatefulWidget {
  const StFulTestWidget({super.key});

  @override
  State<StFulTestWidget> createState() => _StFulTestWidgetState();
}

class _StFulTestWidgetState extends State<StFulTestWidget> {
  final count = 0;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void initState() {
    print("initState: $this");
    super.initState();
  }

  @override
  void dispose() {
    print("dispose: $this");
    super.dispose();
  }
}
