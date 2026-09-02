import Agentic
import AgenticApple
import AgenticExecution
import AgenticDomains
import AgenticRuntime
import AgenticRuntimeCommands
import AgenticMediaApple

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

            // adapter(.apple_foundation_models) {
            //     AppleFoundationModelAdapter()
            // }

            modelProvider(
                // AppleFoundationModelProfileProvider()
                AppleFoundationModelProvider()
            )

            voiceInput(
                AppleVoiceInputProvider()
            )
        }
    }

    static func main() async {
        await AgenticRuntimeCommand<Application>.main()
    }
}
