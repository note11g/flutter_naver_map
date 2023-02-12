part of flutter_naver_map_messaging;

mixin NChannelWrapper {
  MethodChannel get channel;

  Future<T?> invokeMethod<T>(String funcName, [NMessageable? arg]) {
    return channel.invokeMethod<T>(funcName, arg?.payload);
  }

  Future<T?> invokeMethodWithList<T>(String funcName, List<NMessageable> list) {
    final payload = list.map((item) => item.payload).toList();
    return channel.invokeMethod<T>(funcName, payload);
  }
}
