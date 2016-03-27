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

public extension redisContext {
  /// Error flags, 0 when there is no error
  public var err: Int32 {
    return cContext.pointee.err
  }

  /// String representation of error when applicable
  public var errstr: String? {
    return withUnsafePointer(&cContext.pointee.errstr) { b in
	    let str = String(cString:UnsafePointer(b))
    	if str == "" {
    		return nil
    	}
    	return str
    }
  }

  public var fd: Int32 {
    return cContext.pointee.fd
  }

  public var flags: Int32 {
    return cContext.pointee.flags
  }

  /// Write buffer
  public var obuf: UnsafeMutablePointer<CChar> {
    return cContext.pointee.obuf
  }

  /// Protocol reader
  public var reader: UnsafeMutablePointer<CHiRedis.redisReader> {
    return cContext.pointee.reader
  }

//  public var connection_type: CHiRedis.redisConnectionType {
//    return cContext.pointee.connection_type
//  }

//  public var timeout: UnsafeMutablePointer<CHiRedis.timeval> {
//    return cContext.pointee.timeout
//  }
//
//  public var tcp: tcp {
//    return cContext.pointee.tcp
//  }

//  struct {
//        char *host;
//        char *source_addr;
//        int port;
//    } tcp;

//  public var unix_sock: unix_sock {
//    return cContext.pointee.unix_sock
//  }

//    struct {
//        char *path;
//    } unix_sock;

}

public final class redisReply {
  private let cReply: UnsafeMutablePointer<CHiRedis.redisReply>
  private init?(cReply: UnsafeMutablePointer<CHiRedis.redisReply>) {
    guard cReply != nil else {
      return nil
    }
    self.cReply = cReply
  }
  deinit {
    freeReplyObject(cReply)
  }
}

public extension redisReply {
  /* Used for both REDIS_REPLY_ERROR and REDIS_REPLY_STRING */
  var str: String {
    return String(cString:cReply.pointee.str)
  }
  /* REDIS_REPLY_* */
  var type: Int32 {
    return cReply.pointee.type
  }
  /* The integer when type is REDIS_REPLY_INTEGER */
  var integer: Int64 {
    return cReply.pointee.integer
  }

  /* elements vector for REDIS_REPLY_ARRAY */
  var element: [redisReply]? {
    guard cReply.pointee.element != nil else { return nil }
    return UnsafeBufferPointer(start: cReply.pointee.element, count: Int(cReply.pointee.elements)).map { creplyptr in
      return redisReply(cReply: creplyptr)!
    }
  }
//  var len: Swift.Int32
//  var str: Swift.UnsafeMutablePointer<Swift.Int8>
////    int len; /* Length of string */
////    char *str;
}

final class redisReader {
  private let cReader: UnsafeMutablePointer<CHiRedis.redisReader>
  private init(cReader: UnsafeMutablePointer<CHiRedis.redisReader>) {
    self.cReader = cReader
  }

  deinit {
    redisReaderFree(cReader)
  }
}

//extension redisReader {
//  var err: Swift.Int32
//  var errstr: String
//  var buf: Swift.UnsafeMutablePointer<Swift.Int8>
//  var pos: Swift.Int
//  var len: Swift.Int
//  var maxbuf: Swift.Int
//  var rstack: (CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask, CHiRedis.redisReadTask)
//  var ridx: Swift.Int32
//  var reply: Swift.UnsafeMutablePointer<Swift.Void>
//  var fn: Swift.UnsafeMutablePointer<CHiRedis.redisReplyObjectFunctions>
//  var privdata: Swift.UnsafeMutablePointer<Swift.Void>
//typedef struct redisReader {
//    int err; /* Error flags, 0 when there is no error */
//    char errstr[128]; /* String representation of error when applicable */
//
//    char *buf; /* Read buffer */
//    size_t pos; /* Buffer cursor */
//    size_t len; /* Buffer length */
//    size_t maxbuf; /* Max length of unused buffer */
//
//    redisReadTask rstack[9];
//    int ridx; /* Index of current read task */
//    void *reply; /* Temporary reply pointer */
//
//    redisReplyObjectFunctions *fn;
//    void *privdata;
//} redisReader;
//}

//struct redisReadTask {
//  var type: Swift.Int32
//  var elements: Swift.Int32
//  var idx: Swift.Int32
//  var obj: Swift.UnsafeMutablePointer<Swift.Void>
//  var parent: Swift.UnsafeMutablePointer<CHiRedis.redisReadTask>
//  var privdata: Swift.UnsafeMutablePointer<Swift.Void>
//typedef struct redisReadTask {
//   int type;
//   int elements; /* number of elements in multibulk container */
//   int idx; /* index in parent (array) object */
//   void *obj; /* holds user-generated value for a read task */
//   struct redisReadTask *parent; /* parent task */
//   void *privdata; /* user-settable arbitrary field */
//} redisReadTask;
//}

// MARK: hiredis wrapper functions

public func redisCommand(context context: redisContext, command: String, args: CVarArg ...) -> redisReply? {
  return withVaList(args) { args in
    redisReply(cReply: UnsafeMutablePointer<CHiRedis.redisReply>(redisvCommand(context.cContext, command, args)))
  }
}

public func redisSubscribe(context context: redisContext, toChannel channel: String, handleWith handler: (message: redisReply?) -> (), args: CVarArg ...) {
  withVaList(args) { args in

    let subscribeReply = UnsafeMutablePointer<CHiRedis.redisReply>(redisvCommand(context.cContext, "SUBSCRIBE \(channel)", args))
    freeReplyObject(subscribeReply)

    var reply : UnsafeMutablePointer<Void> = nil

    while redisGetReply(context.cContext, &reply) == 0 /*REDIS_OK*/ {
        //handler(message: reply)
        print(reply)
        handler(message: nil)
        freeReplyObject(reply)
    }

  }
}


public func redisUnsubscribe(context context: redisContext, fromChannel channel: String, args: CVarArg ...) {
  withVaList(args) { args in

    let subscribeReply = UnsafeMutablePointer<CHiRedis.redisReply>(redisvCommand(context.cContext, "UNSUBSCRIBE \(channel)", args))
    freeReplyObject(subscribeReply)

  }
}


public func redisCommandWithArguments(context context: redisContext, command: String, args: CVaListPointer) -> redisReply? {
  return redisReply(cReply: UnsafeMutablePointer<CHiRedis.redisReply>(redisvCommand(context.cContext, command, args)))
}

public func redisConnect(ip ip: String, port: Int) -> redisContext {
  return redisContext(cContext: redisConnect(ip, Int32(port)))
}

import CHiRedis
