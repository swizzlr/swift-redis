final class PingTests: XCTestCase {
  let context: redisContext = newContext()

  func testThatWeCanConnect() {
    XCTAssertNil(context.errstr)
  }

  func testThatWeCanPing() {
    let reply = redisCommand(context: context, command: "PING")?.str
    XCTAssertEqual("PONG", reply)
  }
  static var allTests: [(String, PingTests -> () throws -> Void)] {
    return [
      ("testThatWeCanPing", testThatWeCanPing),
      ("testThatWeCanConnect", testThatWeCanConnect)
    ]
  }
}

import hiredis
import XCTest
