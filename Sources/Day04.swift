import Algorithms
import Parsing

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Map {
    let sourceRange, destinationRange: Range<Int>

    init(destinationRangeStart: Int, sourceRangeStart: Int, length: Int) {
      self.sourceRange = (sourceRangeStart..<(sourceRangeStart+length))
      self.destinationRange = (destinationRangeStart..<(destinationRangeStart+length))
    }

    func value(_ value: Int) -> Int? {
      guard let index = sourceRange.firstIndex(of: value) else { return nil }
      let distance = sourceRange.distance(from: sourceRange.startIndex, to: index)
      return destinationRange[destinationRange.startIndex.advanced(by: distance)]
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let parser = Parse {
      Parsers.simpleSeeds
      Parsers.almanac
    }

    let (seeds, almanac) = try! parser.parse(data)

    return seeds
      .lazy
      .map { seed in
        almanac.reduce(into: seed) { res, map in
          res = map.firstNonNil { $0.value(res) } ?? res
        }
      }
      .min()! as Int
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() async throws -> Any {
    let parser = Parse {
      Parsers.seedRanges
      Parsers.almanac
    }

    let (seedRanges, almanac) = try! parser.parse(data)
    let mappedRanges = seedRanges.map { ($0.0..<($0.0+$0.1)) }

    return try await parallelTasks(
      iterations: mappedRanges.count,
      concurrency: 8
    ) { (i: Int) -> Int in
      mappedRanges[i]
        .lazy
        .compactMap { seed in
          almanac.reduce(into: seed) { res, map in
            res = map.firstNonNil { $0.value(res) } ?? res
          }
        }
        .min() ?? .max
    }
    .min()! as Int
  }
}

private extension Parsers {

  static let seedRanges = Parse(input: Substring.self) {
    Skip { "seeds: " }
    Many {
      Digits()
      " "
      Digits()
    } separator: {
      " "
    }
    Skip { "\n\n" }
  }

  static let simpleSeeds = Parse(input: Substring.self) {
    Skip { "seeds: " }
    Many {
      Digits()
    } separator: {
      " "
    }
    Skip { "\n\n" }
  }

  static let almanac = Parse(
    input: Substring.self
  ) {
    Many {
      Skip {
        OneOfMany([
          "seed-to-soil",
          "soil-to-fertilizer",
          "fertilizer-to-water",
          "water-to-light",
          "light-to-temperature",
          "temperature-to-humidity",
          "humidity-to-location",
        ])
        " map:\n"
      }
      Many {
        Parse(Day04.Map.init) {
          Digits()
          Skip { " " }
          Digits()
          Skip { " " }
          Digits()
        }
      } separator: {
        "\n"
      }
    } separator: {
      "\n\n"
    }
    Skip { Optionally { "\n" } }
  }
}

func parallelTasks<T>(
  iterations: Int,
  concurrency: Int,
  block: @escaping ((Int) async throws -> T)
) async throws -> [T] {
  try await withThrowingTaskGroup(of: T.self) { group in
    var result: [T] = []

    for i in 0..<iterations {
      if i >= concurrency {
        if let res = try await group.next() {
          result.append(res)
        }
      }
      group.addTask {
        try await block(i)
      }
    }

    for try await res in group {
      result.append(res)
    }
    return result
  }
}
