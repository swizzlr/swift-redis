import Redis
import XCTest

final class GetSetTest: XCTestCase {

  let context: Redis = Redis(context: newContext())

  func testThatWeCanGet() {
    let reply = context.issue(command: .SET, withArguments: .SET("testThatWeCanGet", "success"))
    XCTAssertEqual("OK", reply)
    if let getReply = context.issue(command: .GET, withArguments: .GET("testThatWeCanGet")) {
      XCTAssertEqual("success", getReply)
    }
    else {
      XCTAssertNil("Fail")
    }
  }

  func testThatWeCanSet() {
      let reply = context.issue(command: .SET, withArguments: .SET("testThatWeCanSet", "success"))
      XCTAssertEqual("OK", reply)
  }
  static var allTests: [(String, GetSetTest -> () throws -> Void)] {
    return [
      ("testThatWeCanSet", testThatWeCanSet),
      ("testThatWeCanGet", testThatWeCanGet)
    ]
  }
}
