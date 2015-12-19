public final class Context {
  private let cContext: UnsafeMutablePointer<CHiRedis.redisContext>
  private init(cContext: UnsafeMutablePointer<CHiRedis.redisContext>) {
    self.cContext = cContext
  }

  deinit {
    redisFree(cContext)
  }
}

public final class Reply {
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

public func command(context context: Context, command: String, args: CVarArgType ...) -> Reply {
  return withVaList(args) { args in
    Reply(cReply: UnsafeMutablePointer<redisReply>(redisvCommand(context.cContext, command, args)))
  }
}

public func connect(ip ip: String, port: Int) -> Context {
  return Context(cContext: redisConnect(ip, Int32(port)))
}

import CHiRedis
