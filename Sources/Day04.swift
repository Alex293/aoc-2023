import Algorithms
import Parsing
import Dispatch

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let parser = Parse {
      Parsers.simpleSeeds
      Parsers.almanac
    }

    let (seeds, almanac) = try! parser.parse(data)

    return seeds
      .compactMap { almanac[$0] }
      .min()!
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let parser = Parse {
      Parsers.seedRanges
      Parsers.almanac
    }

    let (seedRanges, almanac) = try! parser.parse(data)
    return seedRanges
      .flatMap { ($0..<($1+$0)).compactMap { almanac[$0] } }
      .min()!
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

  static let almanac = Parse([Int:Int].init(reducing:)) {
    Many {
      Parse() {
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
        Parse([Int:Int].init(merging:)) {
          Many {
            Parse() {
              Digits()
              Skip { " " }
              Digits()
              Skip { " " }
              Digits()
            }
          } separator: {
            "\n"
          }
        }
      }
    } separator: {
      "\n\n"
    }
    Skip { Optionally { "\n" } }
  }
}

private extension [Int: Int] {

  init(merging maps: [(destinationRangeStart: Int, sourceRangeStart: Int, length: Int)]) {
    self = maps
      .reduce(into: Self()) { res, map in
        let keys = (map.sourceRangeStart..<map.sourceRangeStart + map.length)
        let values = (map.destinationRangeStart..<map.destinationRangeStart + map.length)
        res.merge(
          .init(zip(keys, values), uniquingKeysWith: { _,_ in preconditionFailure("unexpected duplicate") }),
          uniquingKeysWith: { _,_ in preconditionFailure("unexpected duplicate") }
        )
      }
  }

  init(reducing maps: [Self]) {
    self = maps
      .dropFirst()
      .reduce(into: maps.first!) { res, map in
        var tmp = map
        for (key, value) in res {
          if tmp.keys.contains(value) {
            res[key] = tmp[value]
            tmp.removeValue(forKey: value)
          }
        }
        for (key, value) in tmp {
          res[key] = value
        }
      }
  }
}
