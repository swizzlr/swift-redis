import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/swizzlr/CHiRedis.git", majorVersion: 1)
    ]
)
