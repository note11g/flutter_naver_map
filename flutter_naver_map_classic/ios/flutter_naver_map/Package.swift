// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_naver_map",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "flutter-naver-map", targets: ["flutter_naver_map"])
    ],
    dependencies: [
        .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", from: "3.22.1"),
    ],
    targets: [
        .target(
            name: "flutter_naver_map",
            dependencies: [
                .product(name: "NMapsMap", package: "SPM-NMapsMap")
            ],
            resources: [],
        )
    ]
)
