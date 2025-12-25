// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TextFixer",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "TextFixer",
            path: "Sources"
        )
    ]
)
