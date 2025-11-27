//
//  DisplayUtil.swift
//  flutter_naver_map
//
//  Created by 김소연 on 5/29/25.
//

import UIKit

internal struct DisplayUtil {
    static private var _scale: CGFloat = UIScreen.main.scale
    
    static var scale: CGFloat {
        return _scale
    }
    
    static func dpToPx(dp: Double) -> Double {
        return dp * scale
    }
}
