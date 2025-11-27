import NMapsMap
import Flutter

internal class SdkInitializer: NSObject, NMFAuthManagerDelegate {
    let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()

        channel.setMethodCallHandler(handle)
    }
    
    deinit {
        channel.setMethodCallHandler(nil)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initializeNcp":
            initializeWithNcp(asDict(call.arguments!), onSuccess: result)
            break
        case "initialize":
            initialize(asDict(call.arguments!), onSuccess: result)
            break
        case "getNativeMapSdkVersion":
            getNativeMapSdkVersion(onSuccess: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeWithNcp(_ args: Dictionary<String, Any>, onSuccess: (Any?) -> Void) {
        let clientId = castOrNull(args["clientId"], caster: asString)
        
        let hasAuthFailedListener = asBool(args["setAuthFailedListener"]!)
        if hasAuthFailedListener { setOnAuthFailedListener() }
        
        let sdk = NMFAuthManager.shared()
        if let clientId = clientId { sdk.ncpKeyId = clientId }
        
        onSuccess(nil)
    }
    
    // MARK: Legacy -----

    private func initialize(_ args: Dictionary<String, Any>, onSuccess: (Any?) -> Void) {
        let clientId = castOrNull(args["clientId"], caster: asString)
        let isGov = asBool(args["gov"]!)
        let setAuthFailedListener = asBool(args["setAuthFailedListener"]!)

        if setAuthFailedListener {
            setOnAuthFailedListener()
        }
        if let clientId = clientId {
            initializeMapSdk(clientId: clientId, isGov: isGov)
        }
        onSuccess(nil)
    }

    private func initializeMapSdk(clientId: String, isGov: Bool) {
        let nAuthManager = NMFAuthManager.shared()
        if (!isGov) {
            nAuthManager.clientId = clientId
        } else {
            nAuthManager.govClientId = clientId
        }
    }
    
    // MARK: End Legacy -----
    
    private func getNativeMapSdkVersion(onSuccess: (Any?) -> Void) {
        onSuccess(Bundle.naverMapFrameworkVersion())
    }

    private func setOnAuthFailedListener() {
        NMFAuthManager.shared().delegate = self
    }

    func authorized(_ state: NMFAuthState, error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.channel.invokeMethod("onAuthFailed", arguments: NFlutterException(error: error).toMessageable())
            }
        }
    }
}
