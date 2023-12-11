FROM rust:slim-bookworm AS builder
WORKDIR /app

# Build cache
COPY ./Cargo.toml .
COPY ./Cargo.lock .
RUN mkdir -p ./src
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > ./src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/$(cat Cargo.toml | awk '/name/ {print}' | cut -d '"' -f 2 | sed 's/-/_/')*

COPY . .
RUN cargo build --release
RUN cp -r target/release/$(cat Cargo.toml | awk '/name/ {print}' | cut -d '"' -f 2) /app/app

FROM debian:bookworm-slim
WORKDIR /app

# Uncomment if you need to install any dependencies (and cleanup afterwards)
# RUN rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/app /app/app

ENTRYPOINT [ "/app/app" ]
