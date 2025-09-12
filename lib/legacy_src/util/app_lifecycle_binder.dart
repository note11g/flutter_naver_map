import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

@internal
mixin AppLifeCycleBinder {
  _AppLifeCycleBinderHelper? _helper;

  void bindAppLifecycleChange() {
    _helper = _AppLifeCycleBinderHelper(
        didChangeAppLifecycleStateCallback: didChangeAppLifecycleState);
    WidgetsBinding.instance.addObserver(_helper!);
  }

  void unbindAppLifecycleChange() {
    if (_helper == null) return;
    WidgetsBinding.instance.removeObserver(_helper!);
    _helper = null;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {}
}

class _AppLifeCycleBinderHelper with WidgetsBindingObserver {
  final Function(AppLifecycleState state) didChangeAppLifecycleStateCallback;

  _AppLifeCycleBinderHelper({
    required this.didChangeAppLifecycleStateCallback,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleStateCallback(state);
  }
}
