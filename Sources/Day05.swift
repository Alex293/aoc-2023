import Algorithms
import Parsing

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let races = try! Parsers.races.parse(data)
    return races.reduce(into: 1) { res, race in
      let (time, distance) = race
      let possibilities = (0...time)
        .filter { (time - $0) * $0 > distance }
        .count
      res *= possibilities
    }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let (time, distance) = try! Parsers.race.parse(data)
    return (0...time)
      .filter { (time - $0) * $0 > distance }
      .count
  }
}

private extension Parsers {

  static let races = Parse(input: Substring.self, { zip($0, $1) }) {
    Skip {
      "Time:"
      Many { " " }
    }
    Many {
      Digits()
    } separator: {
      Many { " " }
    }
    Skip { "\n" }
    Skip {
      "Distance:"
      Many { " " }
    }
    Many {
      Digits()
    } separator: {
      Many { " " }
    }
    Skip { Optionally { "\n" } }
  }

  static let race = Parse(input: Substring.self, { ($0, $1) }) {
    Skip {
      "Time:"
      Many { " " }
    }
    Many {
      Digits()
    } separator: {
      Many { " " }
    }
    .map { $0.map { "\($0)" }.joined(separator: "")[...] }
    .pipe { Digits() }
    Skip { "\n" }
    Skip {
      "Distance:"
      Many { " " }
    }
    Many {
      Digits()
    } separator: {
      Many { " " }
    }
    .map { $0.map { "\($0)" }.joined(separator: "")[...] }
    .pipe { Digits() }
    Skip { Optionally { "\n" } }
  }
}
