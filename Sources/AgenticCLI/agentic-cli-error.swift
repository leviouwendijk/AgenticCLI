import Foundation

enum AgenticCLIError: Error, LocalizedError, Sendable {
    case missingStandardInput
    case missingClipboardInput
    case clipboardWriteFailed
    case invalidWorkspace(String)
    case blankToolName
    case blankWorkspace

    var errorDescription: String? {
        switch self {
        case .missingStandardInput:
            return """
            Missing AgentToolCall JSON on standard input.
            """

        case .missingClipboardInput:
            return """
            Missing AgentToolCall JSON on the system clipboard.
            """

        case .clipboardWriteFailed:
            return """
            Failed to write output to the system clipboard.
            """

        case .invalidWorkspace(let path):
            return """
            Workspace does not exist or is not a directory: \(path)
            """

        case .blankToolName:
            return "Tool name cannot be blank."

        case .blankWorkspace:
            return "Workspace path cannot be blank."
        }
    }
}
