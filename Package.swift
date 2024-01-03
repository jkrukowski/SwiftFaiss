// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-faiss",
    platforms: [
        .macOS(.v14),
        .iOS(.v16)
    ],
    products: [
        .library(name: "SwiftFaiss", targets: ["SwiftFaiss"]),
        .executable(name: "swift-faiss", targets: ["SwiftFaissCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.5"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.3"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4")
    ],
    targets: [
        .executableTarget(
            name: "SwiftFaissCLI",
            dependencies: [
                .target(name: "SwiftFaiss"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        ),
        .target(
            name: "SwiftFaiss",
            dependencies: [
                .target(name: "SwiftFaissC"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "Logging", package: "swift-log")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        ),
        .target(
            name: "SwiftFaissC",
            dependencies: [
                .target(name: "FaissC"),
                .target(name: "Faiss"),
                .target(name: "OpenMP")
            ]
        ),
        .binaryTarget(
            name: "FaissC",
            path: "Libs/faiss_c.xcframework"
        ),
        .binaryTarget(
            name: "Faiss",
            path: "Libs/faiss.xcframework"
        ),
        .binaryTarget(
            name: "OpenMP",
            path: "Libs/openmp.xcframework"
        ),
        .testTarget(
            name: "SwiftFaissTests",
            dependencies: [
                .target(name: "SwiftFaiss")
            ]
        )
    ]
)
