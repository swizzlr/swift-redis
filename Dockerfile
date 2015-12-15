FROM swiftdocker/swift
RUN apt-get update -y && apt-get install libhiredis0.13
ADD . /code
RUN swift build
