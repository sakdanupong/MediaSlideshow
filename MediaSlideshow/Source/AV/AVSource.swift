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
    public let asset: AVAsset
    public private(set) lazy var item = AVPlayerItem(asset: asset)
    public private(set) lazy var player = AVPlayer(playerItem: item)

    public init(asset: AVAsset) {
        self.asset = asset
        super.init()
    }

    public convenience init(url: URL) {
        self.init(asset: AVAsset(url: url))
    }
}

