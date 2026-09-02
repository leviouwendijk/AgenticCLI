// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AgenticCLI",
    platforms: [
        .macOS(.v26),
    ],
    products: [
        .executable(
            name: "agentic",
            targets: [
                "AgenticCLI",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/Agentic.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticExecution.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticRuntime.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticAdapters.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticDomains.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticMedia.git",
            branch: "master"
        ),
    ],
    targets: [
        .executableTarget(
            name: "AgenticCLI",
            dependencies: [
                .product(
                    name: "Agentic",
                    package: "Agentic"
                ),
                .product(
                    name: "AgenticExecution",
                    package: "AgenticExecution"
                ),
                .product(
                    name: "AgenticRuntime",
                    package: "AgenticRuntime"
                ),
                .product(
                    name: "AgenticRuntimeCommands",
                    package: "AgenticRuntime"
                ),
                .product(
                    name: "AgenticApple",
                    package: "AgenticAdapters"
                ),
                .product(
                    name: "AgenticDomains",
                    package: "AgenticDomains"
                ),
                .product(
                    name: "AgenticMediaApple",
                    package: "AgenticMedia"
                ),
            ]
        ),
    ]
)
