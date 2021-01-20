//
//  AVSource.swift
//  MediaSlideshow
//
//  Created by Peter Meyers on 1/5/21.
//

import AVFoundation
import AVKit
import Foundation

open class AVSource: NSObject, MediaSource {
    public enum Playback {
        case play(muted: Bool)
        case paused
    }
    private let onAppear: Playback
    private let asset: AVAsset
    public private(set) lazy var item = AVPlayerItem(asset: asset)
    public private(set) lazy var player = AVPlayer(playerItem: item)

    public init(asset: AVAsset, onAppear: Playback) {
        self.asset = asset
        self.onAppear = onAppear
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTime(notification:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item)
    }

    public convenience init(url: URL, onAppear: Playback) {
        self.init(asset: AVAsset(url: url), onAppear: onAppear)
    }

    open func slide(in slideshow: MediaSlideshow) -> MediaSlideshowSlide {
        let playerController = AVPlayerViewController()
        playerController.player = player
        switch onAppear {
        case .paused:
            playerController.showsPlaybackControls = true
            let overlay = StandardAVSlideOverlayView(
                item: item,
                player: player,
                playView: nil,
                pauseView: nil,
                activityView: slideshow.activityIndicator?.create())
            playerController.contentOverlayView?.embed(overlay)
        case .play:
            playerController.showsPlaybackControls = false
            let overlay = StandardAVSlideOverlayView(
                item: item,
                player: player,
                playView: AVSlidePlayingOverlayView(),
                pauseView: AVSlidePausedOverlayView(),
                activityView: slideshow.activityIndicator?.create())
            playerController.contentOverlayView?.embed(overlay)
        }
        let slide = AVPlayerSlide(
            playerController: playerController,
            mediaContentMode: slideshow.contentScaleMode)
        slide.delegate = self
        return slide
    }

    @objc
    open func playerItemDidPlayToEndTime(notification: Notification) {
        player.seek(to: .zero)
    }
}

extension AVSource: AVPlayerSlideDelegate {
    public func slideDidSingleTap(_ slide: AVPlayerSlide) {
    }

    open func slideDidAppear(_ slide: AVPlayerSlide) {
        switch onAppear {
        case .play(let muted):
            player.play()
            player.isMuted = muted
        case .paused:
            player.pause()
        }
    }

    open func slideDidDisappear(_ slide: AVPlayerSlide) {
        player.pause()
    }

    open func currentThumbnail(_ slide: AVPlayerSlide) -> UIImage? {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let imageRef = try? generator.copyCGImage(at: player.currentTime(), actualTime: nil) {
            return UIImage(cgImage: imageRef)
        }
        return nil
    }
}
