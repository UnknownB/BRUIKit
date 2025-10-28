//
//  UIImage+Processing.swift
//  BRUIKit
//
//  Created by BR on 2025/10/28.
//

import BRFoundation
import UIKit


public extension BRWrapper where Base: UIImage {
    
    
    /// 修正方向
    func fixedOrientation() -> UIImage {
        guard base.imageOrientation != .up else {
            return base
        }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        base.draw(in: CGRect(origin: .zero, size: base.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage ?? base
    }
    
    
    /// 轉換成 CVPixelBuffer (可用於 ML / Video)
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(base.size.width), Int(base.size.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        if let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(base.size.width),
            height: Int(base.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        ), let cgImage = base.cgImage {
            context.draw(cgImage, in: CGRect(origin: .zero, size: base.size))
        }
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
    
    
    // MARK: - Resize
    
    
    /// 依指定尺寸重繪圖片
    func resized(to targetSize: CGSize) -> UIImage {
        guard targetSize.width > 0, targetSize.height > 0 else {
            return base
        }

        UIGraphicsBeginImageContextWithOptions(targetSize, false, base.scale)
        base.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? base
    }
    
    
    /// 以指定比例等比縮放圖片
    func scaled(by ratio: CGFloat) -> UIImage {
        guard ratio > 0 else {
            return base
        }
        let newSize = CGSize(width: base.size.width * ratio, height: base.size.height * ratio)
        return resized(to: newSize)
    }


    /// 將圖片等比例縮放，讓寬或高不超過指定最大值
    func scaled(toMaxDimension maxLength: CGFloat) -> UIImage {
        guard base.size.width > 0, base.size.height > 0 else {
            return base
        }
        let ratio = min(maxLength / base.size.width, maxLength / base.size.height, 1)
        return scaled(by: ratio)
    }

    
    /// 將圖片等比例縮放至指定最大寬高範圍內
    func scaled(toFit maxSize: CGSize) -> UIImage {
        guard base.size.width > 0, base.size.height > 0 else {
            return base
        }
        let widthRatio = maxSize.width / base.size.width
        let heightRatio = maxSize.height / base.size.height
        let scale = min(widthRatio, heightRatio, 1)
        return scaled(by: scale)
    }

    
    /// 根據目標大小（KB）估算並縮放至近似尺寸
    /// - Note: 計算是近似值，壓縮與尺寸間非線性，結果略有誤差
    func scaled(toApproxFileSizeKB targetKB: Double, maxIteration: Int = 6) -> UIImage {
        guard targetKB > 0 else {
            return base
        }

        var result: UIImage = base
        var currentKB = base.br.fileSizeKB

        guard currentKB > targetKB else {
            return base
        }

        var scale: CGFloat = 0.8

        for _ in 0..<maxIteration {
            let newSize = CGSize(width: base.size.width * scale, height: base.size.height * scale)
            let newImage = resized(to: newSize)
            let newKB = newImage.br.fileSizeKB

            if newKB <= targetKB {
                result = newImage
                break
            }

            // 根據壓縮比例調整 scale
            let ratio = sqrt(targetKB / newKB)
            scale *= CGFloat(ratio)
            result = newImage
            currentKB = newKB
        }

        return result
    }
    
    
    // MARK: - 裁切

    
    /// 將圖片裁切至指定區域
    func cropped(to rect: CGRect) -> UIImage {
        guard let cgImage = base.cgImage?.cropping(to: rect) else {
            return base
        }
        return UIImage(cgImage: cgImage, scale: base.scale, orientation: base.imageOrientation)
    }
    

    /// 將圖片裁切成正方形（取中間區域）
    func croppedToSquare() -> UIImage {
        let length = min(base.size.width, base.size.height)
        let origin = CGPoint(x: (base.size.width - length) / 2, y: (base.size.height - length) / 2)
        let rect = CGRect(origin: origin, size: CGSize(width: length, height: length))
        return cropped(to: rect)
    }
    
    
    /// 將圖片裁切邊緣內縮值
    func cropped(inset: UIEdgeInsets) -> UIImage {
        let rect = CGRect(x: inset.left, y: inset.top, width: base.size.width - inset.left - inset.right, height: base.size.height - inset.top - inset.bottom)
        return cropped(to: rect)
    }
    
    
    // MARK: - 旋轉

    
    /// 旋轉圖片（以度為單位）
    func rotated(byDegrees degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180
        return rotated(byRadians: radians)
    }

    
    /// 旋轉圖片（以弧度為單位）
    func rotated(byRadians radians: CGFloat) -> UIImage {
        guard base.size.width > 0, base.size.height > 0 else {
            return base
        }

        let newSize = CGRect(origin: .zero, size: base.size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        UIGraphicsBeginImageContextWithOptions(newSize, false, base.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return base }

        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)

        // 把圖片畫上去（以中心對齊）
        base.draw(in: CGRect(x: -base.size.width / 2, y: -base.size.height / 2, width: base.size.width, height: base.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage ?? base
    }
    
    
    // MARK: - 分割
    
    
    /// 小圖與其在原圖中的對應位置
    class Tile {
        public var image: UIImage
        public var origin: CGPoint
        public init(image: UIImage, origin: CGPoint) {
            self.image = image
            self.origin = origin
        }
    }
    

    /// 將圖片依照 row × column 分割成多張小圖
    func split(rows: Int, columns: Int) -> [UIImage] {
        guard rows > 0, columns > 0, let cgImage = base.cgImage else {
            return []
        }

        let tileWidth = base.size.width / CGFloat(columns)
        let tileHeight = base.size.height / CGFloat(rows)

        var images: [UIImage] = []

        for row in 0..<rows {
            for column in 0..<columns {
                let rect = CGRect(
                    x: CGFloat(column) * tileWidth * base.scale,
                    y: CGFloat(row) * tileHeight * base.scale,
                    width: tileWidth * base.scale,
                    height: tileHeight * base.scale
                )
                guard let cropped = cgImage.cropping(to: rect) else {
                    continue
                }
                let piece = UIImage(cgImage: cropped, scale: base.scale, orientation: base.imageOrientation)
                images.append(piece)
            }
        }
        return images
    }
    
    
    /// 將圖片依指定的格子尺寸分割
    func split(tileSize: CGSize) -> [UIImage] {
        guard tileSize.width > 0, tileSize.height > 0, let cgImage = base.cgImage else {
            return []
        }

        let cols = Int(ceil(base.size.width / tileSize.width))
        let rows = Int(ceil(base.size.height / tileSize.height))
        var images: [UIImage] = []

        for row in 0..<rows {
            for col in 0..<cols {
                let x = CGFloat(col) * tileSize.width * base.scale
                let y = CGFloat(row) * tileSize.height * base.scale
                let width = min(tileSize.width * base.scale, CGFloat(cgImage.width) - x)
                let height = min(tileSize.height * base.scale, CGFloat(cgImage.height) - y)
                let rect = CGRect(x: x, y: y, width: width, height: height)
                guard let cropped = cgImage.cropping(to: rect) else {
                    continue
                }
                let piece = UIImage(cgImage: cropped, scale: base.scale, orientation: base.imageOrientation)
                images.append(piece)
            }
        }
        return images
    }
    
    
    /// 將圖片切割成可重疊的小塊，執行自訂處理，最後再組回完整圖片
    /// - Parameters:
    ///   - tileSize: 每塊小圖的尺寸（建議 >30）
    ///   - process: 對每塊小圖的自訂處理邏輯
    /// - Returns: 處理後重新組合的圖片
    func processTiles(tileSize: CGSize, _ process: (_ tiles: [Tile]) -> Void) -> UIImage {
        guard tileSize.width > 0, tileSize.height > 0 else { return base }

        // 根據圖片尺寸推算可切割數量（多加一塊確保重疊）
        let xCount = Int(base.size.width / tileSize.width + 0.5) + 1
        let yCount = Int(base.size.height / tileSize.height + 0.5) + 1

        let dx = base.size.width / CGFloat(xCount)
        let dy = base.size.height / CGFloat(yCount)

        // 計算重疊區大小
        let overlap = CGSize(width: floor((tileSize.width - dx) / 2), height: floor((tileSize.height - dy) / 2))
        var tiles: [Tile] = []

        // 分割圖片
        for row in 0..<yCount {
            for col in 0..<xCount {
                var origin = CGPoint(x: CGFloat(col) * dx, y: CGFloat(row) * dy)
                let rect = CGRect(origin: origin, size: tileSize)
                let subImage = cropped(to: rect)

                // 調整座標，避免重疊造成偏差
                if col != 0 { origin.x += overlap.width }
                if row != 0 { origin.y += overlap.height }

                tiles.append(Tile(image: subImage, origin: origin))
            }
        }

        // 讓外部決定如何處理每一塊
        process(tiles)

        // 清除重疊區邊界
        for i in 0..<tiles.count {
            let topInset = i < xCount ? 0 : overlap.height
            let leftInset = i % xCount == 0 ? 0 : overlap.width
            let bottomInset = i >= tiles.count - xCount ? 0 : overlap.height
            let rightInset = i % xCount == xCount - 1 ? 0 : overlap.width

            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            tiles[i].image = tiles[i].image.br.cropped(inset: insets)
        }

        // 重組
        return BRWrapper<Base>.mergeTiles(size: base.size, tiles: tiles)
    }

    
    // MARK: - 合併

    
    /// 將多張圖片依水平方向合併
    static func mergeHorizontally(_ images: [UIImage]) -> UIImage? {
        guard !images.isEmpty else { return nil }

        let totalWidth = images.reduce(0) { $0 + $1.size.width }
        let maxHeight = images.map { $0.size.height }.max() ?? 0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: totalWidth, height: maxHeight), false, 0)
        defer { UIGraphicsEndImageContext() }

        var xOffset: CGFloat = 0
        for image in images {
            image.draw(in: CGRect(x: xOffset, y: 0, width: image.size.width, height: image.size.height))
            xOffset += image.size.width
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    

    /// 將多張圖片依垂直方向合併
    static func mergeVertically(_ images: [UIImage]) -> UIImage? {
        guard !images.isEmpty else { return nil }

        let totalHeight = images.reduce(0) { $0 + $1.size.height }
        let maxWidth = images.map { $0.size.width }.max() ?? 0

        UIGraphicsBeginImageContextWithOptions(CGSize(width: maxWidth, height: totalHeight), false, 0)
        defer { UIGraphicsEndImageContext() }

        var yOffset: CGFloat = 0
        for image in images {
            image.draw(in: CGRect(x: 0, y: yOffset, width: image.size.width, height: image.size.height))
            yOffset += image.size.height
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// 將多張圖片依照 N×M 格子排列合併成一張
    static func mergeGrid(_ images: [UIImage], rows: Int, columns: Int) -> UIImage? {
        guard rows > 0, columns > 0, !images.isEmpty else { return nil }

        // 若圖片不足，則以最後一張補齊
        let filledImages = images + Array(repeating: images.last!, count: max(0, rows * columns - images.count))

        // 每個格子的最大寬高
        let maxWidth = filledImages.map { $0.size.width }.max() ?? 0
        let maxHeight = filledImages.map { $0.size.height }.max() ?? 0
        let totalSize = CGSize(width: maxWidth * CGFloat(columns), height: maxHeight * CGFloat(rows))

        UIGraphicsBeginImageContextWithOptions(totalSize, false, 0)
        defer { UIGraphicsEndImageContext() }

        for row in 0..<rows {
            for col in 0..<columns {
                let index = row * columns + col
                guard index < filledImages.count else { continue }
                let img = filledImages[index]
                let x = CGFloat(col) * maxWidth
                let y = CGFloat(row) * maxHeight
                img.draw(in: CGRect(x: x, y: y, width: img.size.width, height: img.size.height))
            }
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    static func mergeTiles(size: CGSize, tiles: [Tile]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, tiles.first?.image.scale ?? 1)
        defer { UIGraphicsEndImageContext() }

        for tile in tiles {
            tile.image.draw(at: tile.origin)
        }

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    
}
