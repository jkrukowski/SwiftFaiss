import ArgumentParser
import Foundation

let subcommands: [any AsyncParsableCommand.Type] = [
    ClusteringExample.self,
    FlatIndexExample.self,
    IVFFlatIndexExample.self,
    PQIndexExample.self
]

@main
struct SwiftFaissCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-faiss",
        abstract: "Example of using SwiftFaiss",
        subcommands: subcommands
    )
}
