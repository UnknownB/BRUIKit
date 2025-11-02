//
//  UIImage+GIF.swift
//  BRUIKit
//
//  Created by BR on 2025/10/31.
//

import BRFoundation
import UIKit
import ImageIO


public extension BRWrapper where Base: UIImage {
    
    
    static func animatedGIF(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: Double = 0

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(UIImage(cgImage: cgImage))

            let delaySeconds = UIImage.br.delayForImageAtIndex(i, source: source)
            duration += delaySeconds
        }

        if duration == 0 {
            duration = Double(count) * 0.1
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    

    private static func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
              let gif = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] else
        {
            return delay
        }

        if let unclamped = gif[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
            delay = unclamped
        } else if let clamped = gif[kCGImagePropertyGIFDelayTime as String] as? Double {
            delay = clamped
        }

        if delay < 0.011 { delay = 0.1 }
        return delay
    }
}
