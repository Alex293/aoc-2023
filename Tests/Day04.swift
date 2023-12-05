import XCTest
import Parsing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day04Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  func testPart1() throws {
    let challenge = Day04(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "35")
  }

  func testPart2() throws {
    let challenge = Day04(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "46")
  }

//  func testReduction() throws {
//    let first = [
//      0:2,
//      3:4,
//      12:9,
//    ]
//
//    let second = [
//      2:3,
//      4:5,
//      6:8
//    ]
//
//    let res = [Int: Int].init(reducing: [first, second])
//    XCTAssertEqual(res, [
//      0:3,
//      3:5,
//      12:9,
//      6:8,
//    ])
//  }
}

//extension [Int: Int] {
//  init(reducing maps: [Self]) {
//    self = maps
//      .dropFirst()
//      .reduce(into: maps.first!) { res, map in
//        var tmp = map
//        for (key, value) in res {
//          if tmp.keys.contains(value) {
//            res[key] = tmp[value]
//            tmp.removeValue(forKey: value)
//          }
//        }
//        for (key, value) in tmp {
//          res[key] = value
//        }
//      }
//  }
//}
