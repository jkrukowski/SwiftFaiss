import SwiftFaissC

// Index that applies a LinearTransform transform on vectors before handing them over to a subIndex
public final class PreTransformIndex: BaseIndex {
    public internal(set) var indexPointer: IndexPointer
    // we keep a reference to the subIndex and all vectorTransform to prevent them from being deallocated
    private let subIndex: (any BaseIndex)?
    private var vectorTransforms: [any BaseVectorTransform]

    deinit {
        if isKnownUniquelyReferenced(&indexPointer) {
            faiss_IndexPreTransform_free(indexPointer.pointer)
        }
    }

    init(
        indexPointer: IndexPointer,
        subIndex: (any BaseIndex)?,
        vectorTransforms: [any BaseVectorTransform]
    ) {
        self.indexPointer = indexPointer
        self.subIndex = subIndex
        self.vectorTransforms = vectorTransforms
    }

    public convenience init(
        vectorTransform: any BaseVectorTransform,
        subIndex: any BaseIndex
    ) throws {
        let indexPtr = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        defer { indexPtr.deallocate() }
        try IndexError.check(
            faiss_IndexPreTransform_new_with_transform(
                indexPtr,
                vectorTransform.indexPointer.pointer,
                subIndex.indexPointer.pointer
            )
        )
        self.init(
            indexPointer: IndexPointer(indexPtr.pointee!),
            subIndex: subIndex,
            vectorTransforms: [vectorTransform]
        )
    }

    public func prepend(vectorTransform: any BaseVectorTransform) throws {
        try IndexError.check(
            faiss_IndexPreTransform_prepend_transform(
                indexPointer.pointer,
                vectorTransform.indexPointer.pointer
            )
        )
        vectorTransforms.append(vectorTransform)
    }
}
