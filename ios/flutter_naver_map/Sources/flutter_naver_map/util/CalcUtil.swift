import CoreGraphics

internal struct CalcUtil {
    static func float32To64(f32: CGFloat) -> Double {
        let convertedInt: Int = Int(f32 * CGFloat(F32_MULTIPLIER_CONSTANT))
        return Double(convertedInt) / Double(F32_MULTIPLIER_CONSTANT)
    }

    private static let F32_MULTIPLIER_CONSTANT: Int = 1_000_000
}
