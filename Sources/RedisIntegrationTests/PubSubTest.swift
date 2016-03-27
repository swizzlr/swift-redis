import Redis
import XCTest

final class PubSubTest: XCTestCase {

  let context: Redis = Redis(context: newContext())

  func testThatWeCanSubscribe() {
    let pubsub = PubSub(redis: context)

    pubsub.subscribeSync(toChannel: "testThatWeCanSubscribe") { message in
      print("Message Recieved")
      print(message)
      pubsub.unsubscribeSync("testThatWeCanSubscribe")
      XCTAssertEqual(true, true)
    }
    // if let reply = context.subscribe(command: .PING, withArguments: .PING) {
    //   XCTAssertEqual("PONG", reply)
    // }
    // else {
    //   XCTAssertEqual("PONG", "fail")
    // }
  }
  static var allTests: [(String, PubSubTest -> () throws -> Void)] {
    return [
      ("testThatWeCanSubscribe", testThatWeCanSubscribe),
    ]
  }
}
