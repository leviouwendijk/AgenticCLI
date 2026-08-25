import Arguments
import Foundation

struct ToolDescribeOptions:
    Sendable,
    ArgumentParsed
{
    typealias ArgumentPayload = Payload

    let name: String

    init(
        arguments: Payload
    ) throws {
        let name = arguments.name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !name.isEmpty else {
            throw AgenticCLIError.blankToolName
        }

        self.name = name
    }

    struct Payload: ArgumentGroup {
        @Arg(
            "name",
            help: "Registered Agentic tool name.",
            default: ""
        )
        var name: String

        init() {}
    }
}

struct ToolCallCommandOptions:
    Sendable,
    ArgumentParsed
{
    typealias ArgumentPayload = Payload

    let workspace: String
    let sessionID: String?

    init(
        arguments: Payload
    ) throws {
        let workspace = arguments.workspace.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !workspace.isEmpty else {
            throw AgenticCLIError.blankWorkspace
        }

        self.workspace = workspace

        let sessionID = arguments.sessionID?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        self.sessionID = sessionID.flatMap {
            $0.isEmpty
                ? nil
                : $0
        }
    }

    struct Payload: ArgumentGroup {
        @Opt(
            "workspace",
            short: "w",
            default: ".",
            help: "Workspace root. Defaults to the current directory."
        )
        var workspace: String

        @Opt(
            "session",
            help: "Optional host-call session identifier."
        )
        var sessionID: String?

        init() {}
    }
}
