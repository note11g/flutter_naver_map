import NMapsMap

internal struct NCameraUpdate {
    let signature: String
    let target: NMGLatLng?
    let zoom: Double?
    let zoomBy: Double?
    let tilt: Double?
    let tiltBy: Double?
    let bearing: Double?
    let bearingBy: Double?
    let bounds: NMGLatLngBounds?
    let boundsPadding: NEdgeInsets?
    let pivot: NPoint?
    let animation: NMFCameraUpdateAnimation
    let duration: Int // mill seconds. not Second.
    let reason: Int?

    var cameraUpdate: NMFCameraUpdate {
        get throws {
            let cameraUpdate: NMFCameraUpdate

            switch signature {
            case "withParams": cameraUpdate = NMFCameraUpdate(params: params)
            case "fitBounds": cameraUpdate = boundsPadding != nil
                    ? NMFCameraUpdate(fit: bounds!, paddingInsets: boundsPadding!.uiEdgeInsets)
                    : NMFCameraUpdate(fit: bounds!)
            default: throw NSError()
            }

            if let pivot = pivot {
                cameraUpdate.pivot = pivot.cgPoint
            }
            if let reason = reason {
                cameraUpdate.reason = Int32(reason)
            }

            cameraUpdate.animation = animation
            cameraUpdate.animationDuration = (Double(duration) / 1000)

            return cameraUpdate
        }
    }

    private var params: NMFCameraUpdateParams {
        let p = NMFCameraUpdateParams()
        if let target = target {
            p.scroll(to: target)
        }
        if let zoom = zoom {
            p.zoom(to: zoom)
        }
        if let zoomBy = zoomBy {
            p.zoom(by: zoomBy)
        }
        if let tilt = tilt {
            p.tilt(to: tilt)
        }
        if let tiltBy = tiltBy {
            p.tilt(by: tiltBy)
        }
        if let bearing = bearing {
            p.rotate(to: bearing)
        }
        if let bearingBy = bearingBy {
            p.rotate(by: bearingBy)
        }
        return p
    }

    static func fromMessageable(_ v: Any) -> NCameraUpdate {
        let d = asDict(v)
        return NCameraUpdate(
                signature: asString(d["sign"]!),
                target: castOrNull(d["target"], caster: asLatLng),
                zoom: castOrNull(d["zoom"], caster: asDouble),
                zoomBy: castOrNull(d["zoomBy"], caster: asDouble),
                tilt: castOrNull(d["tilt"], caster: asDouble),
                tiltBy: castOrNull(d["tiltBy"], caster: asDouble),
                bearing: castOrNull(d["bearing"], caster: asDouble),
                bearingBy: castOrNull(d["bearingBy"], caster: asDouble),
                bounds: castOrNull(d["bounds"], caster: asLatLngBounds),
                boundsPadding: castOrNull(d["boundsPadding"], caster: NEdgeInsets.fromMessageable),
                pivot: castOrNull(d["pivot"], caster: NPoint.fromMessageable),
                animation: asCameraAnimation(d["animation"]!),
                duration: asInt(d["duration"]!),
                reason: castOrNull(d["reason"], caster: asInt)
        )
    }
}
