FROM swiftdocker/swift
RUN apt-get update -y && apt-get install -y libhiredis-dev
ADD . /code
WORKDIR /code
RUN swift build
CMD ./script/execute_all_tests
