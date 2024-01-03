import SwiftFaiss

let index = try FaissIndex(d: 4, metricType: .l2, description: "Flat")
try index.add([1, 2, 3, 4])
try index.add([10, 20, 30, 40])
try index.add([1, 2, 3, 4])
print(index.isTrained, index.count)
let result = try index.search([1, 2, 3, 4], k: 100)
print(result.distances, result.labels)
try print(index.reconstruct(Int(result.labels[0])))
