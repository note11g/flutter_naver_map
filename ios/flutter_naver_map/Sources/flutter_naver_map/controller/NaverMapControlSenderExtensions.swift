import Foundation

typealias CustomStyleCallbacks = (loadHandler: () -> Void, failHandler: (any Error) -> Void)

internal extension NaverMapControlSender {
    func getCustomStyleCallback() -> CustomStyleCallbacks {
        return (
            loadHandler: { [weak self] in self?.onCustomStyleLoaded() },
            failHandler: { [weak self] error in self?.onCustomStyleLoadFailed(exception: error) }
        )
    }
}