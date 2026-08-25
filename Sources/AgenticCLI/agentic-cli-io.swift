import Agentic
import AgenticInterfaces
import Foundation

#if canImport(Darwin)
import Darwin
#endif

enum AgenticCLI {
    static let io = IO()

    struct IO: Sendable {
        let toolcall = ToolCall()
        let json = JSON()
        let error = ErrorOutput()
        let stdin = Stdin()

        struct ToolCall: Sendable {}
        struct JSON: Sendable {}
        struct ErrorOutput: Sendable {}
        struct Stdin: Sendable {}
    }
}

extension AgenticCLI.IO.ToolCall {
    func read() throws -> AgentToolCall {
        let data =
            FileHandle.standardInput
                .readDataToEndOfFile()

        guard !data.isEmpty else {
            throw AgenticCLIError
                .missingStandardInput
        }

        return try decode(
            data
        )
    }

    func decode(
        _ data: Data
    ) throws -> AgentToolCall {
        try JSONDecoder().decode(
            AgentToolCall.self,
            from: data
        )
    }
}

extension AgenticCLI.IO.JSON {
    func write(
        _ envelope: AgenticToolHostEnvelope
    ) throws {
        let text =
            try text(
                envelope
            )

        FileHandle.standardOutput.write(
            Data(text.utf8)
        )

        FileHandle.standardOutput.write(
            Data(
                [
                    0x0A,
                ]
            )
        )
    }

    func text(
        _ envelope: AgenticToolHostEnvelope
    ) throws -> String {
        let data =
            try AgenticToolHostJSON.encode(
                envelope,
                prettyPrinted: true
            )

        return String(
            decoding: data,
            as: UTF8.self
        )
    }
}

extension AgenticCLI.IO.ErrorOutput {
    func write(
        _ error: Swift.Error
    ) {
        let message: String

        if let localized = error as? LocalizedError,
           let description = localized.errorDescription {
            message = description
        } else {
            message = String(
                describing: error
            )
        }

        writeStandardError(
            "agentic: \(message)\n"
        )
    }
}

private extension AgenticCLI.IO.ErrorOutput {
    func writeStandardError(
        _ text: String
    ) {
        guard let data = text.data(
            using: .utf8
        ) else {
            return
        }

        FileHandle.standardError.write(
            data
        )
    }
}

extension AgenticCLI.IO.Stdin {
    func reconnectToTerminal()
        -> Bool
    {
        #if canImport(Darwin)
        let terminalDescriptor = open(
            "/dev/tty",
            O_RDWR
        )

        guard terminalDescriptor >= 0 else {
            return false
        }

        defer {
            close(
                terminalDescriptor
            )
        }

        guard dup2(
            terminalDescriptor,
            STDIN_FILENO
        ) >= 0 else {
            return false
        }

        return isatty(
            STDIN_FILENO
        ) == 1
        #else
        return false
        #endif
    }
}
