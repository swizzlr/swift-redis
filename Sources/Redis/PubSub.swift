import hiredis

public class PubSub {


	var redis : Redis

	public init (redis : Redis) {
		self.redis = redis
	}

	public func subscribe(toChannel channel : String, handleWith callback : (message: redisReply?) -> ()) {
		redisSubscribe(context: redis.context, toChannel: channel, handleWith: callback)
	}

	public func unsubscribe(channel : String) {
		redisUnsubscribe(context: redis.context, fromChannel: channel)
	}

}
