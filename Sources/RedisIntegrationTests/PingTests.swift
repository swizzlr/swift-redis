final class PingTests: XCTestCase {
  let context: redisContext = newContext()

  func testThatWeCanConnect() {
    XCTAssertNotNil(context)
  }

  func testThatWeCanPing() {
    let reply = redisCommand(context: context, command: "PING")?.replyString
    XCTAssertEqual("PONG", reply)
  }
  var allTests: [(String, () -> Void)] {
    return [
      ("testThatWeCanPing", testThatWeCanPing),
      ("testThatWeCanConnect", testThatWeCanConnect)
    ]
  }
}

import hiredis
import XCTest
