FROM swiftdocker/swift
RUN apt-get update -y && apt-get install -y libhiredis-dev git
ADD . /code
WORKDIR /code
RUN swift build
