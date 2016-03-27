
	public enum CommandArguments {
		// String
    case SET(String, String)
  	case APPEND(String, String)
  	case BITCOUNT(String, Int, Int)
  	case BITOP(String, String, Array<String>)
  	case BITPOS(String, Int, Array<Int>)
  	case INCR(String)
  	case INCRBY(String, Int)
  	case DECR(String)
  	case DECRBY(String, Int)
  	case GET(String)
  	case GETBIT(String, Int)
  	case SETBIT(String, Int, Int)
  	case GETRANGE(String, Int, Int)
  	case GETSET(String, String)
  	case INCRBYFLOAT(String, Float)
  	case MGET(Array<String>)
  	case MSET(Array<(String, String)>) // this command is an array of (key, value) tuples for a better code reading
  	case MSETNX(Array<(String, String)>) // this command is an array of (key, value) tuples for a better code reading
  	case SETEX(String, Int, String, Bool) // use the same command for SETEX and PSETEX, but use true in the last parameter for PSETEX
  	case SETNX(String, String)
  	case SETRANGE(String, Int, String)
  	case STRLEN(String)

		// Keys
		case DEL(Array<String>)
		case DUMP(String)
		case EXISTS(Array<String>)
		case EXPIRE(String, Int, Bool) // use the same command for EXPIRE and PEXPIRE, but use true in the last parameter for PEXPIRE
		case EXPIREAT(String, Double, Bool) // use the same command for EXPIREAT and PEXPIREAT, but use true in the last parameter for PEXPIREAT
		case KEYS(String)
		case MOVE(String, Int)
		case PERSIST(String)
		case TTL(String, Bool)
		case RANDOMKEY
		case RENAME(String, String)
		case RENAMENX(String, String)
		case RESTORE(String, Int, String, Bool) // Bool is for REPLACE modifier
		case SORT(String, String) // TODO: implement this madness
		case TYPE(String)

		// Lists
		case BLPOP(Array<String>, Int)
		case BRPOP(Array<String>, Int)
		case BRPOPLPUSH(String, String, Int)
		case LINDEX(String, Int)
		case LINSERT(String, String, String, String)
		case LLEN(String)
		case LPOP(String)
		case LPUSH(String, Array<String>)
		case LPUSHX(String, String)
		case LRANGE(String, Int, Int)
		case LREM(String, Int, String)
		case LSET(String, Int, String)
		case LTRIM(String, Int, Int)
		case RPOP(String)
		case RPOPLPUSH(String, String)
		case RPUSH(String, Array<String>)
		case RPUSHX(String, String)

		// Sets
		case SADD(String, Array<String>)
		case SCARD(String)
		case SDIFF(Array<String>)
		case SDIFFSTORE(String, Array<String>)
		case SINTER(Array<String>)
		case SINTERSTORE(String, Array<String>)
		case SISMEMBER(String, String)
		case SMEMBERS(String)
		case SMOVE(String, String, String)
		case SPOP(String)
		case SRANDMEMBER(String, Int?)
		case SREM(String, Array<String>)
		case SUNION(Array<String>)
		case SUNIONSTORE(String, Array<String>)

		// Sorted Sets
		case ZADD(String, Dictionary<String, String>) // TODO: add the 3.x arguments
		case ZCARD(String)
		case ZCOUNT(String, String, String)
		case ZINCRBY(String, Float, String)
		case ZINTERSTORE(String, Int, Array<String>, Array<Int>?, String?)
		case ZUNIONSTORE(String, Int, Array<String>, Array<Int>?, String?)
		case ZLEXCOUNT(String, String, String)
		case ZRANGEBYLEX(String, String, String, (Int, Int)?)
		case ZREVRANGEBYLEX(String, String, String, (Int, Int)?)
		case ZRANGE(String, Int, Int, Bool)
		case ZREVRANGE(String, Int, Int, Bool)
		case ZRANGEBYSCORE(String, String, String, Bool, (Int, Int)?)
		case ZREVRANGEBYSCORE(String, String, String, Bool, (Int, Int)?)
		case ZRANK(String, String)
		case ZREVRANK(String, String)
		case ZREM(String, Array<String>)
		case ZREMRANGEBYLEX(String, String, String, (Int, Int)?)
		case ZREMRANGEBYRANK(String, Int, Int)
		case ZREMRANGEBYSCORE(String, String, String)
		case ZSCORE(String, String)


		// Hashes
		case HSET(String, String, String)
		case HSETNX(String, String, String)
		case HDEL(String, Array<String>)
		case HEXISTS(String, String)
		case HGET(String, String)
		case HGETALL(String)
		case HINCRBY(String, String, Int)
		case HINCRBYFLOAT(String, String, Float)
		case HKEYS(String)
		case HLEN(String)
		case HMGET(String, Array<String>)
		case HMSET(String, Dictionary<String, String>)
		case HSTRLEN(String, String)
		case HVALS(String)

		// Connection
		case AUTH(String)
		case ECHO(String)
		case PING
		case SELECT(Int)

		// For everything else
		case RAW(String)

	}
