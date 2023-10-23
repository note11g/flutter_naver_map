internal class ScaleCorrectionUtil {
    static func applyCorrectSize(_ size: NSize, image: NOverlayImage?, sizeApplier: (_ w: CGFloat, _ h: CGFloat) -> Void) {
        let needScaleCorrection = image != nil && size.isAutoSize
        let scaleFactor = UIScreen.main.scale
        sizeApplier(
            needScaleCorrection ? image!.overlayImage.imageWidth / scaleFactor : size.width,
            needScaleCorrection ? image!.overlayImage.imageHeight / scaleFactor : size.height
        )
    }
}
