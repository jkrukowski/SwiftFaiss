import ArgumentParser
import Logging
import SwiftFaiss

private let logger = Logger(label: "IVFFlatIndexExample")

struct IVFFlatIndexExample: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ivfflat",
        abstract: "Example of using IVFFlatIndex"
    )
    @Argument(help: "Query sentence")
    var sentence: String = "Someone sprints with a football"
    @Argument(help: "Number of index partitions")
    var nlist: Int = 50

    mutating func run() async throws {
        let sentences = try loadSentences()
        logger.info("Loaded \(sentences.count) sentences")
        let embeddings = try loadEmbeddings()
        logger.info("Loaded \(embeddings.count) embeddings")

        let d = embeddings[0].count
        let quantizer = try FlatIndex(d: d, metricType: .l2)
        let index = try IVFFlatIndex(quantizer: quantizer, d: d, nlist: nlist)
        try index.train(embeddings)
        logger.info("Trained index on \(index.count) embeddings")
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
