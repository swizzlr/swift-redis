// MARK: hiredis wrapper types
public final class redisContext {
  private let cContext: UnsafeMutablePointer<CHiRedis.redisContext>
  private init(cContext: UnsafeMutablePointer<CHiRedis.redisContext>) {
    self.cContext = cContext
  }

  deinit {
    redisFree(cContext)
  }
}

public final class redisReply {
  private let cReply: UnsafeMutablePointer<CHiRedis.redisReply>
  private init(cReply: UnsafeMutablePointer<CHiRedis.redisReply>) {
    self.cReply = cReply
    self.replyString = String.fromCString(cReply.memory.str)
  }
  public let replyString: String?
  deinit {
    freeReplyObject(cReply)
  }
}

// MARK: hiredis wrapper functions

public func redisCommand(context context: redisContext, command: String, args: CVarArgType ...) -> Reply {
  return withVaList(args) { args in
    Reply(cReply: UnsafeMutablePointer<redisReply>(redisvCommand(context.cContext, command, args)))
  }
}

public func redisConnect(ip ip: String, port: Int) -> Context {
  return Context(cContext: redisConnect(ip, Int32(port)))
}

import CHiRedis
