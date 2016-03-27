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
      XCTAssertEqual("asdf", message)
    }
  }



  func testThatWeCanSendMessages() {
    let pubsub = PubSub(redis: context)

    pubsub.publishSync(message:"Test", toChannel: "testThatWeCanSendMessages")
    
  }
  static var allTests: [(String, PubSubTest -> () throws -> Void)] {
    return [
      ("testThatWeCanSubscribe", testThatWeCanSubscribe),
        ("testThatWeCanSendMessages", testThatWeCanSendMessages)
    ]
  }
}
