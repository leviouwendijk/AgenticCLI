import AgenticInterfaces
import Arguments

enum AgenticToolCommand: ArgumentCommand {
    static let name = "tool"
    static let defaultChild = Help.self

    static let children: [ArgumentCommandType] = [
        Help.self,
        List.self,
        Describe.self,
        Preflight.self,
        Invoke.self,
    ]

    enum Help: RunnableArgumentCommand {
        static let name = "help"

        static func run(
            _ invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            print(
                ArgumentHelpRenderer().render(
                    command: try AgenticToolCommand.spec()
                )
            )
        }
    }

    enum List: RunnableArgumentCommand {
        static let name = "list"

        static func run(
            _ invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let host = try AgenticCLIToolRuntime.host()

            try AgenticCLI.io.json.write(
                host.list()
            )
        }
    }

    enum Describe: ParsedArgumentCommand {
        typealias Options = ToolDescribeOptions

        static let name = "describe"

        static func run(
            _ options: ToolDescribeOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let host = try AgenticCLIToolRuntime.host()

            try AgenticCLI.io.json.write(
                try host.describe(
                    options.name
                )
            )
        }
    }

    enum Preflight: ParsedArgumentCommand {
        typealias Options = ToolCallCommandOptions

        static let name = "preflight"

        static func run(
            _ options: ToolCallCommandOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let call = try AgenticCLI.io.toolcall.read()
            let host = try AgenticCLIToolRuntime.host(
                workspacePath: options.workspace,
                sessionID: options.sessionID
            )

            try AgenticCLI.io.json.write(
                try await host.preflight(
                    call
                )
            )
        }
    }

    enum Invoke: ParsedArgumentCommand {
        typealias Options = ToolCallCommandOptions

        static let name = "invoke"

        static func run(
            _ options: ToolCallCommandOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let call = try AgenticCLI.io.toolcall.read()

            let approvalPicker: TerminalApprovalPicker?

            if AgenticCLI.io.stdin
                .reconnectToTerminal()
            {
                approvalPicker = TerminalApprovalPicker()
            } else {
                approvalPicker = nil
            }

            let host = try AgenticCLIToolRuntime.host(
                workspacePath: options.workspace,
                sessionID: options.sessionID,
                approvalHandler: approvalPicker
            )

            try AgenticCLI.io.json.write(
                try await host.invoke(
                    call
                )
            )
        }
    }
}
