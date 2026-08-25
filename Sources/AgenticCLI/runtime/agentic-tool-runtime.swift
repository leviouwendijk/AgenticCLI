import Agentic
import AgenticInterfaces
import AgenticGit
import AgenticSwift
import Foundation

enum AgenticCLIToolRuntime {
    static func registry() throws -> ToolRegistry {
        var registry = ToolRegistry()

        try CoreFileToolSet().register(
            into: &registry
        )

        try AgenticSwiftToolSet().register(
            into: &registry
        )

        try AgenticGitToolSet().register(
            into: &registry
        )

        return registry
    }

    static func host(
        workspacePath: String? = nil,
        sessionID: String? = nil,
        approvalHandler: (any ToolApprovalHandler)? = nil
    ) throws -> AgenticToolHost {
        let registry = try registry()
        let workspace: AgentWorkspace?

        if let workspacePath {
            workspace = try makeWorkspace(
                workspacePath
            )
        } else {
            workspace = nil
        }

        return AgenticToolHost(
            registry: registry,
            policy: ToolExecutionPolicy(
                autonomyMode: .auto_observe
            ),
            context: .init(
                workspace: workspace,
                sessionID: sessionID,
                executionMode: .host_call,
                metadata: [
                    "source": "agentic-cli",
                ]
            ),
            approvalHandler: approvalHandler
        )
    }
}

private extension AgenticCLIToolRuntime {
    static func makeWorkspace(
        _ rawPath: String
    ) throws -> AgentWorkspace {
        let expanded = NSString(
            string: rawPath
        ).expandingTildeInPath

        let currentDirectory = URL(
            fileURLWithPath: FileManager.default.currentDirectoryPath,
            isDirectory: true
        )

        let candidate: URL

        if expanded.hasPrefix("/") {
            candidate = URL(
                fileURLWithPath: expanded,
                isDirectory: true
            )
        } else {
            candidate = URL(
                fileURLWithPath: expanded,
                isDirectory: true,
                relativeTo: currentDirectory
            )
        }

        let root = candidate
            .standardizedFileURL
            .resolvingSymlinksInPath()

        var isDirectory: ObjCBool = false

        guard FileManager.default.fileExists(
            atPath: root.path,
            isDirectory: &isDirectory
        ),
              isDirectory.boolValue else {
            throw AgenticCLIError.invalidWorkspace(
                root.path
            )
        }

        return try AgentWorkspace(
            root: root
        )
    }
}
