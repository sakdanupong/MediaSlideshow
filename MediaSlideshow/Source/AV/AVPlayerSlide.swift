//
//  AVSlideshowItem.swift
//  ImageSlideshow
//
//  Created by Peter Meyers on 1/5/21.
//

import AVFoundation
import AVKit
import UIKit

public class AVPlayerSlide: AVPlayerView, MediaSlideshowSlide {
    public enum Playback {
        case play(muted: Bool)
        case paused
    }
    private let source: AVSource
    private var playerTimeControlStatusObservation: NSKeyValueObservation?
    private var playerTimeObserver: Any?
    private let overlayView: AVSlideOverlayView?
    private let transitionView: UIImageView
    private let onAppear: Playback

    public init(
        source: AVSource,
        onAppear: Playback = .paused,
        overlayView: AVSlideOverlayView? = nil,
        mediaContentMode: UIView.ContentMode) {
        self.source = source
        self.onAppear = onAppear
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
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        playerTimeObserver = source.player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main) { [weak self] time in
            guard let self = self else { return }
            let currentTime = self.source.item.currentTime().seconds
            let duration = self.source.item.duration.seconds
            self.overlayView?.playerDidUpdateToTime(
                currentTime,
                duration: (duration.isNaN || duration.isInfinite) ? nil : duration)
        }
        playerTimeControlStatusObservation = source.player.observe(\.timeControlStatus) { [weak self] player, _ in
            self?.overlayView?.playerDidUpdateStatus(player.timeControlStatus)
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
        let generator = AVAssetImageGenerator(asset: source.asset)
        generator.appliesPreferredTrackTransform = true
        if let imageRef = try? generator.copyCGImage(at: source.player.currentTime(), actualTime: nil) {
            transitionView.image = UIImage(cgImage: imageRef)
        }
        return transitionView
    }

    public func willStartFullscreenTransition(_ type: FullscreenTransitionType) {
        source.player.pause()
    }

    public func didAppear() {
        switch onAppear {
        case .play(let muted):
            source.player.play()
            source.player.isMuted = muted
        case .paused:
            source.player.pause()
        }
    }

    public func didDisappear() {
        source.player.pause()
    }
}
