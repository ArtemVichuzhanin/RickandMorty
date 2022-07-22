// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "RickandMortyUmbrella",
  platforms: [.iOS(.v15)],

  products: [
    .library(
      name: "RickandMortyUmbrella",
      targets: ["RickandMortyUmbrella"]
    )
  ],

  dependencies: [
    .package(
      url: "https://github.com/Alamofire/Alamofire.git",
      "5.3.0"..."5.4.4"
    ),
    .package(
      url: "https://github.com/YAtechnologies/GoogleMaps-SP.git",
      from: "6.0.0"
    ),
    .package(
      url: "https://github.com/onevcat/Kingfisher.git",
      "7.0.0"..."7.1.1"
    )
  ],

  targets: [
    .target(
      name: "RickandMortyUmbrella",
      dependencies: [
        .product(name: "Alamofire", package: "Alamofire"),
        .product(name: "GoogleMaps", package: "GoogleMaps-SP"),
        .product(name: "Kingfisher", package: "Kingfisher")
      ],
      path: "Sources/Common"
    ),

      .testTarget(
        name: "RickandMortyUmbrellaTests",
        dependencies: ["RickandMortyUmbrella"],
        path: "Tests/CommonTests"
      ),
  ]
)
