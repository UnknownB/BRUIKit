//
//  BRMediaView.swift
//  BRUIKit
//
//  Created by BR on 2025/10/31.
//

import BRFoundation
import UIKit
import AVKit
import ImageIO


open class BRMediaView: UIView {
    
    public let layout = BRLayout()
    private var player: AVPlayer?
    
    
    public var mediaContent = BRMediaContent() {
        didSet {
            updateMediaContent(mediaContent)
        }
    }

    
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
    
    
    @discardableResult
    open func mediaContent(_ mediaContent: BRMediaContent) -> Self {
        self.mediaContent = mediaContent
        return self
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
    
    
    // MARK: - Data
    
    
    private func updateMediaContent(_ mediaContent: BRMediaContent) {
        cleanup()
        switch mediaContent.source {
        case .data:
            handleData(mediaContent.data!)
        case .url:
            handleURL(mediaContent.url!)
        case .image:
            imageView.image = mediaContent.image
        default:
            break
        }
    }
    
    
    private func cleanup() {
        imageView.image = nil
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    
    private func handleData(_ data: Data) {
        let type = data.br.mimeType
        
        if type.isImage {
            imageView.image = UIImage.br.load(data)
        } else {
            playVideo(with: data)
        }
    }
    
    
    private func handleURL(_ url: URL) {
        let type = BRMimeType.from(fileExtension: url.pathExtension)
        
        if type.isImage {
            loadImage(from: url)
        } else {
            playVideo(with: url)
        }
    }
    
    
    private func loadImage(from url: URL) {
        imageView.image = nil
        Task {
            if let data = try? await url.br.cachedData() {
                await MainActor.run {
                    self.imageView.image = UIImage.br.load(data)
                }
            }
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
