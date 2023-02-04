// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SwiftUIAdvancedMap",
  platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16)],
  products: [
    .library(
      name: "AdvancedMap",
      targets: ["AdvancedMap"]
    )
  ],
  dependencies: [],
  targets: [
    .target(
      name: "AdvancedMap",
      dependencies: []
    ),
    .testTarget(
      name: "AdvancedMapTests",
      dependencies: ["AdvancedMap"]
    )
  ]
)
