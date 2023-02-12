part of flutter_naver_map_messaging;

mixin NChannelWrapper {
  MethodChannel get channel;

  Future<T?> invokeMethod<T>(String funcName, [NMessageable? arg]) {
    return channel.invokeMethod<T>(funcName, arg?.toNPayload().m);
  }

  Future<T?> invokeMethodWithList<T>(String funcName, List<NMessageable> list) {
    final payload = list.map((item) => item.toNPayload().m).toList();
    return channel.invokeMethod<T>(funcName, payload);
  }

  Future<T?> invokeMethodWithEnum<T>(
      String funcName, NMessageableForEnum? arg) {
    return channel.invokeMethod<T>(funcName, arg?.toNPayload());
  }

  Future<T?> invokeMethodWithMessageableArgs<T>(String funcName, dynamic arg) {
    return channel.invokeMethod<T>(funcName, arg);
  }
}
