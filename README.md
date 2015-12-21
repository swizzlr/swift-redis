# SwiftRedis
Redis bridges for Swift, Linux friendly! This package is still in very early development and needs some love before it's ready for wide use.

# Introduction
Much serious backend development, for better or for worse, tends to depend on Redis for distributed synchronization of data. Swift isn't a serious force for developers trying to do meaningful work on the server without bindings for systems such as Redis.

This package wraps the hiredis library; eventually I hope to remove this dependency entirely, since Swift is quite suited to that sort of systems programming too. However, hiredis is a proven, solid backbone of many other implementations of Redis, and I have no qualms about standing on it for now while we get started.

# Getting Started

## Installation
Add this repo to your Package.swift, major version 0. You must have hiredis installed with development headers. I'm assuming production will only usefully occur on Linux; see below about OS X caveats.

## Usage

Simply `import Redis` and you're ready to go!

A simple example, straight from the integration test suite.

```swift
// Connect to a server, getting a context object which represents the connection and its state
let context: Context = connect(ip: "127.0.0.1", port: 6379)
let reply = command(context: context, command: "PING", args: 0).replyString // "PONG"
```

## Structure

- `CHiRedis` is automatically installed, a separate module which maps a Linux installation of hiredis into Swift
- `hiredis` (lowercase, to imply not for public consumption) is a set of simple wrappers around CHiRedis that perform the documented type conversions and vararg wrapping from C.
- `Redis` is the high level abstraction that your day to day Redis use will be in, I hope.

This is subject to change until 1.0.

# License
SwiftRedis is available under the [BSD 3-clause license](./LICENSE). If you have any suggestions for relicensing, I'm happy to hear it, as long as it isn't viral.

# Getting Help
Please open an issue!

# Contributing
This is your opportunity to influence the growth of a language that is taking the world by storm, and mature, useful libraries are a crucial part of it. Contributions very much welcome, encouraged and loved.

## Developing on SwiftRedis

I recommend you use Docker. See below for more info.

## Requirements
The above note about hiredis applies. `brew install hiredis` or `sudo apt-get -y install libhiredis-dev`.

### Linux
Requires the 18 Dec Linux snapshot or later (for varargs support).

### OS X
If you're using OS X, you'll need to manually edit the `module.modulemap` in the downloaded `CHiRedis` package of the `Packages` folder after running `swift build` for the first time to checkout the package. You need to supply the correct absolute path to the hiredis headers, which on OS X will almost certainly be in `/usr/local/include` if you used homebrew.

## Building and running tests

Running `swift build` in the root of this directory will, by convention, do the right thing. The build products will be available in `.build/debug`.

Since a dedicated test command/runner is currently missing in `swift build`, the tests are structured as executables. Currently there only exists `RedisIntegrationTests`. This must be run with the following environment variables correctly set pointing to a running Redis instance:

```
REDIS_PORT_6379_TCP_ADDR
REDIS_PORT_6379_TCP_PORT
```

This will be handled for you automatically if you use Docker. See below.

## Docker
Docker recommended. Integration tests rely on it, since they needing a running Redis instance, and extract the appropriate environment variables accordingly.

If you're on a Mac, you'll need to install the [docker-toolbox](https://www.docker.com/docker-toolbox). Open the docker-quickstart terminal to have a terminal with docker ready to go.

If you're feeling a little more advanced, you can use [docker-machine to provision a VM in the cloud](https://docs.docker.com/machine/). You'll have the added benefit of much faster installs.

To get started, run `./script/test` to build the complete package and run the tests in Docker.
