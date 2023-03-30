part of flutter_naver_map_messaging;

mixin NChannelWrapper {
  MethodChannel get channel;

  // optional implementation
  set channel(MethodChannel channel) {}

  void createChannel(
    NChannel channelType, {
    required int id,
    Future<dynamic> Function(MethodCall)? handler,
  }) {
    channel = channelType._create(id)..setMethodCallHandler(handler);
  }

  void disposeChannel() {
    channel.setMethodCallHandler(null);
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
