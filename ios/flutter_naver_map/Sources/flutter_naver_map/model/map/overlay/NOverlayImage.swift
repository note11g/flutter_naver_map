import NMapsMap

internal struct NOverlayImage {
    let path: String
    let mode: NOverlayImageMode

    var overlayImage: NMFOverlayImage {
        switch mode {
        case .file, .temp, .widget: return makeOverlayImageWithPath()
        case .asset: return makeOverlayImageWithAssetPath()
        }
    }

    private func makeOverlayImageWithPath() -> NMFOverlayImage {
        guard let image = loadScaledImage(path) else { return Self.fallbackImage(path) }
        return NMFOverlayImage(image: image)
    }
    
    private func makeOverlayImageWithAssetPath() -> NMFOverlayImage {
        let key = SwiftFlutterNaverMapPlugin.getAssets(path: path)
        let assetPath = Bundle.main.path(forResource: key, ofType: nil) ?? ""
        guard let image = loadScaledImage(assetPath) else { return Self.fallbackImage(path) }
        return NMFOverlayImage(image: image, reuseIdentifier: assetPath)
    }

    private func loadScaledImage(_ filePath: String) -> UIImage? {
        guard let data = UIImage(contentsOfFile: filePath)?.pngData() else { return nil }
        return UIImage(data: data, scale: DisplayUtil.scale)
    }

    // The image file can disappear or be empty at runtime (#251); log instead of crashing.
    private static func fallbackImage(_ path: String) -> NMFOverlayImage {
        NSLog("[flutter_naver_map] Failed to load overlay image: %@", path)
        let empty = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        return NMFOverlayImage(image: empty)
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "path": path,
            "mode": mode.rawValue
        ]
    }

    static func fromMessageable(_ v: Any) -> NOverlayImage {
        let d = asDict(v)
        return NOverlayImage(
                path: asString(d["path"]!),
                mode: NOverlayImageMode(rawValue: asString(d["mode"]!))!
        )
    }

    static let none = NOverlayImage(path: "", mode: .temp)
}
