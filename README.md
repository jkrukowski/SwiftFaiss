# Swift Faiss

Use [Faiss](https://github.com/facebookresearch/faiss) in Swift.

Based on [Faiss Mobile](https://github.com/DeveloperMindset-com/faiss-mobile) and [OpenMP Mobile](https://github.com/DeveloperMindset-com/openmp-mobile).

## Run demo

```
$ swift run swift-faiss <subcommand> <options>
```

Available subcommands:

- `flat`: create a `FlatIndex`, add vectors to it and search for the most similar sentences.
- `ivfflat`: create an `IVFFlatIndex`, train and add vectors to it and search for the most similar sentences.
- `pq`: create an `PQIndex`, train and add vectors to it and search for the most similar sentences.

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
