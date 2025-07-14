import Foundation

typealias CustomStyleCallbacks = (loadHandler: () -> Void, failHandler: (any Error) -> Void)

internal extension NaverMapControlSender {
    func getCustomStyleCallback() -> CustomStyleCallbacks {
        return (
            loadHandler: onCustomStyleLoaded,
            failHandler: onCustomStyleLoadFailed
        )
    }
}