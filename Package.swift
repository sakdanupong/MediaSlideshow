// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "MediaSlideshow",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "MediaSlideshow",
            targets: ["MediaSlideshow"]),
        .library(
            name: "MediaSlideshowAlamofire",
            targets: ["MediaSlideshowAlamofire"]),
        .library(
            name: "MediaSlideshowSDWebImage",
            targets: ["MediaSlideshowSDWebImage"]),
        .library(
            name: "MediaSlideshowKingfisher",
            targets: ["MediaSlideshowKingfisher"])
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "5.8.0"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    targets: [
        .target(
            name: "MediaSlideshow",
            path: "MediaSlideshow",
            sources: ["Source"],
            resources: [
                .copy("Resources/ic_cross_white@2x.png"),
                .copy("Resources/ic_cross_white@3x.png"),
                .copy("Resources/AVAssets.xcassets")
            ]),
        .target(
            name: "MediaSlideshowAlamofire",
            dependencies: ["MediaSlideshow", "AlamofireImage"],
            path: "MediaSlideshowAlamofire",
            sources: ["Source"]),
        .target(
            name: "MediaSlideshowSDWebImage",
            dependencies: ["MediaSlideshow", "SDWebImage"],
            path: "MediaSlideshowSDWebImage",
            sources: ["Source"]),
        .target(
            name: "MediaSlideshowKingfisher",
            dependencies: ["MediaSlideshow", "Kingfisher"],
            path: "MediaSlideshowKingfisher",
            sources: ["Source"])
    ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
