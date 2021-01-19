//
//  AVSource.swift
//  MediaSlideshow
//
//  Created by Peter Meyers on 1/5/21.
//

import AVFoundation
import Foundation

@objcMembers
open class AVSource: NSObject, MediaSource {
    public enum Playback {
        case play(muted: Bool)
        case paused
    }
    public let onAppear: Playback
    public let asset: AVAsset
    public private(set) lazy var item = AVPlayerItem(asset: asset)
    public private(set) lazy var player = AVPlayer(playerItem: item)

    public init(asset: AVAsset, onAppear: Playback) {
        self.asset = asset
        self.onAppear = onAppear
        super.init()
    }

    public convenience init(url: URL, onAppear: Playback) {
        self.init(asset: AVAsset(url: url), onAppear: onAppear)
    }

    public func slide(in slideshow: MediaSlideshow) -> MediaSlideshowSlide {
        AVPlayerSlide(
            source: self,
            overlayView: StandardAVSlideOverlayView(activityView: slideshow.activityIndicator?.create()),
            mediaContentMode: slideshow.contentScaleMode)
    }
}
