//
//  AVSlideshowItem.swift
//  ImageSlideshow
//
//  Created by Peter Meyers on 1/5/21.
//

import AVFoundation
import AVKit
import UIKit

public protocol AVPlayerSlideDelegate: AnyObject {
    func currentThumbnail(_ slide: AVPlayerSlide) -> UIImage?
    func slideDidAppear(_ slide: AVPlayerSlide)
    func slideDidDisappear(_ slide: AVPlayerSlide)
}

public class AVPlayerSlide: AVPlayerView, MediaSlideshowSlide {
    weak var delegate: AVPlayerSlideDelegate?

    private let source: AVSource
    private let overlayView: AVSlideOverlayView?
    private let transitionView: UIImageView

    public init(
        source: AVSource,
        overlayView: AVSlideOverlayView? = nil,
        mediaContentMode: UIView.ContentMode) {
        self.source = source
        self.mediaContentMode = mediaContentMode
        self.overlayView = overlayView
        self.transitionView = UIImageView()
        super.init(frame: .zero)
        player = source.player
        setPlayerViewVideoGravity()
        // Stays hidden, but needs to be apart of the view heirarchy due to how the zoom animation works.
        transitionView.isHidden = true
        embed(transitionView)
        if let overlayView = overlayView {
            embed(overlayView)
        }

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlayerViewVideoGravity() {
        switch mediaContentMode {
        case .scaleAspectFill: videoGravity = .resizeAspectFill
        case .scaleToFill: videoGravity = .resize
        default: videoGravity = .resizeAspect
        }
    }

    // MARK: - MediaSlideshowSlide

    public var mediaContentMode: UIView.ContentMode {
        didSet {
            setPlayerViewVideoGravity()
        }
    }

    public func willBeRemoved() {}

    public func loadMedia() {}

    public func releaseMedia() {}

    public func transitionImageView() -> UIImageView {
        transitionView.frame = videoRect
        transitionView.contentMode = mediaContentMode
        transitionView.image = delegate?.currentThumbnail(self)
        return transitionView
    }

    public func didAppear() {
        delegate?.slideDidAppear(self)
    }

    public func didDisappear() {
        delegate?.slideDidDisappear(self)
    }
}
