import Algorithms
import Parsing

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  struct Line {
    var id: Int
    var draws: [Draw]
    typealias Draw = [Color: Int]
  }

  enum Color: String, CaseIterable {
    case red, green, blue
  }

  var parsed: [Line] { try! Parsers.day01.parse(data[...]) }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    parsed
      .reduce(into: 0) { sum, line in
        let isValid = line.draws.allSatisfy {
            $0[.red, default: 0] <= 12 && $0[.green, default: 0] <= 13 && $0[.blue, default: 0] <= 14
        }
        guard isValid else { return }
        sum += line.id
      }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    parsed
      .reduce(into: 0) { sum, line in
        let maxs = line.draws
          .reduce(into: (0,0,0)) { sum, draw in
            if let red = draw[.red], red > sum.0 {
              sum.0 = red
            }
            if let green = draw[.green], green > sum.1 {
              sum.1 = green
            }
            if let blue = draw[.blue], blue > sum.2 {
              sum.2 = blue
            }
          }
        sum += maxs.0 * maxs.1 * maxs.2
      }
  }
}

private extension Parsers {
  static let draw = Many(into: Day01.Line.Draw()) { $0[$1.0] = $1.1 }
    element: {
      OneOf {
        for color in Day01.Color.allCases {
          Parse(input: Substring.self) {
            " "
            Int.parser()
            " \(color.rawValue)"
          }
          .map { (color, $0) }
        }
      }
    }
    separator: {
      ","
    }

  static let line = Parse(input: Substring.self) {
    Day01.Line(id: $0, draws: $1)
  } with: {
    "Game "
    Int.parser()
    ":"
    Many {
      draw
    } separator: {
      ";"
    }
  }

  static let day01 = Parse(input: Substring.self) {
    Many {
      line
    } separator: {
      "\n"
    } terminator: {
      OneOf {
        "\n"
        ""
      }
    }
  }
}
