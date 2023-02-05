import NMapsMap

struct NOverlayImage {
    let path: String
    let mode: NOverlayImageMode

    var overlayImage: NMFOverlayImage {
        get {
            switch mode {
            case .file, .temp, .widget: return makeOverlayImageWithPath()
            case .asset: return makeOverlayImageWithAssetPath()
            }
        }
    }

    private func makeOverlayImageWithPath() -> NMFOverlayImage {
        let uiImage = UIImage(contentsOfFile: path)
        let img = NMFOverlayImage(image: uiImage!)
        return img
    }

    private func makeOverlayImageWithAssetPath() -> NMFOverlayImage {
        let assetPath = SwiftFlutterNaverMapPlugin.getAssets(path: path)
        let img = NMFOverlayImage(name: assetPath)
        return img
    }

    func toDict() -> Dictionary<String, Any> {
        [
            "path": path,
            "mode": mode.rawValue
        ]
    }

    static func fromDict(_ v: Any) -> NOverlayImage {
        let d = asDict(v)
        return NOverlayImage(
                path: asString(d["path"]!),
                mode: NOverlayImageMode(rawValue: asString(d["mode"]!))!
        )
    }

    static let none = NOverlayImage(path: "", mode: .temp)
}