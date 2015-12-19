let env = NSProcessInfo.processInfo().environment
let ip = env["REDIS_PORT_6379_TCP_ADDR"]!
let port = Int(env["REDIS_PORT_6379_TCP_PORT"]!)!

final class PingTests: XCTestCase {
  let context: Context = connect(ip: ip, port: port)

  func testThatWeCanConnect() {
    XCTAssertNotNil(context)
  }

  func testThatWeCanPing() {
    let reply = command(context: context, command: "PING", args: 0).replyString
    XCTAssertEqual("PONG", reply)
  }
  var allTests: [(String, () -> Void)] {
    return [
      ("testThatWeCanPing", testThatWeCanPing),
      ("testThatWeCanConnect", testThatWeCanConnect)
    ]
  }
}

import Foundation
import Redis
import XCTest
