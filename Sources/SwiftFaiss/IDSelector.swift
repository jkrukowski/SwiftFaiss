import SwiftFaissC

final class IDSelector {
    let indexPointer: IndexPointer

    deinit {
        faiss_IDSelector_free(indexPointer.pointer)
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
    }

    static func range(_ range: Range<Int>) throws -> IDSelector {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IDSelectorRange_new(
                indexPtr,
                Int64(range.lowerBound),
                Int64(range.upperBound)
            )
        )
        return IDSelector(indexPointer: IndexPointer(indexPtr.pointee!))
    }

    static func batch(_ xs: [Int]) throws -> IDSelector {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IDSelectorBatch_new(
                indexPtr,
                xs.count,
                xs.map { Int64($0) }
            )
        )
        return IDSelector(indexPointer: IndexPointer(indexPtr.pointee!))
    }
}
