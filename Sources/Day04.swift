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

    let seedChunks = seedRanges.flatMap { $0.lazy.chunks(ofCount: 10_000) }

    let tasks = seedChunks.map { chunk in
      Task {
        chunk
          .lazy
          .map { seed in
            almanac.reduce(into: seed) { res, map in
              if let newValue = map.firstNonNil({ $0.value(res) }) {
                res = newValue
              }
            }
          }
          .min()
      }
    }

    var min = Int.max
    for task in tasks {
      if let value = await task.value, value < min {
        min = value
      }
    }
    return min
  }
}

private extension Parsers {

  static let seedRanges = Parse(input: Substring.self, { $0.map( { ($0..<($0+$1)) }) }) {
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
