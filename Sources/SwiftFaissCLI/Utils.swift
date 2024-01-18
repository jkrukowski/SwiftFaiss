import Foundation
import NaturalLanguage

func loadSentences() throws -> [String] {
    let path = Bundle.module.path(forResource: "sentences", ofType: "txt")!
    let data = try String(contentsOfFile: path)
    return data.components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
}

func loadEmbeddings() throws -> [[Float]] {
    let path = Bundle.module.path(forResource: "embeddings", ofType: "txt")!
    let data = try String(contentsOfFile: path)
    return data.components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .map { $0.components(separatedBy: .whitespaces).compactMap { Float($0) } }
}

func encode(_ sentences: [String]) -> [[Float]] {
    let embedding = NLEmbedding.sentenceEmbedding(for: .english)!
    var result = [[Float]]()
    result.reserveCapacity(sentences.count)
    for sentence in sentences {
        if let vector = embedding.vector(for: sentence) {
            result.append(vector.map { Float($0) })
        }
    }
    return result
}
