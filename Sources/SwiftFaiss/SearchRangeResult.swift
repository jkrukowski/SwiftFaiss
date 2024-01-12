import SwiftFaissC

public struct SearchRangeResult {
    public let lims: [Int]
    public let distances: [[Float]]
    public let labels: [[Int]]

    init(lims: [Int], distances: [[Float]], labels: [[Int]]) {
        self.lims = lims
        self.distances = distances
        self.labels = labels
    }
}

final class SearchRangeResultProcessor {
    private var indexPointer: IndexPointer

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_RangeSearchResult_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    private var nq: Int {
        Int(faiss_RangeSearchResult_nq(indexPointer.pointer))
    }

    private func lims() -> [Int] {
        let lims = UnsafeMutablePointer<UnsafeMutablePointer<Int>?>.allocate(capacity: 1)
        defer { lims.deallocate() }
        faiss_RangeSearchResult_lims(indexPointer.pointer, lims)
        return Array(UnsafeBufferPointer(start: lims.pointee, count: nq + 1))
    }

    func result() -> SearchRangeResult {
        let lims = lims()
        let capacity = lims.last ?? 0
        let distances = UnsafeMutablePointer<UnsafeMutablePointer<Float>?>.allocate(capacity: 1)
        defer { distances.deallocate() }
        let labels = UnsafeMutablePointer<UnsafeMutablePointer<Int64>?>.allocate(capacity: 1)
        defer { labels.deallocate() }
        faiss_RangeSearchResult_labels(
            indexPointer.pointer,
            labels,
            distances
        )
        let offset = nq + 1
        return SearchRangeResult(
            lims: lims,
            distances: stride(from: 0, to: capacity, by: offset).map {
                Array(UnsafeBufferPointer(start: distances.pointee!.advanced(by: $0), count: offset))
            },
            labels: stride(from: 0, to: capacity, by: offset).map {
                Array(UnsafeBufferPointer(start: labels.pointee!.advanced(by: $0), count: offset)).map { Int($0) }
            }
        )
    }
}
