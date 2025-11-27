package dev.note11.flutter_naver_map.flutter_naver_map.sdk

import android.content.Context
import android.os.Build
import com.naver.maps.map.NaverMapSdk
import com.naver.maps.map.NaverMapSdk.NcpKeyClient
import com.naver.maps.map.NaverMapSdk.OnAuthFailedListener
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asBoolean
import dev.note11.flutter_naver_map.flutter_naver_map.converter.DefaultTypeConverter.asMap
import dev.note11.flutter_naver_map.flutter_naver_map.model.exception.NFlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class SdkInitializer(
    private val context: Context,
    private val channel: MethodChannel,
) {
    init {
        channel.setMethodCallHandler(::handle)
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initializeNcp" -> initializeWithNcp(
                call.arguments.asMap(), onSuccess = result::success, onFailure = {
                    result.error(
                        if (it is NaverMapSdk.AuthFailedException) it.errorCode else it.javaClass.name,
                        it.message,
                        null
                    )
                })
            "initialize" -> initialize(
                call.arguments.asMap(),
                onSuccess = result::success,
                onFailure = { result.error(it.errorCode, it.message, null) })
            "getNativeMapSdkVersion" -> getNativeMapSdkVersion(onSuccess = result::success)
            else -> result.notImplemented()
        }
    }

    private fun initializeWithNcp(
        args: Map<String, Any>, onSuccess: (Any?) -> Unit, onFailure: (Exception) -> Unit
    ) {
        val clientId = args["clientId"]?.toString()
        val hasAuthFailedListener = args["setAuthFailedListener"]?.asBoolean() ?: false
        try {
            val sdk = NaverMapSdk.getInstance(context)
            sdk.onAuthFailedListener = OnAuthFailedListener { ex ->
                if (hasAuthFailedListener) onAuthFailedListener(ex) else onFailure(ex)
            }
            val sendPayload = mapOf("androidSdkVersion" to Build.VERSION.SDK_INT)
            if (clientId != null) sdk.client = NcpKeyClient(clientId)
            onSuccess(sendPayload)
        } catch (e: Exception) {
            onFailure(e)
        }
    }

    /// --- Legacy ---
    @Deprecated("Use initializeWithNcp instead")
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

    @Deprecated("Use initializeNcpMapSdk instead")
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

    /// --- end legacy ---

    private fun onAuthFailedListener(ex: NaverMapSdk.AuthFailedException) {
        channel.invokeMethod(
            "onAuthFailed",
            NFlutterException(code = ex.errorCode, message = ex.message).toMessageable()
        )
    }

    private fun getNativeMapSdkVersion(onSuccess: (String) -> Unit) {
        onSuccess(com.naver.maps.map.BuildConfig.VERSION_NAME)
    }
}