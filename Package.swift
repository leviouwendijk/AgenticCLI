// swift-tools-version: 6.2

import Foundation
import PackageDescription

let packagedirectory = URL(
    fileURLWithPath: #filePath
).deletingLastPathComponent()

let infoPlistPath = packagedirectory.appendingPathComponent(
    "Support/Info.plist"
    ).path

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
            url: "https://github.com/leviouwendijk/AgenticSkills.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticExecution.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticTools.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticRuntime.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticHost.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticInterfaces.git",
            branch: "master"
        ),
        // Temporarily disabled until AgenticAdapters is rebuilt around
        // inference adaptation rather than provider-native model execution.
        // .package(
        //     url: "https://github.com/leviouwendijk/AgenticAdapters.git",
        //     branch: "master"
        // ),
        .package(
            url: "https://github.com/leviouwendijk/AgenticProviders.git",
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
                    name: "AgenticSkills",
                    package: "AgenticSkills"
                ),
                .product(
                    name: "AgenticExecution",
                    package: "AgenticExecution"
                ),
                .product(
                    name: "AgenticTools",
                    package: "AgenticTools"
                ),
                .product(
                    name: "AgenticRuntime",
                    package: "AgenticRuntime"
                ),
                .product(
                    name: "AgenticHost",
                    package: "AgenticHost"
                ),
                .product(
                    name: "AgenticCommandLine",
                    package: "AgenticHost"
                ),
                .product(
                    name: "AgenticInterfaces",
                    package: "AgenticInterfaces"
                ),
                .product(
                    name: "AgenticApple",
                    package: "AgenticProviders"
                ),
                .product(
                    name: "AgenticAWS",
                    package: "AgenticProviders"
                ),
                .product(
                    name: "AgenticOllama",
                    package: "AgenticProviders"
                ),
                .product(
                    name: "AgenticDomains",
                    package: "AgenticDomains"
                ),
                .product(
                    name: "AgenticMedia",
                    package: "AgenticMedia"
                ),
                .product(
                    name: "AgenticMediaApple",
                    package: "AgenticMedia"
                ),
            ],
            linkerSettings: [
                .unsafeFlags(
                    [
                        "-Xlinker", "-sectcreate",
                        "-Xlinker", "__TEXT",
                        "-Xlinker", "__info_plist",
                        "-Xlinker", infoPlistPath,
                    ]
                ),
            ]
        ),
    ]
)
