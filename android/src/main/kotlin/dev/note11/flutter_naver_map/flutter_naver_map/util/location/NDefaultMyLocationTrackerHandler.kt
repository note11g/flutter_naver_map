package dev.note11.flutter_naver_map.flutter_naver_map.util.location

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal interface NDefaultMyLocationTrackerHandler {
    fun handle(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
        "requestLocationPermission" -> requestLocationPermission(result)
        "getCurrentPositionOnce" -> getCurrentPositionOnce(result)
        "cancelAllWaitingGetCurrentPositionOnceTask" -> cancelAllWaitingGetCurrentPositionOnceTask()
        else -> result.notImplemented()
    }

    fun requestLocationPermission(result: MethodChannel.Result)

    fun getCurrentPositionOnce(result: MethodChannel.Result)

    fun cancelAllWaitingGetCurrentPositionOnceTask()
}
