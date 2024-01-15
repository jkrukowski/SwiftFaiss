import SwiftFaissC

public class IDMap: BaseIndex {
    public internal(set) var indexPointer: IndexPointer
    // we keep a reference to the subIndex to prevent it from being deallocated
    private let subIndex: (any BaseIndex)?

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_Index_free(indexPointer.pointer)
        }
    }

    init(indexPointer: IndexPointer) {
        self.indexPointer = indexPointer
        subIndex = nil
    }

    init(indexPointer: IndexPointer, subIndex: (any BaseIndex)?) {
        self.indexPointer = indexPointer
        self.subIndex = subIndex
    }

    static func from(_ indexPointer: IndexPointer) -> IDMap? {
        faiss_IndexIDMap_cast(indexPointer.pointer) == nil ? nil : IDMap(indexPointer: indexPointer, subIndex: nil)
    }

    public convenience init(subIndex: any BaseIndex) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexIDMap_new(
                indexPtr,
                subIndex.indexPointer.pointer
            )
        )
        self.init(indexPointer: IndexPointer(indexPtr.pointee!), subIndex: subIndex)
    }

    public func idMap() -> [Int] {
        let result = UnsafeMutablePointer<UnsafeMutablePointer<Int64>?>.allocate(capacity: 1)
        defer { result.deallocate() }
        let size = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        defer { size.deallocate() }
        faiss_IndexIDMap_id_map(
            indexPointer.pointer,
            result,
            size
        )
        return Array(UnsafeBufferPointer(start: result.pointee, count: size.pointee)).map { Int($0) }
    }
}
