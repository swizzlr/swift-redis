import Redis
import XCTest

final class PingTests: XCTestCase {

  let context: Redis = Redis(context: newContext())

  func testThatWeCanConnect() {
    XCTAssertNil(context.error)
  }

  func testThatWeCanPing() {
    if let reply = context.issue(command: .PING, withArguments: .PING) {
      XCTAssertEqual("PONG", reply)
    }
    else {
      XCTAssertEqual("PONG", "fail")
    }
  }
  static var allTests: [(String, PingTests -> () throws -> Void)] {
    return [
      ("testThatWeCanPing", testThatWeCanPing),
      ("testThatWeCanConnect", testThatWeCanConnect)
    ]
  }
}
