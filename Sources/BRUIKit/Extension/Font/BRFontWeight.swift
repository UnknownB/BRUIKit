//
//  BRFontWeight.swift
//  BRUIKit
//
//  Created by BR on 2025/6/19.
//

import UIKit


public enum BRFontWeight {
    case w100, w200, w300, w400, w500, w600, w700, w800, w900

    public var uiFontWeight: UIFont.Weight {
        switch self {
        case .w100: return .ultraLight     // -0.8
        case .w200: return .thin           // -0.6
        case .w300: return .light          // -0.4
        case .w400: return .regular        // 0.0
        case .w500: return .medium         // 0.23
        case .w600: return .semibold       // 0.3
        case .w700: return .bold           // 0.4
        case .w800: return .heavy          // 0.56
        case .w900: return .black          // 0.62
        }
    }
}
