//
//  DisplayUtil.swift
//  flutter_naver_map
//
//  Created by 김소연 on 5/29/25.
//

internal struct DisplayUtil {
    static private lazy var _density: CGFloat = {
        return UIScreen.main.scale
    }
    
    static var scale: CGFloat {
        get {
            return _density
        }
    }
    
    static func dpToPx(dp: Double) -> Double {
        return dp * scale
    }
}
