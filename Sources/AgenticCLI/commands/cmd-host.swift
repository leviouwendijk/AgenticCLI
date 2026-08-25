import AgenticInterfaces
import Arguments
import Clipboard
import Foundation

enum AgenticHostCommand:
    ArgumentCommand
{
    static let name =
        "host"

    static let defaultChild =
        Help.self

    static let children:
        [ArgumentCommandType] =
            [
                Help.self,
                Manifest.self,
                Bridge.self,
            ]

    enum Help:
        RunnableArgumentCommand
    {
        static let name =
            "help"

        static func run(
            _ invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            print(
                ArgumentHelpRenderer()
                    .render(
                        command:
                            try AgenticHostCommand
                                .spec()
                    )
            )
        }
    }

    enum Manifest:
        ParsedArgumentCommand
    {
        typealias Options =
            HostManifestOptions

        static let name =
            "manifest"

        static func run(
            _ options: HostManifestOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let host =
                try AgenticCLIToolRuntime
                    .host(
                        workspacePath:
                            options.workspace,
                        sessionID:
                            options.sessionID
                    )

            let text =
                try host
                    .capabilityManifestText()

            if options.copy {
                guard Clipboard.system.write(
                    text
                ) else {
                    throw AgenticCLIError
                        .clipboardWriteFailed
                }

                return
            }

            print(
                text
            )
        }
    }
}

struct HostManifestOptions:
    Sendable,
    ArgumentParsed
{
    typealias ArgumentPayload =
        Payload

    let workspace: String
    let sessionID: String?
    let copy: Bool

    init(
        arguments: Payload
    ) throws {
        let workspace =
            arguments.workspace
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        guard !workspace.isEmpty else {
            throw AgenticCLIError
                .blankWorkspace
        }

        self.workspace =
            workspace

        let sessionID =
            arguments.sessionID?
                .trimmingCharacters(
                    in:
                        .whitespacesAndNewlines
                )

        self.sessionID =
            sessionID.flatMap {
                $0.isEmpty
                    ? nil
                    : $0
            }

        self.copy =
            arguments.copy
    }

    struct Payload:
        ArgumentGroup
    {
        @Opt(
            "workspace",
            short: "w",
            default: ".",
            help:
                "Workspace root included in the capability manifest. Defaults to the current directory."
        )
        var workspace: String

        @Opt(
            "session",
            help:
                "Optional host session identifier included in the capability manifest."
        )
        var sessionID: String?

        @Flag(
            "copy",
            help:
                "Copy the capability manifest to the clipboard instead of printing it."
        )
        var copy: Bool

        init() {}
    }
}
