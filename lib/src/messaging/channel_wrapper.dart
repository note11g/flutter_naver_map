part of "messaging.dart";

mixin NChannelWrapper {
  MethodChannel get channel;

  // optional implementation
  set channel(MethodChannel channel) {}

  // flag state
  bool isChannelInitialized = false;

  void initChannel(
    NChannel channelType, {
    required int id,
    Future<dynamic> Function(MethodCall)? handler,
  }) {
    channel = channelType._create(id)..setMethodCallHandler(handler);
    isChannelInitialized = true;
  }

  void disposeChannel() {
    if (isChannelInitialized) channel.setMethodCallHandler(null);
  }

  Future<T?> invokeMethod<T>(String funcName, [NMessageable? arg]) {
    return channel.invokeMethod<T>(funcName, arg?.payload);
  }

  Future<T?> invokeMethodWithIterable<T>(
      String funcName, Iterable<NMessageable> list) {
    final payload = list.map((item) => item.payload);
    return channel.invokeMethod<T>(funcName, payload.toList());
  }
}
