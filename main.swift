import CHiRedis
import Foundation

print("Connecting")
let env = NSProcessInfo.processInfo().environment
let ip: String = env["REDIS_PORT_6379_TCP_ADDR"]!
let port: Int32 =  Int32(env["REDIS_PORT_6379_TCP_PORT"]!)!
let context = redisConnect(ip, port)
print(context.memory)

