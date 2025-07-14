import NMapsMap

internal struct NMultipartPath {
    let coords: Array<NMGLatLng>
    let color: UIColor
    let outlineColor: UIColor
    let passedColor: UIColor
    let passedOutlineColor: UIColor

    var colorPart: NMFPathColor {
        NMFPathColor(
                color: color,
                outlineColor: outlineColor,
                passedColor: passedColor,
                passedOutlineColor: passedOutlineColor
        )
    }

    func toMessageable() -> Dictionary<String, Any> {
        [
            "coords": coords.map {
                $0.toMessageable()
            },
            "color": color.toInt(),
            "outlineColor": outlineColor.toInt(),
            "passedColor": passedColor.toInt(),
            "passedOutlineColor": passedOutlineColor.toInt()
        ]
    }

    static func fromMessageable(_ v: Any) -> NMultipartPath {
        let d = asDict(v)
        return NMultipartPath(
                coords: asArr(d["coords"]!, elementCaster: asLatLng),
                color: asUIColor(d["color"]!),
                outlineColor: asUIColor(d["outlineColor"]!),
                passedColor: asUIColor(d["passedColor"]!),
                passedOutlineColor: asUIColor(d["passedOutlineColor"]!)
        )
    }

    static func fromCoordsAndColorParts(coords: Array<NMGLatLng>, colorPart: NMFPathColor) -> NMultipartPath {
        NMultipartPath(
                coords: coords,
                color: colorPart.color,
                outlineColor: colorPart.outlineColor,
                passedColor: colorPart.passedColor,
                passedOutlineColor: colorPart.passedOutlineColor
        )
    }
}

internal extension  Array<NMultipartPath> {
    func applyLineAndColor(linePartsFun: (Array<NMGLineString<AnyObject>>) -> Void, colorPartsFun: (Array<NMFPathColor>) -> Void) {
        var coords: Array<NMGLineString<AnyObject>> = []
        var colors: Array<NMFPathColor> = []
        for nPath in self {
            coords.append(NMGLineString(points: nPath.coords))
            colors.append(nPath.colorPart)
        }
        linePartsFun(coords)
        colorPartsFun(colors)
    }
}