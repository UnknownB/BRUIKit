//
//  UIColorColorSpaceTests.swift
//  BRUIKit
//
//  Created by BR on 2025/8/24.
//

import Testing
import UIKit
@testable import BRUIKit


struct UIColorColorSpaceTests {
    
    
    // MARK: - RGBA
    
    
    @Test("RGBA 轉換")
    func fromRGBA_and_toRGBA() throws {
        let color = UIColor.br.fromRGBA(color: (0.2, 0.4, 0.6, 0.8))
        let rgba = color.br.toRGBA()
        
        #expect(rgba != nil)
        #expect(rgba?.red == 0.2)
        #expect(rgba?.green == 0.4)
        #expect(rgba?.blue == 0.6)
        #expect(rgba?.alpha == 0.8)
    }
    
    
    @Test("RGBA 16進位轉換")
    func fromRGBHex() async throws {
        let color = UIColor.br.fromRGBHex(0x336699, alpha: 0.5)
        let rgba = color.br.toRGBA()
        
        #expect(rgba != nil)
        #expect(rgba?.red == 0x33 / 255.0)
        #expect(rgba?.green == 0x66 / 255.0)
        #expect(rgba?.blue == 0x99 / 255.0)
        #expect(rgba?.alpha == 0.5)
    }
    
    
    // MARK: - HSL
    
    
    @Test
    func fromHSL_and_toHSL() async throws {
        let color = UIColor.br.fromHSL(color: (hue: 0.6, saturation: 0.7, lightness: 0.4, alpha: 0.9))
        let hsl = color.br.toHSL()
        
        #expect(hsl != nil)
        #expect(hsl!.hue == 0.6)
        #expect(abs(hsl!.saturation - 0.7) < 0.001)
        #expect(hsl!.lightness == 0.4)
        #expect(hsl!.alpha == 0.9)
    }
    
    
}
