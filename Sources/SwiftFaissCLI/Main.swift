import ArgumentParser
import Foundation

let subcommands: [any AsyncParsableCommand.Type] = [
    FlatIndexExample.self,
    IVFFlatIndexExample.self
]

@main
struct SwiftFaissCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-faiss",
        abstract: "Example of using SwiftFaiss",
        subcommands: subcommands
    )
}