import Redis
import XCTest

final class PingTests: XCTestCase {

  let context: Redis = Redis(host: "localhost", port: 6379)

  func testThatWeCanConnect() {
    XCTAssertNil(context.error)
  }

  func testThatWeCanPing() {
    let reply = context.command("PING")?.str
    XCTAssertEqual("PONG", reply)
  }
  static var allTests: [(String, PingTests -> () throws -> Void)] {
    return [
      ("testThatWeCanPing", testThatWeCanPing),
      ("testThatWeCanConnect", testThatWeCanConnect)
    ]
  }
}


