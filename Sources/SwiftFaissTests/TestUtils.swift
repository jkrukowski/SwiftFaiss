import Foundation

func matrix(rows: Int, columns: Int) -> [[Float]] {
    var data: [[Float]] = []
    for i in 0 ..< rows {
        data.append((0 ..< columns).map { index in Float(i + index) })
    }
    return data
}
