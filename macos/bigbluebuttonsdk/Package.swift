// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "bigbluebuttonsdk",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "bigbluebuttonsdk", targets: ["bigbluebuttonsdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "bigbluebuttonsdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            // path: ".",
            // exclude: [
            //     "bigbluebuttonsdk.podspec",
            //     ".gitignore"
            // ],
            // sources: [
            //     "Classes"
            // ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
