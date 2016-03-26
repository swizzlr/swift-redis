

import hiredis
import Foundation


extension Array {
	public func quoteItems() -> Array<String> {
		let result: [String] = self.flatMap({ String("\($0)") })
		return result
	}
}


public class Redis {

	public var context : redisContext
	public var error : String?

	public init (context : redisContext) {

		self.context = context

	}


	public init (host : String, port: Int) {

		context = redisConnect(ip: host, port: port)

	}


	public func command(command: String, args: CVarArg ...) -> redisReply? {
		let result = withVaList(args) { args in
			return redisCommandWithArguments(context: context, command: command, args: args)
		}
		error = context.errstr
		return result
	}

	public func issue (command command : Command, withArguments commandArguments: CommandArguments) -> String? {
		var result: redisReply?;
		let commandString = command.rawValue
		switch commandArguments {
		// MARK: String commands
		case .SET(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		case .APPEND(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		case .BITCOUNT(let key, let start, let end):
		// TODO: Start and end are optional in Redis. How to do it in Swift?
		result = self.command("\(commandString) \(key) \(start) \(end)")

		case .BITOP(let operation, let destkey, let srckeys):
		result = self.command("\(commandString) \(operation) \(destkey) \(srckeys.joined(separator:" "))")

		case .BITPOS(let key, let bit, let start_end):
		let stringArray = start_end.quoteItems()
		result = self.command("\(commandString) \(key) \(bit) \(stringArray.joined(separator:" "))")

		case .INCR(let key):
		result = self.command("\(commandString) \(key)")

		case .INCRBY(let key, let increment):
		result = self.command("\(commandString) \(key) \(increment)")

		case .DECR(let key):
		result = self.command("\(commandString) \(key)")

		case .DECRBY(let key, let decrement):
		result = self.command("\(commandString) \(key) \(decrement)")

		case .GET(let key):
		result = self.command("\(commandString) \(key)")

		case .GETBIT(let key, let offset):
		result = self.command("\(commandString) \(key) \(offset)")

		case .SETBIT(let key, let offset, let value):
		result = self.command("\(commandString) \(key) \(offset) \(value)")

		case .GETRANGE(let key, let start, let end):
		result = self.command("\(commandString) \(key) \(start) \(end)")

		case .GETSET(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		case .INCRBYFLOAT(let key, let increment):
		result = self.command("\(commandString) \(key) \(increment)")

		case .MGET(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .MSET(let items):
		var cmdStr = ""
		for item in items {
			cmdStr += "\(item.0) \(item.1)"
		}
		print(cmdStr)

		result = self.command("\(commandString) \(cmdStr)")

		// TODO: both cases (MSET, MSETNX) are the same, can it be done in just one with a bool parameter?
		case .MSETNX(let items):
		var cmdStr = ""
		for item in items {
			cmdStr += "\(item.0) \(item.1) "
		}

		result = self.command("\(commandString) \(cmdStr)")

		case .SETEX(let key, let expire, let value, let p):
		result = self.command(p ? "P" : "" + "SETEX \(key) \(expire) \(value)")

		case .SETNX(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		case .SETRANGE(let key, let offset, let value):
		result = self.command("\(commandString) \(key) \(offset) \(value)")

		case .STRLEN(let key):
		result = self.command("\(commandString) \(key)")

		// Keys
		case .DEL(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .DUMP(let key):
		result = self.command("\(commandString) \(key)")

		case .EXISTS(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .EXPIRE(let key, let seconds, let p):
		result = self.command(p ? "P" : "" + "EXPIRE \(key) \(seconds)")

		case .EXPIREAT(let key, let timestamp, let p):
		result = self.command(p ? "P" : "" + "EXPIREAT \(key) \(timestamp)")

		case .KEYS(let pattern):
		result = self.command("\(commandString) \(pattern)")

		case .MOVE(let key, let db):
		result = self.command("\(commandString) \(key) \(db)")

		case .PERSIST(let key):
		result = self.command("\(commandString) \(key)")

		case .TTL(let key, let p):
		result = self.command(p ? "P" : "" + "TTL \(key)")

		case .RANDOMKEY:
		result = self.command("RANDOMKEY")

		case .RENAME(let key, let newkey):
		result = self.command("\(commandString) \(key) \(newkey)")

		case .RENAMENX(let key, let newkey):
		result = self.command("\(commandString) \(key) \(newkey)")

		case .RESTORE(let key, let ttl, let serialized, let replace):
		result = self.command("\(commandString) \(key) \(ttl) \(serialized)" + (replace ? " REPLACE" : "") + "")

		case .TYPE(let key):
		result = self.command("\(commandString) \(key)")

		// Connection
		case .AUTH(let password):
		result = self.command("\(commandString) \(password)")

		case .ECHO(let message):
		result = self.command("ECHO \(message)")

		case .PING:
		result = self.command("PING")

		case .SELECT(let index):
		result = self.command("\(commandString) \(index)")

		case .BLPOP(let keys, let timeout):
		result = self.command("\(commandString) \(keys.joined(separator:" ")) \(timeout))")

		case .BRPOP(let keys, let timeout):
		result = self.command("\(keys.joined(separator:" ")) \(timeout)")

		case .BRPOPLPUSH(let source, let destination, let timeout):
		result = self.command("\(commandString) \(timeout)")

		case .LINDEX(let key, let index):
		result = self.command("\(commandString) \(key) \(index)")

		case .LINSERT(let key, let order, let pivot, let value):
		result = self.command("\(commandString) \(key) \(order) \(pivot) \(value)")

		case .LLEN(let key):
		result = self.command("\(commandString) \(key)")

		case .LPOP(let key):
		result = self.command("\(commandString) \(key)")

		case .LPUSH(let key, let values):
		let newValues = values.quoteItems()
		result = self.command("\(commandString) \(key) \(newValues.joined(separator:" "))")

		case .LPUSHX(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		case .LRANGE(let key, let start, let stop):
		result = self.command("\(commandString) \(key) \(start) \(stop)")

		case .LREM(let key, let count, let value):
		result = self.command("\(commandString) \(key) \(count) \(value)")

		case .LSET(let key, let index, let value):
		result = self.command("\(commandString) \(key) \(index) \(value)")

		case .LTRIM(let key, let start, let stop):
		result = self.command("\(commandString) \(key) \(start) \(stop)")

		case .RPOP(let key):
		result = self.command("\(commandString) \(key)")

		case .RPOPLPUSH(let source, let destination):
		result = self.command("\(commandString) \(source) \(destination)")

		case .RPUSH(let key, let values):
		let newValues = values.quoteItems()
		result = self.command("\(commandString) \(key) \(newValues.joined(separator:" "))")

		case .RPUSHX(let key, let value):
		result = self.command("\(commandString) \(key) \(value)")

		// Sets commands
		case .SADD(let key, let members):
		let newValues = members.quoteItems()
		result = self.command("\(commandString) \(key) \(newValues.joined(separator:" "))")

		case .SCARD(let key):
		result = self.command("\(commandString) \(key)")

		case .SDIFF(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .SDIFFSTORE(let destination, let keys):
		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")

		case .SINTER(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .SINTERSTORE(let destination, let keys):
		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")

		case .SISMEMBER(let key, let member):
		result = self.command("\(commandString) \(key) \(member)")

		case .SMEMBERS(let key):
		result = self.command("\(commandString) \(key)")

		case .SMOVE(let source, let destination, let member):
		result = self.command("\(commandString) \(source) \(destination) \(member)")

		case .SPOP(let key):
		result = self.command("\(commandString) \(key)")

		case .SRANDMEMBER(let key, let count):
		result = self.command("\(commandString) \(key) \(count != nil ? String(count) : "")")

		case .SREM(let key, let members):
		let newMembers = members.quoteItems()
		result = self.command("\(commandString) \(key) \(newMembers.joined(separator:" "))")

		case .SUNION(let keys):
		result = self.command("\(commandString) \(keys.joined(separator:" "))")

		case .SUNIONSTORE(let destination, let keys):
		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")

		// Sorted Sets
		case .ZADD(let key, let values):
		let strValues = values.reduce(String()) { str, pair in
			var tmp = ""
			if str != "" {
				tmp = "\(str) "
			}
			tmp += "\(pair.0) \(pair.1)"
			return tmp
		}

		result = self.command("\(commandString) \(key) \(strValues)")

		case .ZCARD(let key):
		result = self.command("\(commandString) \(key)")

		case .ZCOUNT(let key, let min, let max):
		result = self.command("\(commandString) \(key) \(min) \(max)")

		case .ZINCRBY(let key, let increment, let member):
		result = self.command("\(commandString) \(key) \(increment) \(member)")

		case .ZINTERSTORE(let destination, let numkeys, let keys, let weights, let aggregate):
		var cmd = "\(destination) \(numkeys) \(keys.joined(separator:" "))"

		if weights != nil {
			cmd = "\(cmd) WEIGHTS \(weights)"
		}

		if aggregate != nil {
			cmd = "\(cmd) AGGREGATE \(aggregate)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZUNIONSTORE(let destination, let numkeys, let keys, let weights, let aggregate):
		var cmd = "\(destination) \(numkeys) \(keys.joined(separator:" "))"

		if weights != nil {
			cmd = "\(cmd) WEIGHTS \(weights)"
		}

		if aggregate != nil {
			cmd = "\(cmd) AGGREGATE \(aggregate)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZLEXCOUNT(let key, let min, let max):
		result = self.command("\(commandString) \(key) \(min) \(max)")

		case .ZRANGEBYLEX(let key, let min, let max, let limit):
		var cmd = "\(key) \(min) \(max)"

		if limit != nil {
			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZREVRANGEBYLEX(let key, let max, let min, let limit):
		var cmd = "\(key) \(max) \(min)"

		if limit != nil {
			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZRANGE(let key, let start, let stop, let withscores):
		var cmd = "\(key) \(start) \(stop)"

		if withscores {
			cmd = "\(cmd) WITHSCORES"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZREVRANGE(let key, let start, let stop, let withscores):
		var cmd = "\(key) \(start) \(stop)"

		if withscores {
			cmd = "\(cmd) WITHSCORES"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZRANGEBYSCORE(let key, let min, let max, let withscores, let limit):
		var cmd = "\(key) \(min) \(max)"

		if withscores {
			cmd = "\(cmd) WITHSCORES"
		}

		if limit != nil {
			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZREVRANGEBYSCORE(let key, let max, let min, let withscores, let limit):
		var cmd = "\(key) \(max) \(min)"

		if withscores {
			cmd = "\(cmd) WITHSCORES"
		}

		if limit != nil {
			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZRANK(let key, let member):
		result = self.command("\(commandString) \(key) \(member)")

		case .ZREVRANK(let key, let member):
		result = self.command("\(commandString) \(key) \(member)")

		case .ZREM(let key, let members):
		result = self.command("\(commandString) \(key) \(members.joined(separator:" "))")

		case .ZREMRANGEBYLEX(let key, let min, let max, let limit):
		var cmd = "\(key) \(min) \(max)"

		if limit != nil {
			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
		}

		result = self.command("\(commandString) \(cmd)")

		case .ZREMRANGEBYRANK(let key, let start, let stop):
		result = self.command("\(commandString) \(key) \(start) \(stop)")

		case .ZREMRANGEBYSCORE(let key, let min, let max):
		result = self.command("\(commandString) \(key) \(min) \(max)")

		case .ZSCORE(let key, let member):
		result = self.command("\(commandString) \(key) \(member)")

		// Hashes
		case .HSET(let key, let field, let value):
		result = self.command("\(commandString) \(key) \(field) \(value)")

		case .HSETNX(let key, let field, let value):
		result = self.command("\(commandString) \(key) \(field) \(value)")

		case .HDEL(let key, let fields):
		result = self.command("\(commandString) \(key) \(fields.joined(separator:" "))")

		case .HEXISTS(let key, let field):
		result = self.command("\(commandString) \(key) \(field)")

		case .HGET(let key, let field):
		result = self.command("\(commandString) \(key) \(field)")

		case .HGETALL(let key):
		result = self.command("\(commandString) \(key)")

		case .HINCRBY(let key, let field, let increment):
		result = self.command("\(commandString) \(key) \(field) \(increment)")

		case .HINCRBYFLOAT(let key, let field, let increment):
		result = self.command("\(commandString) \(key) \(field) \(increment)")

		case .HKEYS(let key):
		result = self.command("\(commandString) \(key)")

		case .HLEN(let key):
		result = self.command("\(commandString) \(key)")

		case .HMGET(let key, let fields):
		result = self.command("\(commandString) \(key) \(fields.joined(separator:" "))")

		case .HMSET(let key, let values):
		let strValues = values.reduce(String()) { str, pair in
			var tmp = ""
			if str != "" {
				tmp = "\(str) "
			}
			tmp += "\(pair.0) \(pair.1)"
			return tmp
		}

		result = self.command("\(commandString) \(key) \(strValues)")

		case .HSTRLEN(let key, let field):
		result = self.command("\(commandString) \(key) \(field)")

		case .HVALS(let key):
		result = self.command("\(commandString) \(key)")


		case .RAW(let raw):
		result = self.command("\(raw)")

		default:
		result = nil
		}

		return result?.str

	}
	//
	// public func ping () -> String? {
	// 	return command(Command.PING)?.str
	// }
	//
	// public func set (value : NSString) {
	// 	command("SET", args: [value as AnyObject])
	// }
	//
	// public func get (key : NSString) -> String? {
	// 	return command("GET", args: [key as AnyObject])?.str
	// }
	//
	// public func incr (key : String) {
	// 	return command("INCR", args: string)
	// }
	//
	// public func incrBy (key : String, count : Int) {
	// 	return command("INCRBY", args: key, count)
	// }



	//
	// public func command(type: Command) -> Any? {
	//
	// 	var result: Any?;
	//
	// 	switch type {
	// 	// MARK: String commands
	//
	// 	case .PING(let key):
	// 		result = self.command("PING")
	//
	// 	case .SET(let key, let value):
	// 		result = self.command("SET", args: value)
	//
	// 	case .APPEND(let key, let value):
	// 		result = self.command("APPEND", args: value)
	//
	// 	case .BITCOUNT(let key, let start, let end):
	// 		// TODO: Start and end are optional in Redis. How to do it in Swift?
	// 		result = self.command("BITCOUNT", args: start, end)
	//
	// 	case .BITOP(let operation, let destkey, let srckeys):
	// 		result = self.command("BITOP", args: destkey, srckeys.joinWithSeperator(" ")
	//
	// 	case .BITPOS(let key, let bit, let start_end):
	// 		let stringArray = start_end.quoteItems()
	// 		result = self.command("BITPOS", args: bit, stringArray.joinWithSeperator(" "))
	//
	// 	case .INCR(let key):
	// 		result = self.command("INCR")
	//
	// 	case .INCRBY(let key, let increment):
	// 		result = self.command("INCRBY", args: increment)
	//
	// 	case .DECR(let key):
	// 		result = self.command("DECR")
	//
	// 	case .DECRBY(let key, let decrement):
	// 		result = self.command("DECRBY", args: decrement)
	//
	// 	case .GET(let key):
	// 		result = self.command("GET")
	//
	// 	case .GETBIT(let key, let offset):
	// 		result = self.command("GETBIT", args: offset)
	//
	// 	case .SETBIT(let key, let offset, let value):
	// 		result = self.command("SETBIT", args: offset, value)
	//
	// 	case .GETRANGE(let key, let start, let end):
	// 		result = self.command("GETRANGE", args: ) \(start) \(end)")
	//
	// 	case .GETSET(let key, let value):
	// 		result = self.command("GETSET", args: ) \(value)")
	//
	// 	case .INCRBYFLOAT(let key, let increment):
	// 		result = self.command("INCRBYFLOAT", args: ) \(increment)")
	//
	// 	case .MGET(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .MSET(let items):
	// 		var cmdStr = ""
	// 		for item in items {
	// 			cmdStr += "\(item.0) \(item.1) "
	// 		}
	// 		print(cmdStr)
	//
	// 		result = self.command("\(commandString) \(cmdStr)")
	//
	// 	// TODO: both cases (MSET, MSETNX) are the same, can it be done in just one with a bool parameter?
	// 	case .MSETNX(let items):
	// 		var cmdStr = ""
	// 		for item in items {
	// 			cmdStr += "\(item.0) \(item.1) "
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmdStr)")
	//
	// 	case .SETEX(let key, let expire, let value, let p):
	// 		result = self.command(p ? "P" : "" + "SETEX", args: ) \(expire) \(value)")
	//
	// 	case .SETNX(let key, let value):
	// 		result = self.command("SETNX", args: ) \(value)")
	//
	// 	case .SETRANGE(let key, let offset, let value):
	// 		result = self.command("SETRANGE", args: ) \(offset) \(value)")
	//
	// 	case .STRLEN(let key):
	// 		result = self.command("STRLEN", args: )")
	//
	// 	// Keys
	// 	case .DEL(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .DUMP(let key):
	// 		result = self.command("DUMP", args: )")
	//
	// 	case .EXISTS(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .EXPIRE(let key, let seconds, let p):
	// 		result = self.command(p ? "P" : "" + "EXPIRE", args: ) \(seconds)")
	//
	// 	case .EXPIREAT(let key, let timestamp, let p):
	// 		result = self.command(p ? "P" : "" + "EXPIREAT", args: ) \(timestamp)")
	//
	// 	case .KEYS(let pattern):
	// 		result = self.command("\(commandString) \(pattern)")
	//
	// 	case .MOVE(let key, let db):
	// 		result = self.command("MOVE", args: ) \(db)")
	//
	// 	case .PERSIST(let key):
	// 		result = self.command("PERSIST", args: )")
	//
	// 	case .TTL(let key, let p):
	// 		result = self.command(p ? "P" : "" + "TTL", args: )")
	//
	// 	case .RANDOMKEY:
	// 		result = self.command("RANDOMKEY")
	//
	// 	case .RENAME(let key, let newkey):
	// 		result = self.command("RENAME", args: ) \(newkey)")
	//
	// 	case .RENAMENX(let key, let newkey):
	// 		result = self.command("RENAMENX", args: ) \(newkey)")
	//
	// 	case .RESTORE(let key, let ttl, let serialized, let replace):
	// 		result = self.command("RESTORE", args: ) \(ttl) \(serialized)" + (replace ? " REPLACE" : "") + "")
	//
	// 	case .TYPE(let key):
	// 		result = self.command("TYPE", args: )")
	//
	// 	// Connection
	// 	case .AUTH(let password):
	// 		result = self.command("\(commandString) \(password)")
	//
	// 	case .ECHO(let message):
	// 		result = self.command("ECHO \(message)")
	//
	// 	case .PING:
	// 		result = self.command("PING")
	//
	// 	case .SELECT(let index):
	// 		result = self.command("\(commandString) \(index)")
	//
	// 	case .BLPOP(let keys, let timeout):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" ")) \(timeout))")
	//
	// 	case .BRPOP(let keys, let timeout):
	// 		result = self.command("\(keys.joined(separator:" ")) \(timeout)")
	//
	// 	case .BRPOPLPUSH(let source, let destination, let timeout):
	// 		result = self.command("\(commandString) \(timeout)")
	//
	// 	case .LINDEX(let key, let index):
	// 		result = self.command("LINDEX", args: ) \(index)")
	//
	// 	case .LINSERT(let key, let order, let pivot, let value):
	// 		result = self.command("LINSERT", args: ) \(order) \(pivot) \(value)")
	//
	// 	case .LLEN(let key):
	// 		result = self.command("LLEN", args: )")
	//
	// 	case .LPOP(let key):
	// 		result = self.command("LPOP", args: )")
	//
	// 	case .LPUSH(let key, let values):
	// 		let newValues = values.quoteItems()
	// 		result = self.command("LPUSH", args: ) \(newValues.joined(separator:" "))")
	//
	// 	case .LPUSHX(let key, let value):
	// 		result = self.command("LPUSHX", args: ) \(value)")
	//
	// 	case .LRANGE(let key, let start, let stop):
	// 		result = self.command("LRANGE", args: ) \(start) \(stop)")
	//
	// 	case .LREM(let key, let count, let value):
	// 		result = self.command("LREM", args: ) \(count) \(value)")
	//
	// 	case .LSET(let key, let index, let value):
	// 		result = self.command("LSET", args: ) \(index) \(value)")
	//
	// 	case .LTRIM(let key, let start, let stop):
	// 		result = self.command("LTRIM", args: ) \(start) \(stop)")
	//
	// 	case .RPOP(let key):
	// 		result = self.command("RPOP", args: )")
	//
	// 	case .RPOPLPUSH(let source, let destination):
	// 		result = self.command("\(commandString) \(source) \(destination)")
	//
	// 	case .RPUSH(let key, let values):
	// 		let newValues = values.quoteItems()
	// 		result = self.command("RPUSH", args: ) \(newValues.joined(separator:" "))")
	//
	// 	case .RPUSHX(let key, let value):
	// 		result = self.command("RPUSHX", args: ) \(value)")
	//
	// 	// Sets commands
	// 	case .SADD(let key, let members):
	// 		let newValues = members.quoteItems()
	// 		result = self.command("SADD", args: ) \(newValues.joined(separator:" "))")
	//
	// 	case .SCARD(let key):
	// 		result = self.command("SCARD", args: )")
	//
	// 	case .SDIFF(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .SDIFFSTORE(let destination, let keys):
	// 		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")
	//
	// 	case .SINTER(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .SINTERSTORE(let destination, let keys):
	// 		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")
	//
	// 	case .SISMEMBER(let key, let member):
	// 		result = self.command("SISMEMBER", args: ) \(member)")
	//
	// 	case .SMEMBERS(let key):
	// 		result = self.command("SMEMBERS", args: )")
	//
	// 	case .SMOVE(let source, let destination, let member):
	// 		result = self.command("\(commandString) \(source) \(destination) \(member)")
	//
	// 	case .SPOP(let key):
	// 		result = self.command("SPOP", args: )")
	//
	// 	case .SRANDMEMBER(let key, let count):
	// 		result = self.command("SRANDMEMBER", args: ) \(count != nil ? String(count) : "")")
	//
	// 	case .SREM(let key, let members):
	// 		let newMembers = members.quoteItems()
	// 		result = self.command("SREM", args: ) \(newMembers.joined(separator:" "))")
	//
	// 	case .SUNION(let keys):
	// 		result = self.command("\(commandString) \(keys.joined(separator:" "))")
	//
	// 	case .SUNIONSTORE(let destination, let keys):
	// 		result = self.command("\(commandString) \(destination) \(keys.joined(separator:" "))")
	//
	// 	// Sorted Sets
	// 	case .ZADD(let key, let values):
	// 		let strValues = values.reduce(String()) { str, pair in
	// 			var tmp = ""
	// 			if str != "" {
	// 				tmp = "\(str) "
	// 			}
	// 			tmp += "\(pair.0) \(pair.1)"
	// 			return tmp
	// 		}
	//
	// 		result = self.command("ZADD", args: ) \(strValues)")
	//
	// 	case .ZCARD(let key):
	// 		result = self.command("ZCARD", args: )")
	//
	// 	case .ZCOUNT(let key, let min, let max):
	// 		result = self.command("ZCOUNT", args: ) \(min) \(max)")
	//
	// 	case .ZINCRBY(let key, let increment, let member):
	// 		result = self.command("ZINCRBY", args: ) \(increment) \(member)")
	//
	// 	case .ZINTERSTORE(let destination, let numkeys, let keys, let weights, let aggregate):
	// 		var cmd = "\(destination) \(numkeys) \(keys.joined(separator:" "))"
	//
	// 		if weights != nil {
	// 			cmd = "\(cmd) WEIGHTS \(weights)"
	// 		}
	//
	// 		if aggregate != nil {
	// 			cmd = "\(cmd) AGGREGATE \(aggregate)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZUNIONSTORE(let destination, let numkeys, let keys, let weights, let aggregate):
	// 		var cmd = "\(destination) \(numkeys) \(keys.joined(separator:" "))"
	//
	// 		if weights != nil {
	// 			cmd = "\(cmd) WEIGHTS \(weights)"
	// 		}
	//
	// 		if aggregate != nil {
	// 			cmd = "\(cmd) AGGREGATE \(aggregate)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZLEXCOUNT(let key, let min, let max):
	// 		result = self.command("ZLEXCOUNT", args: ) \(min) \(max)")
	//
	// 	case .ZRANGEBYLEX(let key, let min, let max, let limit):
	// 		var cmd = "\(key) \(min) \(max)"
	//
	// 		if limit != nil {
	// 			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZREVRANGEBYLEX(let key, let max, let min, let limit):
	// 		var cmd = "\(key) \(max) \(min)"
	//
	// 		if limit != nil {
	// 			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZRANGE(let key, let start, let stop, let withscores):
	// 		var cmd = "\(key) \(start) \(stop)"
	//
	// 		if withscores {
	// 			cmd = "\(cmd) WITHSCORES"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZREVRANGE(let key, let start, let stop, let withscores):
	// 		var cmd = "\(key) \(start) \(stop)"
	//
	// 		if withscores {
	// 			cmd = "\(cmd) WITHSCORES"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZRANGEBYSCORE(let key, let min, let max, let withscores, let limit):
	// 		var cmd = "\(key) \(min) \(max)"
	//
	// 		if withscores {
	// 			cmd = "\(cmd) WITHSCORES"
	// 		}
	//
	// 		if limit != nil {
	// 			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZREVRANGEBYSCORE(let key, let max, let min, let withscores, let limit):
	// 		var cmd = "\(key) \(max) \(min)"
	//
	// 		if withscores {
	// 			cmd = "\(cmd) WITHSCORES"
	// 		}
	//
	// 		if limit != nil {
	// 			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZRANK(let key, let member):
	// 		result = self.command("ZRANK", args: ) \(member)")
	//
	// 	case .ZREVRANK(let key, let member):
	// 		result = self.command("ZREVRANK", args: ) \(member)")
	//
	// 	case .ZREM(let key, let members):
	// 		result = self.command("ZREM", args: ) \(members.joined(separator:" "))")
	//
	// 	case .ZREMRANGEBYLEX(let key, let min, let max, let limit):
	// 		var cmd = "\(key) \(min) \(max)"
	//
	// 		if limit != nil {
	// 			cmd = "\(cmd) LIMIT \(limit!.0) \(limit!.1)"
	// 		}
	//
	// 		result = self.command("\(commandString) \(cmd)")
	//
	// 	case .ZREMRANGEBYRANK(let key, let start, let stop):
	// 		result = self.command("ZREMRANGEBYRANK", args: ) \(start) \(stop)")
	//
	// 	case .ZREMRANGEBYSCORE(let key, let min, let max):
	// 		result = self.command("ZREMRANGEBYSCORE", args: ) \(min) \(max)")
	//
	// 	case .ZSCORE(let key, let member):
	// 		result = self.command("ZSCORE", args: ) \(member)")
	//
	// 	// Hashes
	// 	case .HSET(let key, let field, let value):
	// 		result = self.command("HSET", args: ) \(field) \(value)")
	//
	// 	case .HSETNX(let key, let field, let value):
	// 		result = self.command("HSETNX", args: ) \(field) \(value)")
	//
	// 	case .HDEL(let key, let fields):
	// 		result = self.command("HDEL", args: ) \(fields.joined(separator:" "))")
	//
	// 	case .HEXISTS(let key, let field):
	// 		result = self.command("HEXISTS", args: ) \(field)")
	//
	// 	case .HGET(let key, let field):
	// 		result = self.command("HGET", args: ) \(field)")
	//
	// 	case .HGETALL(let key):
	// 		result = self.command("HGETALL", args: )")
	//
	// 	case .HINCRBY(let key, let field, let increment):
	// 		result = self.command("HINCRBY", args: ) \(field) \(increment)")
	//
	// 	case .HINCRBYFLOAT(let key, let field, let increment):
	// 		result = self.command("HINCRBYFLOAT", args: ) \(field) \(increment)")
	//
	// 	case .HKEYS(let key):
	// 		result = self.command("HKEYS", args: )")
	//
	// 	case .HLEN(let key):
	// 		result = self.command("HLEN", args: )")
	//
	// 	case .HMGET(let key, let fields):
	// 		result = self.command("HMGET", args: ) \(fields.joined(separator:" "))")
	//
	// 	case .HMSET(let key, let values):
	// 		let strValues = values.reduce(String()) { str, pair in
	// 			var tmp = ""
	// 			if str != "" {
	// 				tmp = "\(str) "
	// 			}
	// 			tmp += "\(pair.0) \(pair.1)"
	// 			return tmp
	// 		}
	//
	// 		result = self.command("HMSET", args: ) \(strValues)")
	//
	// 	case .HSTRLEN(let key, let field):
	// 		result = self.command("HSTRLEN", args: ) \(field)")
	//
	// 	case .HVALS(let key):
	// 		result = self.command("HVALS", args: )")
	//
	//
	// 	case .RAW(let raw):
	// 		result = self.command("\(raw)")
	//
	// 	default:
	// 		result = nil
	// 	}
	//
	// 	return result
	// }
	//
	// public enum CommandArguments : String {
	// 	// String
	// 	case SET(String, String)
	// 	case APPEND
	// 	case BITCOUNT
	// 	case BITOP
	// 	case BITPOS
	// 	case INCR(String)
	// 	case INCRBY(String, Int)
	// 	case DECR(String)
	// 	case DECRBY(String, Int)
	// 	case GET(String)
	// 	case GETBIT(String, Int)
	// 	case SETBIT(String, Int, Int)
	// 	case GETRANGE(String, Int, Int)
	// 	case GETSET(String, String)
	// 	case INCRBYFLOAT(String, Float)
	// 	case MGET(Array<String>)
	// 	case MSET(Array<(String, String)>) // this command is an array of (key, value) tuples for a better code reading
	// 	case MSETNX(Array<(String, String)>) // this command is an array of (key, value) tuples for a better code reading
	// 	case SETEX(String, Int, String, Bool) // use the same command for SETEX and PSETEX, but use true in the last parameter for PSETEX
	// 	case SETNX(String, String)
	// 	case SETRANGE(String, Int, String)
	// 	case STRLEN(String)
	//
	// 	// Keys
	// 	case DEL(Array<String>)
	// 	case DUMP(String)
	// 	case EXISTS(Array<String>)
	// 	case EXPIRE(String, Int, Bool) // use the same command for EXPIRE and PEXPIRE, but use true in the last parameter for PEXPIRE
	// 	case EXPIREAT(String, Double, Bool) // use the same command for EXPIREAT and PEXPIREAT, but use true in the last parameter for PEXPIREAT
	// 	case KEYS(String)
	// 	case MOVE(String, Int)
	// 	case PERSIST(String)
	// 	case TTL(String, Bool)
	// 	case RANDOMKEY
	// 	case RENAME(String, String)
	// 	case RENAMENX(String, String)
	// 	case RESTORE(String, Int, String, Bool) // Bool is for REPLACE modifier
	// 	case SORT(String, String) // TODO: implement this madness
	// 	case TYPE(String)
	//
	// 	// Lists
	// 	case BLPOP(Array<String>, Int)
	// 	case BRPOP(Array<String>, Int)
	// 	case BRPOPLPUSH(String, String, Int)
	// 	case LINDEX(String, Int)
	// 	case LINSERT(String, String, String, String)
	// 	case LLEN(String)
	// 	case LPOP(String)
	// 	case LPUSH(String, Array<String>)
	// 	case LPUSHX(String, String)
	// 	case LRANGE(String, Int, Int)
	// 	case LREM(String, Int, String)
	// 	case LSET(String, Int, String)
	// 	case LTRIM(String, Int, Int)
	// 	case RPOP(String)
	// 	case RPOPLPUSH(String, String)
	// 	case RPUSH(String, Array<String>)
	// 	case RPUSHX(String, String)
	//
	// 	// Sets
	// 	case SADD(String, Array<String>)
	// 	case SCARD(String)
	// 	case SDIFF(Array<String>)
	// 	case SDIFFSTORE(String, Array<String>)
	// 	case SINTER(Array<String>)
	// 	case SINTERSTORE(String, Array<String>)
	// 	case SISMEMBER(String, String)
	// 	case SMEMBERS(String)
	// 	case SMOVE(String, String, String)
	// 	case SPOP(String)
	// 	case SRANDMEMBER(String, Int?)
	// 	case SREM(String, Array<String>)
	// 	case SUNION(Array<String>)
	// 	case SUNIONSTORE(String, Array<String>)
	//
	// 	// Sorted Sets
	// 	case ZADD(String, Dictionary<String, String>) // TODO: add the 3.x arguments
	// 	case ZCARD(String)
	// 	case ZCOUNT(String, String, String)
	// 	case ZINCRBY(String, Float, String)
	// 	case ZINTERSTORE(String, Int, Array<String>, Array<Int>?, String?)
	// 	case ZUNIONSTORE(String, Int, Array<String>, Array<Int>?, String?)
	// 	case ZLEXCOUNT(String, String, String)
	// 	case ZRANGEBYLEX(String, String, String, (Int, Int)?)
	// 	case ZREVRANGEBYLEX(String, String, String, (Int, Int)?)
	// 	case ZRANGE(String, Int, Int, Bool)
	// 	case ZREVRANGE(String, Int, Int, Bool)
	// 	case ZRANGEBYSCORE(String, String, String, Bool, (Int, Int)?)
	// 	case ZREVRANGEBYSCORE(String, String, String, Bool, (Int, Int)?)
	// 	case ZRANK(String, String)
	// 	case ZREVRANK(String, String)
	// 	case ZREM(String, Array<String>)
	// 	case ZREMRANGEBYLEX(String, String, String, (Int, Int)?)
	// 	case ZREMRANGEBYRANK(String, Int, Int)
	// 	case ZREMRANGEBYSCORE(String, String, String)
	// 	case ZSCORE(String, String)
	//
	//
	// 	// Hashes
	// 	case HSET(String, String, String)
	// 	case HSETNX(String, String, String)
	// 	case HDEL(String, Array<String>)
	// 	case HEXISTS(String, String)
	// 	case HGET(String, String)
	// 	case HGETALL(String)
	// 	case HINCRBY(String, String, Int)
	// 	case HINCRBYFLOAT(String, String, Float)
	// 	case HKEYS(String)
	// 	case HLEN(String)
	// 	case HMGET(String, Array<String>)
	// 	case HMSET(String, Dictionary<String, String>)
	// 	case HSTRLEN(String, String)
	// 	case HVALS(String)
	//
	// 	// Connection
	// 	case AUTH(String)
	// 	case ECHO(String)
	// 	case PING
	// 	case SELECT(Int)
	//
	// 	// For everything else
	// 	case RAW(String)
	//
	// }

}
