import hiredis

public class Redis {

	public var context : redisContext
	public var error : String?
	
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

}


