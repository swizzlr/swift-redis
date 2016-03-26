final class MalformedCommandTests: XCTestCase {
  func testThatMalformedCommandsReturnNil() {
    "HELLO WORLD".withCString { b in
      let reply = redisCommand(context: newContext(), command: "SET key %ll", args: b)
      XCTAssertNil(reply)
    }

  }
  static var allTests: [(String, MalformedCommandTests -> () throws -> Void)] {
    return [
      ("testThatMalformedCommandsReturnNil", testThatMalformedCommandsReturnNil)
    ]
  }
}

final class MalformedContextTests: XCTestCase {
  func testThatUnreachableContextsAreNotCreatable() {
    let ctx = redisConnect(ip: "THIS IS NOT AN IP", port: 65000)
    XCTAssertNotNil(ctx.errstr)

  }
  static var allTests: [(String, MalformedContextTests -> () throws -> Void)] {
    return [
      ("testThatUnreachableContextsAreNotCreatable", testThatUnreachableContextsAreNotCreatable)
    ]
  }
}

import XCTest
import hiredis
