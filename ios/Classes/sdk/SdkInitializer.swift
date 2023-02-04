import NMapsMap

class SdkInitializer: NSObject, NMFAuthManagerDelegate {
    let channel: FlutterMethodChannel

    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()

        channel.setMethodCallHandler(handle(_:result:))
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "initialize") {
            initialize(asDict(call.arguments!), onSuccess: result) { e in
                result(FlutterError(code: "", message: e.localizedDescription, details: nil))
            }
        }
    }

    private func initialize(_ args: Dictionary<String, Any>, onSuccess: (Any?) -> Void, onFailure: (Error) -> Void) {
        let clientId = castOrNull(args["clientId"], caster: asString)
        let isGov = asBool(args["gov"]!)
        let setAuthFailedListener = asBool(args["setAuthFailedListener"]!)

        if let clientId {
            initializeMapSdk(clientId: clientId, isGov: isGov)
        }
        if (setAuthFailedListener) {
            setOnAuthFailedListener()
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
        print("네이버맵 Auth State : \(state), e: \(String(describing: error))")
        if let error {
            channel.invokeMethod("onAuthFailed", arguments: [
                "code": String(error._code),
                "message": error.localizedDescription
            ])
        }
    }
}
