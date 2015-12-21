final class MalformedCommandTests: XCTestCase {
  func testThatMalformedCommandsReturnNil() {
    "HELLO WORLD".withCString { b in
      let reply = redisCommand(context: newContext(), command: "SET key %ll", args: b)
      XCTAssertNil(reply)
    }

  }
  var allTests: [(String, () -> Void)] {
    return [
      ("testThatMalformedCommandsReturnNil", testThatMalformedCommandsReturnNil)
    ]
  }
}

import XCTest
import hiredis
