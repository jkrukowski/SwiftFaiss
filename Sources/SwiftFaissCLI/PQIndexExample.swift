import ArgumentParser
import Logging
import SwiftFaiss

private let logger = Logger(label: "PQIndexExample")

struct PQIndexExample: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "pq",
        abstract: "Example of using PQIndex"
    )
    @Argument(help: "Query sentence")
    var sentence: String = "Someone sprints with a football"

    mutating func run() async throws {
        let sentences = try loadSentences()
        logger.info("Loaded \(sentences.count) sentences")
        let embeddings = try loadEmbeddings()
        logger.info("Loaded \(embeddings.count) embeddings")

        let d = embeddings[0].count
        let index = try AnyIndex.PQ(d: d, m: 8, metricType: .l2)
        try index.train(embeddings)
        logger.info("Trained index on \(embeddings.count) embeddings")
        try index.add(embeddings)
        logger.info("Added \(index.count) embeddings to index")

        let sentenceEmbeddings = encode([sentence])
        let result = try index.search(sentenceEmbeddings, k: 3)
        logger.info("Most similar to sentence: \(sentence)")
        for (labels, distances) in zip(result.labels, result.distances) {
            for (label, distance) in zip(labels, distances) {
                logger.info("Sentence: \(sentences[label]); Distance: \(distance)")
            }
        }
    }
}
