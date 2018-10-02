FROM rust:1.29.1-slim-stretch

RUN apt-get -y update && \
        apt-get install -y --force-yes --no-install-recommends \
        curl git make g++ perl yasm pkg-config cmake gcc \
        wget file ca-certificates \
        libudev-dev \
        && \
    apt-get clean

ENV RUST_BACKTRACE 1
RUN rustc -vV && cargo -V

WORKDIR /code/parity-ethereum
ADD . /code

RUN cargo build --release --features final
EXPOSE 5001 8080 8082 8083 8545 8546 8180 30303/tcp 30303/udp
RUN pwd && ls && ls /code && ls /code/parity-ethereum && ls /code/parity-ethereum/target
ENTRYPOINT ["/code/parity-ethereum/target/release/parity"]
