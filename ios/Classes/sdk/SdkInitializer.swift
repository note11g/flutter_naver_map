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
        let clientId = asStringWithNil(args["clientId"])
        let isGov = asBool(args["gov"]!)
        let setAuthFailedListener = asBool(args["setAuthFailedListener"]!)

        if (clientId != nil) {
            initializeMapSdk(clientId: clientId!, isGov: isGov)
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
        if (error != nil) {
            channel.invokeMethod("onAuthFailed", arguments: [
                "code": "",
                "message": error!.localizedDescription
            ])
        }
    }
}
