FROM golang:1.25 AS tests

WORKDIR /app/tests

COPY go.mod go.sum ./
RUN go mod download

RUN go install gotest.tools/gotestsum@v1.13.0

COPY tests ./tests
COPY *.go ./

CMD ["gotestsum", "--format", "testdox"]

FROM golang:1.25 AS build

WORKDIR /build

RUN mkdir bin

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

COPY scripts ./scripts

RUN chmod +x scripts/build_executable.sh

ENV CPU_ARCH=amd64

CMD ["/bin/bash", "-c", "./scripts/build_executable.sh ${CPU_ARCH}"]
