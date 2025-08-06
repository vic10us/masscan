# syntax=docker/dockerfile:1
FROM buildpack-deps:bookworm-scm AS build

# Build arguments
ARG VERSION=1.0.0
ARG MASSCAN_COMMIT=HEAD

# Environment setup
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        clang \
        libpcap-dev \
        ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/*

# Clone and build masscan
WORKDIR /build
RUN git clone https://github.com/robertdavidgraham/masscan.git . && \
    git checkout ${MASSCAN_COMMIT} && \
    make CC=clang -j$(nproc) && \
    strip bin/masscan

# Runtime stage
FROM debian:bookworm-slim

# Metadata
ARG VERSION=1.0.0
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="Masscan" \
      org.opencontainers.image.description="Fast port scanner in a Docker container" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="vic10us" \
      org.opencontainers.image.source="https://github.com/vic10us/masscan-docker" \
      org.opencontainers.image.documentation="https://github.com/vic10us/masscan-docker/blob/main/README.md" \
      org.opencontainers.image.licenses="AGPL-3.0"

# Install runtime dependencies and create non-root user
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libpcap0.8 \
        ca-certificates \
    && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/* && \
    groupadd -r masscan && \
    useradd -r -g masscan -s /bin/false masscan

# Copy binary from build stage
COPY --from=build /build/bin/masscan /usr/local/bin/masscan

# Set up permissions
RUN chmod +x /usr/local/bin/masscan

# Security: run as non-root user
USER masscan

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/usr/local/bin/masscan", "--version"]

ENTRYPOINT ["/usr/local/bin/masscan"]
