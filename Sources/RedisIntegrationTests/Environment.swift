struct Environment {
  static let Environment = env
  static let IP = env["REDIS_PORT_6379_TCP_ADDR"]!
  static let Port = Int(env["REDIS_PORT_6379_TCP_PORT"]!)!
}

func newContext() -> redisContext {
 return redisConnect(ip: Environment.IP, port: Environment.Port)
}

private let env = NSProcessInfo.processInfo().environment

import hiredis
import Foundation
