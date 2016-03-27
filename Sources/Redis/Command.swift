
	public enum Command : String {
		// String
		case SET
		case APPEND
		case BITCOUNT
		case BITOP
		case BITPOS
		case INCR
		case INCRBY
		case DECR
		case DECRBY
		case GET
		case GETBIT
		case SETBIT
		case GETRANGE
		case GETSET
		case INCRBYFLOAT
		case MGET
		case MSET //tuples for a better code reading
		case MSETNX //tuples for a better code reading
		case SETEX // use the same command for SETEX and PSETEX, but use true in the last parameter for PSETEX
		case SETNX
		case SETRANGE
		case STRLEN

		// Keys
		case DEL
		case DUMP
		case EXISTS
		case EXPIRE // use the same command for EXPIRE and PEXPIRE, but use true in the last parameter for PEXPIRE
		case EXPIREAT // use the same command for EXPIREAT and PEXPIREAT, but use true in the last parameter for PEXPIREAT
		case KEYS
		case MOVE
		case PERSIST
		case TTL
		case RANDOMKEY
		case RENAME
		case RENAMENX
		case RESTORE // Bool is for REPLACE modifier
		case SORT // TODO: implement this madness
		case TYPE

		// Lists
		case BLPOP
		case BRPOP
		case BRPOPLPUSH
		case LINDEX
		case LINSERT
		case LLEN
		case LPOP
		case LPUSH
		case LPUSHX
		case LRANGE
		case LREM
		case LSET
		case LTRIM
		case RPOP
		case RPOPLPUSH
		case RPUSH
		case RPUSHX

		// Sets
		case SADD
		case SCARD
		case SDIFF
		case SDIFFSTORE
		case SINTER
		case SINTERSTORE
		case SISMEMBER
		case SMEMBERS
		case SMOVE
		case SPOP
		case SRANDMEMBER
		case SREM
		case SUNION
		case SUNIONSTORE

		// Sorted Sets
		case ZADD // TODO: add the 3.x arguments
		case ZCARD
		case ZCOUNT
		case ZINCRBY
		case ZINTERSTORE
		case ZUNIONSTORE
		case ZLEXCOUNT
		case ZRANGEBYLEX
		case ZREVRANGEBYLEX
		case ZRANGE
		case ZREVRANGE
		case ZRANGEBYSCORE
		case ZREVRANGEBYSCORE
		case ZRANK
		case ZREVRANK
		case ZREM
		case ZREMRANGEBYLEX
		case ZREMRANGEBYRANK
		case ZREMRANGEBYSCORE
		case ZSCORE


		// Hashes
		case HSET
		case HSETNX
		case HDEL
		case HEXISTS
		case HGET
		case HGETALL
		case HINCRBY
		case HINCRBYFLOAT
		case HKEYS
		case HLEN
		case HMGET
		case HMSET
		case HSTRLEN
		case HVALS

		// Connection
		case AUTH
		case ECHO
		case PING
		case SELECT

		// For everything else
		case RAW

	}
