import hiredis

public class PubSub {


	var redis : Redis

	public init (redis : Redis) {
		self.redis = redis
	}

	public func subscribeSync(toChannel channel : String, handleWith callback : (message: String) -> ()) {
		redisSubscribeSync(context: redis.context, toChannel: channel, handleWith: callback)
	}

	public func unsubscribeSync(channel : String) {
		redisUnsubscribeSync(context: redis.context, fromChannel: channel)
	}

}
