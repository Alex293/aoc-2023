import Algorithms

struct Day00: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var lines: [Substring] {
    data.split(separator: "\n")
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    lines
      .reduce(into: 0) { sum, line in
        let first: Int? = line.first(where: { $0.isNumber }).flatMap { Int("\($0)") }
        let last: Int? = line.last(where: { $0.isNumber }).flatMap { Int("\($0)") }
        guard let first, let last else { return }
        sum += first * 10 + last
      }
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let indexedSearchTerms = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
      .indexed()

    return lines
      .reduce(into: Int(0)) { (sum: inout Int, line: Substring) in
        var first: Int?
        for c in line.indexed() {
          if c.element.isNumber {
            first = Int("\(c.element)")
            break
          }
          let match = indexedSearchTerms
            .filter { $0.element.first == c.element }
            .first(where: { line[c.index...].hasPrefix($0.element) })
          if let match {
            first = match.index + 1
            break
          }
        }
        var last: Int?
        for c in line.indexed().reversed() {
          if c.element.isNumber {
            last = Int("\(c.element)")
            break
          }
          let match = indexedSearchTerms
            .filter { $0.element.last == c.element }
            .first(where: { line[...c.index].hasSuffix($0.element) })
          if let match {
            last = match.index + 1
            break
          }
        }
        guard let first, let last else { return }
        sum += first * 10 + last
      }
  }
}
