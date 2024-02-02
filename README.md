# Swift Faiss

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjkrukowski%2FSwiftFaiss%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jkrukowski/SwiftFaiss)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjkrukowski%2FSwiftFaiss%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jkrukowski/SwiftFaiss)

Use [Faiss](https://github.com/facebookresearch/faiss) in Swift.

Based on [Faiss Mobile](https://github.com/DeveloperMindset-com/faiss-mobile) and [OpenMP Mobile](https://github.com/DeveloperMindset-com/openmp-mobile).

## Usage

Command line demo

```
$ swift run swift-faiss <subcommand> <options>
```

Available subcommands:

- `flat`: create a `FlatIndex`, add vectors to it and search for the most similar sentences.
- `ivfflat`: create an `IVFFlatIndex`, train and add vectors to it and search for the most similar sentences.
- `pq`: create an `PQIndex`, train and add vectors to it and search for the most similar sentences.
- `clustering`: k-means clustering example.

Command line help

```
$ swift run swift-faiss --help
```

In your own code

```swift
import SwiftFaiss

let embeddings: [[Float]] = [
    [0.1, 0.2, 0.3],
    [0.4, 0.5, 0.6],
    [0.7, 0.8, 0.9],
    [1.0, 1.1, 1.2],
    [1.3, 1.4, 1.5],
    [1.6, 1.7, 1.8]
]
let d = embeddings[0].count
let index = try FlatIndex(d: d, metricType: .l2)
try index.add(embeddings)

let result = try index.search([[0.1, 0.5, 0.9]], k: 2)
// do something with result
```

## Installation

### Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) and specify dependency in `Package.swift` by adding:

```swift
.package(url: "https://github.com/jkrukowski/SwiftFaiss.git", from: "0.0.7")
```

## Format code

```
$ swift package plugin --allow-writing-to-package-directory swiftformat
```

## Tests

```
$ swift test
```

## More info

- [Faiss: The Missing Manual](https://www.pinecone.io/learn/series/faiss/)
- [Faiss C API](https://github.com/facebookresearch/faiss/blob/main/c_api/INSTALL.md)
