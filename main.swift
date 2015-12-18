import CHiRedis
import Foundation

func swiftRedisCommand(context: UnsafeMutablePointer<redisContext>, command: String) -> UnsafeMutablePointer<Void> {
  return withVaList([]) { redisvCommand(context, command, $0) }
}

print("Connecting")
let env = NSProcessInfo.processInfo().environment
let ip: String = env["REDIS_PORT_6379_TCP_ADDR"]!
let port: Int32 =  Int32(env["REDIS_PORT_6379_TCP_PORT"]!)!
let context = redisConnect(ip, port)
print(context.memory)

let command = swiftRedisCommand(context, command: "PING").memory as! redisReply
print(command.memory.str)
