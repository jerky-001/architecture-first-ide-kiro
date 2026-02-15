# Build stage for Rust core
FROM rust:1.75-slim as builder
WORKDIR /usr/src/app
COPY rust-core/ .
RUN cargo build --release

# Final runtime image
FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy Rust binary
COPY --from=builder /usr/src/app/target/release/devforge-core /usr/local/bin/

# Install Python dependencies
COPY analysis-engine/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY analysis-engine/src/ ./src/

# Environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Run the analyzer service
CMD ["python", "-m", "src.main"]
