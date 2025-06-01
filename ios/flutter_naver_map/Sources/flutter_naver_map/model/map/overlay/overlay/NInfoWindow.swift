import NMapsMap

internal struct NInfoWindow: AddableOverlay {
    typealias OverlayType = NMFInfoWindow
    var overlayPayload: Dictionary<String, Any?> = [:]

    let info: NOverlayInfo
    let text: String
    let anchor: NPoint
    let alpha: CGFloat
    let position: NMGLatLng?
    let offsetX: Double
    let offsetY: Double

    func createMapOverlay() -> OverlayType {
        let infoWindow = NMFInfoWindow()
        return applyAtRawOverlay(infoWindow)
    }
    
    func applyAtRawOverlay(_ infoWindow: NMFInfoWindow) -> NMFInfoWindow {
        infoWindow.dataSource = NInfoWindow.createTextSource(text);
        infoWindow.anchor = anchor.cgPoint
        infoWindow.alpha = alpha
        infoWindow.offsetX = asRoundInt(rawFloat: offsetX)
        infoWindow.offsetY = asRoundInt(rawFloat: offsetY)
        if let position = position {
            infoWindow.position = position
        }
        return infoWindow
    }

    static func fromMessageable(_ v: Any) -> NInfoWindow {
        let d = asDict(v)
        return NInfoWindow(
                info: NOverlayInfo.fromMessageable(d[infoName]!),
                text: asString(d[textName]!),
                anchor: NPoint.fromMessageable(d[anchorName]!),
                alpha: asDouble(d[alphaName]!),
                position: castOrNull(d[positionName], caster: asLatLng),
                offsetX: asDouble(d[offsetXName]!),
                offsetY: asDouble(d[offsetYName]!)
        )
    }

    static func createTextSource(_ text: String) -> any NMFOverlayImageDataSource {
        return NFOverlayImageDataSource(text: text)
    }

    /*
        --- Messaging Name Define ---
    */
    private static let infoName = "info"
    static let textName = "text"
    static let anchorName = "anchor"
    static let alphaName = "alpha"
    static let positionName = "position"
    static let offsetXName = "offsetX"
    static let offsetYName = "offsetY"
    static let closeName = "close"
}

internal class NFOverlayImageDataSource: NSObject, NMFOverlayImageDataSource {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    func view(with overlay: NMFOverlay) -> UIView {
        // param value from android sdk. (interoperability)
        let shapeColor = UIColor.white.cgColor
        let textColor = UIColor.black
        let font: UIFont = .systemFont(ofSize: 14, weight: .medium)
        let cornerRadius: CGFloat = 8
        let padding = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        let shadowOffset = CGSize(width: 0, height: 1)
        let shadowRadius: CGFloat = 1
        let shadowColor: CGColor = UIColor.black.cgColor
        let shadowOpacity: Float = 0.25
        let tipWidth: CGFloat = 8
        let tipHeight: CGFloat = 6.4
                
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .clear
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        label.font = font
        label.textColor = textColor
        
        content.addSubview(label)
        content.layoutMargins = padding
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: content.layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: content.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: content.layoutMarginsGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: content.layoutMarginsGuide.bottomAnchor),
        ])
        
        content.setNeedsLayout()
        content.layoutIfNeeded()
        let contentSize = content.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let pad = shadowRadius + max(abs(shadowOffset.width), abs(shadowOffset.height))
        let wrapperSize = CGSize(width: contentSize.width  + pad * 2, height: contentSize.height + tipHeight + pad * 2)
        let wrapper = UIView(frame: CGRect(origin: .zero, size: wrapperSize))
        wrapper.backgroundColor = .clear
        
        let bubbleRect = CGRect(x: pad, y: pad, width: contentSize.width, height: contentSize.height)
        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: cornerRadius)
        let tipMidX = bubbleRect.midX
        path.move(to: CGPoint(x: tipMidX - tipWidth/2, y: bubbleRect.maxY))
        path.addLine(to: CGPoint(x: tipMidX, y: bubbleRect.maxY + tipHeight))
        path.addLine(to: CGPoint(x: tipMidX + tipWidth/2, y: bubbleRect.maxY))
        path.close()
        
        let fillLayer = CAShapeLayer()
        fillLayer.path      = path.cgPath
        fillLayer.fillColor = shapeColor
        wrapper.layer.addSublayer(fillLayer)
        
        wrapper.layer.shadowColor   = shadowColor
        wrapper.layer.shadowOpacity = shadowOpacity
        wrapper.layer.shadowOffset  = shadowOffset
        wrapper.layer.shadowRadius  = shadowRadius
        wrapper.layer.shadowPath    = path.cgPath
        
        content.frame = bubbleRect
        wrapper.addSubview(content)
        
        return wrapper
    }
}
