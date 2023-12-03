import Algorithms
import Parsing

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  enum Match {
    case number(Int)
    case symbol(isGear: Bool)
    case dots(count: Int)
  }

  var parsed: [(match: Match, line: Int, index: Int)] {
    let lineParser = Parse {
      Many {
        CountingParser {
          OneOf {
            Prefix(1..., while: { $0 == "." })
              .map { Match.dots(count: $0.count) }
            Digits()
              .map { Match.number($0) }
            Prefix(1, while: { !($0.isNumber || $0 == "." || $0.isNewline || $0.isWhitespace) })
              .map { Match.symbol(isGear: $0 == "*") }
          }
        }
      }
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
      .map {
        $0.indexed().flatMap { line in
          line.element
            .reduce(into: (0, [(match: Match, line: Int, index: Int)]())) { res, sub in
              res.1.append((match: sub.1, line: line.index, index: res.0))
              res.0 += sub.0
            }
            .1
        }
      }
    }

    return try! dataParser.parse(data)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    let parsed = parsed
    return parsed
      .reduce(into: 0) { res, element in
        guard case let .number(value) = element.match else { return }
        guard parsed.contains(where: {
          guard case .symbol = $0.match else { return false }
          let isOnSameOrCLoseLine = abs(element.line - $0.line) <= 1
          let isInRange = (element.index-1)...(element.index+value.length)
          return isOnSameOrCLoseLine && isInRange.contains($0.index)
        }) else { return }
        res += value
      }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let parsed = parsed
    return parsed
      .reduce(into: 0) { res, element in
        guard case let .symbol(isGear) = element.match, isGear else { return }
        let closeNumbers: [Int] = parsed
          .compactMap {
            guard case let .number(value) = $0.match else { return nil }
            let isOnSameOrCLoseLine = abs(element.line - $0.line) <= 1
            let isInRange = ($0.index-1)...($0.index+value.length)
            guard isOnSameOrCLoseLine && isInRange.contains(element.index) else { return nil }
            return value
          }
        if closeNumbers.count == 2 {
          res += closeNumbers[0] * closeNumbers[1]
        }
      }
  }
}

struct CountingParser<Child>: Parser where Child: Parser, Child.Input == Substring {
  typealias Input = Child.Input
  typealias Output = (Int, Child.Output)

  let child: Child

  init(@ParserBuilder<Input> _ build: () -> Child) {
    self.child = build()
  }

  func parse(_ input: inout Child.Input) throws -> (Int, Child.Output) {
    var copy = input
    let result = try child.parse(&copy)
    let length = input.count - copy.count
    input = copy
    return (length, result)
  }
}

extension Int {
  var length: Int {
    var count = 0
    var num = self
    if (num == 0){
      return 1
    }
    while (num > 0){
      num = num / 10
      count += 1
    }
    return count
  }
}
