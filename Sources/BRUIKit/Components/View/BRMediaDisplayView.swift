//
//  BRMediaDisplayView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/31.
//

import BRFoundation
import UIKit
import AVKit
import ImageIO


public enum BRMediaContent {
    case image(UIImage)
    case data(Data)
    case url(URL)
    
    public static func create(_ value: Any?) -> BRMediaContent? {
        switch value {
        case let image as UIImage:
            return .image(image)
        case let data as Data:
            return .data(data)
        case let url as URL:
            return .url(url)
        case let string as String:
            let url = URL(string: string)
            if let url = URL(string: string) {
                return .url(url)
            }
            return nil
        default:
            return nil
        }
    }
    
    public static func create(from values: [Any]) -> [BRMediaContent] {
        values.compactMap { create($0) }
    }
}


open class BRMediaDisplayView: UIView {
    
    public let layout = BRLayout()
    public var currentContent: BRMediaContent?
    private var player: AVPlayer?

    
    // MARK: - UI 元件
    
    
    public let imageView = UIImageView()
    public var playerLayer: AVPlayerLayer?
    
    
    // MARK: - LifeCycle
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    
    // MARK: - UI
    
    
    private func setupUI() {
        addView(imageView)
    }
    
    
    private func addView(_ view: UIView) {
        addSubview(view)
        
        layout.activate {
            view.br.top == self.br.top
            view.br.left == self.br.left
            view.br.bottom == self.br.bottom
            view.br.right == self.br.right
        }
    }
    
    
    private func cleanup() {
        imageView.image = nil
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    
    @discardableResult
    open func content(_ content: BRMediaContent) -> Self {
        currentContent = content
        cleanup()
        switch content {
        case .image(let image):
            imageView.image = image
            
        case .data(let data):
            handleData(data)
            
        case .url(let url):
            handleURL(url)
        }
        return self
    }
    
    
    private func handleData(_ data: Data) {
        let type = data.br.mimeType
        
        if type == .gif {
            loadGIF(from: data)
        } else if let image = UIImage(data: data) {
            imageView.image = image
        } else {
            playVideo(with: data)
        }
    }
    
    
    private func handleURL(_ url: URL) {
        let type = BRMimeType.from(fileExtension: url.pathExtension)
        
        switch type {
        case .gif:
            loadGIF(from: url)
            
        case .jpeg, .png, .webp:
            loadImage(from: url)

        case .mov, .mp4, .avi:
            playVideo(with: url)
            
        default:
            break
        }
    }
    
    
    private func loadImage(from url: URL) {
        imageView.image = nil
        Task {
            if let (data, _) = try? await URLSession.shared.data(from: url),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.imageView.image = image
                }
            }
        }
    }
    
    
    private func loadGIF(from url: URL) {
        if let data =  try? Data(contentsOf: url) {
            loadGIF(from: data)
            return
        }
    }
    
    
    private func loadGIF(from data: Data) {
        if let image = UIImage.br.animatedGIF(data: data) {
            imageView.image = image
        }
    }

    
    private func playVideo(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else {
            return
        }
        layer.addSublayer(playerLayer)
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspect
        player?.play()
    }
    
    
    private func playVideo(with data: Data) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
        try? data.write(to: tempURL)
        playVideo(with: tempURL)
    }
    
    
}
