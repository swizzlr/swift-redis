FROM swiftdocker/swift-from-scratch
RUN apt-get update -y && apt-get install -y libhiredis-dev
ADD . /code
WORKDIR /code
RUN swift build
CMD .build/debug/RedisIntegrationTests
