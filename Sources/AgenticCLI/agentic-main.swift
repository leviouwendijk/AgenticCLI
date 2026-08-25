import Arguments
import Foundation

@main
enum AgenticCLICommand: ArgumentCommand {
    static let name = "agentic"
    static let defaultChild = HelpCommand.self

    static let children: [ArgumentCommandType] = [
        HelpCommand.self,
        AgenticToolCommand.self,
        AgenticHostCommand.self,
    ]

    static func main() async {
        await ArgumentProgram.main(
            command: Self.self,
            errorHandler: { error in
                AgenticCLI.io.error.write(
                    error
                )

                return 1
            }
        )
    }
}

enum HelpCommand: RunnableArgumentCommand {
    static let name = "help"

    static func run(
        _ invocation: ParsedInvocation
    ) async throws {
        _ = invocation

        print(
            ArgumentHelpRenderer().render(
                command: try AgenticCLICommand.spec()
            )
        )
    }
}
