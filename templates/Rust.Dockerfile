FROM [{BUILD_IMAGE|rust:slim-bookworm}] AS builder
WORKDIR /app

# Build cache
COPY ./Cargo.toml .
COPY ./Cargo.lock .
RUN mkdir -p ./src
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > ./src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/[{ARTIFACT_NAME}]*

COPY . .


FROM [{IMAGE|debian:bookworm-slim}]
WORKDIR /app

# Uncomment if you need to install any dependencies (and cleanup afterwards)
# RUN rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/release/[{ARTIFACT_NAME}] /app/[{ARTIFACT_NAME}]

ENTRYPOINT [ [{ENTRYPOINT}] ]
