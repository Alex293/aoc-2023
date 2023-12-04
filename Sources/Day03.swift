import Algorithms
import Parsing

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  var parsed: [([Int], [Int])] {
    let lineParser = Parse(input: Substring.self) {
      Skip {
        Prefix(while: { $0 != ":" })
        ":"
        Many {
          " "
        }
      }
      Many(
        element: {
          Digits()
        },
        separator: {
          Many {
            " "
          }
        },
        terminator: {
          " |"
          Many {
            " "
          }
        }
      )
      Many(
        element: {
          Digits()
        },
        separator: {
          Many {
            " "
          }
        }
      )
    }

    let dataParser = Parse {
      Many {
        lineParser
      } separator: {
        "\n"
      } terminator: {
        OneOf {
          "\n"
          ""
        }
      }
    }

    return try! dataParser.parse(data)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let parsed = parsed
    return parsed
      .reduce(into: 0) { res, line in
        let matches = line.1.filter { line.0.contains($0) }.count
        if matches > 0 {
          res += 1 << (matches - 1)
        }
      }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let parsed = parsed

    func countCard(at index: Int) -> Int {
      guard index <= parsed.endIndex else { return 0 }
      let line = parsed[index]
      var matches = line.1.filter { line.0.contains($0) }.count
      var result = 1
      while matches > 0 {
        result += countCard(at: index.advanced(by: matches))
        matches -= 1
      }
      return result
    }

    return parsed.indices.reduce(into: 0, { $0 += countCard(at: $1) })
  }
}
