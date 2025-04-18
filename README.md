# Boa Docker Environment

This repo provides a Dockerfile for building and running the [Boa Compiler](https://github.com/boalang/compiler) on Apple Silicon (M1/M2/M3) or any Linux-based environment with legacy Protobuf 2.5.0 support.

## 🚀 How to Use

### 1. Build the Docker image

```bash
docker buildx build --platform linux/amd64 -t boa-builder --load .
```

### 2. When build finishes:

```bash
docker run -it boa-builder
```

### 3. Inside container:

```bash
cd /opt/boa
ant  # optional: recompile
```