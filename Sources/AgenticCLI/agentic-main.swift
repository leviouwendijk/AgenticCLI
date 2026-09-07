import Agentic
import AgenticSkills
import AgenticApple
import AgenticAWS
import AgenticOllama
import AgenticExecution
import AgenticDomains
import AgenticRuntime
import AgenticCommandLine
import AgenticHost
import AgenticInterfaces
import AgenticMedia
import AgenticMediaApple

private let bedrockModel = "us.anthropic.claude-opus-4-6-v1"

private let bedrockProfile = BedrockModelProfiles.profile(
    identifier: "aws_bedrock:claude_opus_4.6",
    model: bedrockModel,
    modelID: KnownModel.anthropic.`claude_opus_4.6`,
    title: "Claude Opus 4.6",
    capabilities: [
        .text,
        .tool_use,
        .streaming,
        .structured_output,
        .reasoning,
    ],
    cost: .premium
)

@main
enum AgenticCLI {
    struct Application:
        AgenticApplicationProviding,
        AgenticVoiceInputProviding
    {
        static let voiceInputProvider: (any VoiceInputProvider)? =
            AppleVoiceInputProvider()

        static let application = Agentic.application(
            "agentic",
            title: "Agentic",
            metadata: [
                "source": "agentic-cli",
            ]
        ) {
            tools {
                collection(
                    "core",
                    title: "Core",
                    defaultExposure: .included
                ) {
                    CoreToolSet()
                }

                collection(
                    "domains",
                    title: "Domains",
                    defaultExposure: .included
                ) {
                    AgenticDomainsToolSet()
                }

                collection(
                    "media",
                    title: "Media",
                    defaultExposure: .excluded
                ) {
                    AgenticMediaToolSet()
                }
            }

            skills {
                CoreSkillProvider()
            }

            // adapter(.apple_foundation_models) {
            //     AppleFoundationModelAdapter()
            // }

            modelProvider(
                // AppleFoundationModelProfileProvider()
                AppleFoundationModelProvider()
            )

            modelProvider(
                OllamaModelProvider()
            )

            modelProvider(
                BedrockModelProvider(
                    defaultModelIdentifier: bedrockModel,
                    profiles: [
                        bedrockProfile,
                    ]
                )
            )

        }
    }

    static func main() async {
        await Agentic.CommandLine<Application>.main()
    }
}
