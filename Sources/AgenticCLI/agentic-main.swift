import Agentic
import AgenticDomains
import AgenticRuntime
import AgenticRuntimeCommands

@main
enum AgenticCLI {
    struct Application:
        AgenticApplicationProviding
    {
        static let application = Agentic.application(
            "agentic",
            title: "Agentic",
            metadata: [
                "source": "agentic-cli",
            ]
        ) {
            tools {
                CoreToolSet()
                AgenticDomainsToolSet()
            }
        }
    }

    static func main() async {
        await AgenticRuntimeCommand<Application>.main()
    }
}
