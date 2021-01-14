//
//  AVSlideshowDataSource.swift
//  MediaSlideshow
//
//  Created by Peter Meyers on 1/7/21.
//

import Foundation
import UIKit

open class ImageAndVideoSlideshowDataSource: NSObject, MediaSlideshowDataSource {
    public enum Source {
        case image(ImageSource)
        case av(AVSource)
    }

    open var sources: [Source]
    open var onAVAppear: MediaSlideshowAVSlide.Playback
    private lazy var fullscreen: MediaSlideshowDataSource = Self.init(
        sources: sources,
        onAVAppear: .play(muted: false))

    public required init(sources: [Source], onAVAppear: MediaSlideshowAVSlide.Playback) {
        self.sources = sources
        self.onAVAppear = onAVAppear
        super.init()
    }

    public func sourcesInMediaSlideshow(_ mediaSlideshow: MediaSlideshow) -> [MediaSource] {
        sources.map {
            switch $0 {
            case .av(let avSource): return avSource
            case .image(let imageSource): return imageSource
            }
        }
    }

    public func slideForSource(_ source: MediaSource, in mediaSlideshow: MediaSlideshow) -> MediaSlideshowSlideView {
        if let image = source as? ImageSource {
            let slide = MediaSlideshowImageSlide(
                image: image,
                zoomEnabled: mediaSlideshow.zoomEnabled,
                activityIndicator: mediaSlideshow.activityIndicator?.create(),
                maximumScale: mediaSlideshow.maximumScale)
            slide.imageView.contentMode = mediaSlideshow.contentScaleMode
            return slide
        }
        if let av = source as? AVSource {
            return MediaSlideshowAVSlide(
                source: av,
                onAppear: onAVAppear,
                overlayView: StandardAVSlideOverlayView(activityView: mediaSlideshow.activityIndicator?.create()),
                mediaContentMode: mediaSlideshow.contentScaleMode)
        }
        fatalError("Unrecognized source")
    }

    public func dataSourceForFullscreen(_ fullscreenSlideshow: MediaSlideshow) -> MediaSlideshowDataSource {
        fullscreen
    }
}
