// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "AgenticCLI",
    platforms: [
        .macOS(.v13)
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
            url: "https://github.com/leviouwendijk/AgenticInterfaces.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticDomains.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Arguments.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Clipboard.git",
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
                    name: "AgenticInterfaces",
                    package: "AgenticInterfaces"
                ),
                .product(
                    name: "AgenticSwift",
                    package: "AgenticDomains"
                ),
                .product(
                    name: "AgenticGit",
                    package: "AgenticDomains"
                ),
                .product(
                    name: "Arguments",
                    package: "Arguments"
                ),
                .product(
                    name: "Clipboard",
                    package: "Clipboard"
                ),
            ]
        ),
    ]
)
