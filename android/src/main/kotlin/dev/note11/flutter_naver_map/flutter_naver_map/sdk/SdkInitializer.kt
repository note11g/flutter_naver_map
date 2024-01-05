package dev.note11.flutter_naver_map.flutter_naver_map.sdk

import android.content.Context
import android.os.Build
import com.naver.maps.map.NaverMapSdk
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class SdkInitializer(
    private val context: Context,
    private val channel: MethodChannel,
) {
    init {
        channel.setMethodCallHandler(::handle)
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "initialize") {
            initialize(call.arguments.asMap(),
                onSuccess = result::success,
                onFailure = { result.error(it.errorCode, it.message, null) })
        }
    }

    private fun initialize(
        args: Map<String, Any>,
        onSuccess: (Any?) -> Unit,
        onFailure: (NaverMapSdk.AuthFailedException) -> Unit,
    ) {
        val clientId = args["clientId"]?.toString()
        val isGov = args["gov"]!!.asBoolean()
        val setAuthFailedListener = args["setAuthFailedListener"]!!.asBoolean()

        try {
            if (clientId != null) initializeMapSdk(context, clientId, isGov)
            if (setAuthFailedListener) setOnAuthFailedListener()
            val sendPayload = mapOf("androidSdkVersion" to Build.VERSION.SDK_INT)
            onSuccess(sendPayload)
        } catch (e: NaverMapSdk.AuthFailedException) {
            onFailure(e)
        }
    }

    private fun initializeMapSdk(
        context: Context,
        clientId: String,
        isGov: Boolean,
    ) = NaverMapSdk.getInstance(context).run {
        client = if (!isGov) NaverMapSdk.NaverCloudPlatformClient(clientId)
        else NaverMapSdk.NaverCloudPlatformGovClient(clientId)
    }

    private fun setOnAuthFailedListener() =
        NaverMapSdk.getInstance(context).setOnAuthFailedListener(::onAuthFailedListener)

    private fun onAuthFailedListener(ex: NaverMapSdk.AuthFailedException) {
        channel.invokeMethod(
            "onAuthFailed", mapOf(
                "code" to ex.errorCode,
                "message" to ex.message,
            )
        )
    }
}