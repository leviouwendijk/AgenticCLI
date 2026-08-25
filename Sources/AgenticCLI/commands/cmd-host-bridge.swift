import Agentic
import AgenticInterfaces
import Arguments
import Clipboard
import Foundation

extension AgenticHostCommand {
    enum Bridge:
        ParsedArgumentCommand
    {
        typealias Options =
            HostBridgeOptions

        static let name =
            "bridge"

        static func run(
            _ options: HostBridgeOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let call: AgentToolCall

            if options.standardInput {
                call = try AgenticCLI.io.toolcall
                    .read()
            } else {
                guard let text =
                    Clipboard.system.read(),
                    !text
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
                else {
                    throw AgenticCLIError
                        .missingClipboardInput
                }

                call = try AgenticCLI.io.toolcall
                    .decode(
                        Data(text.utf8)
                    )
            }

            let approvalPicker:
                TerminalApprovalPicker?

            if AgenticCLI.io.stdin
                .reconnectToTerminal()
            {
                approvalPicker =
                    TerminalApprovalPicker()
            } else {
                approvalPicker = nil
            }

            let host =
                try AgenticCLIToolRuntime
                    .host(
                        workspacePath:
                            options.workspace,
                        sessionID:
                            options.sessionID,
                        approvalHandler:
                            approvalPicker
                    )

            let envelope =
                try await host.invoke(
                    call
                )

            if options.standardInput {
                try AgenticCLI.io.json.write(
                    envelope
                )
            } else {
                let text = try AgenticCLI.io.json.text(
                    envelope
                )

                guard Clipboard.system.write(
                    text
                ) else {
                    throw AgenticCLIError
                        .clipboardWriteFailed
                }

                print(
                    "Invoked \(call.name) [\(call.id)] — result copied to clipboard."
                )
            }
        }
    }
}

struct HostBridgeOptions:
    Sendable,
    ArgumentParsed
{
    typealias ArgumentPayload =
        Payload

    let workspace: String
    let sessionID: String?
    let standardInput: Bool

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

        self.standardInput =
            arguments.standardInput
    }

    struct Payload:
        ArgumentGroup
    {
        @Opt(
            "workspace",
            short: "w",
            default: ".",
            help:
                "Workspace root used for governed tool invocation. Defaults to the current directory."
        )
        var workspace: String

        @Opt(
            "session",
            help:
                "Optional host session identifier used for governed tool invocation."
        )
        var sessionID: String?

        @Flag(
            "stdin",
            help:
                "Read AgentToolCall JSON from standard input and write the result to standard output instead of using the system clipboard."
        )
        var standardInput: Bool

        init() {}
    }
}
