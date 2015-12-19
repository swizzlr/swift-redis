import PackageDescription

let package = Package(
    name: "SwiftRedis",
    targets: [
      Target(
        name: "RedisIntegrationTests",
        dependencies: [.Target(name: "Redis")]),
      Target(name: "Redis")
    ],
    dependencies: [
        .Package(url: "https://github.com/swizzlr/CHiRedis.git", majorVersion: 1),
    ]
)
