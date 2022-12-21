// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "SwiftUIAdvancedMap",
  platforms: [.iOS(.v14), .macOS(.v11)],
  products: [

    .library(
      name: "AdvancedMap",
      targets: ["AdvancedMap"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "AdvancedMap",
      dependencies: []
    )
  ]
)
