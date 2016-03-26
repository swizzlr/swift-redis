

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

}
