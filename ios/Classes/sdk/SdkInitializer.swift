import NMapsMap

internal class SdkInitializer: NSObject, NMFAuthManagerDelegate {
    let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()

        channel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "initialize") {
            initialize(asDict(call.arguments!), onSuccess: result)
        }
    }

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

    private func setOnAuthFailedListener() {
        NMFAuthManager.shared().delegate = self
    }

    func authorized(_ state: NMFAuthState, error: Error?) {
        if let error = error {
            channel.invokeMethod("onAuthFailed", arguments: [
                "code": String(error._code),
                "message": error.localizedDescription
            ])
        }
    }
}
