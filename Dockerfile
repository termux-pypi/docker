ARG BASE_TAG=aarch64
FROM docker.io/termux/termux-docker:${BASE_TAG} AS base

ARG SYSTEM_PYTHON=3.14
ARG PYTHON_VERSION=3.14

USER 1000:1000

RUN ln -sfn "$PREFIX/etc/termux/mirrors/default" "$PREFIX/etc/termux/chosen_mirrors" && \
    pkg upgrade -y -o Dpkg::Options::=--force-confnew && \
    if [ "$PYTHON_VERSION" = "$SYSTEM_PYTHON" ]; then \
        pkg install -y python python-pip; \
    else \
        pkg install -y tur-repo && \
        pkg install -y "python${PYTHON_VERSION}" && \
        ln -sf "$PREFIX/bin/python${PYTHON_VERSION}" "$PREFIX/bin/python" && \
        ln -sf "$PREFIX/bin/python${PYTHON_VERSION}" "$PREFIX/bin/python3" && \
        ln -sf "$PREFIX/bin/pip${PYTHON_VERSION}" "$PREFIX/bin/pip" && \
        ln -sf "$PREFIX/bin/pip${PYTHON_VERSION}" "$PREFIX/bin/pip3"; \
    fi && \
    if pip install --no-cache-dir termux-pip; then \
        tpip setup; \
    else \
        pip config set global.extra-index-url https://tpypi.loamfy-tools.workers.dev; \
    fi && \
    pkg clean && \
    rm -rf "$PREFIX"/var/lib/apt/lists/*

# --- 1. ghcr.io/termux-pypi/python ---
FROM base AS python
LABEL org.opencontainers.image.source="https://github.com/termux-pypi/docker"
LABEL org.opencontainers.image.description="Termux environment with Python and Termux-PyPI preconfigured"
LABEL org.opencontainers.image.licenses="MIT"
USER 0:0

# --- 2. ghcr.io/termux-pypi/python-builder ---
FROM base AS builder
LABEL org.opencontainers.image.source="https://github.com/termux-pypi/docker"
LABEL org.opencontainers.image.description="Termux environment for building and repairing Python wheels with tpip"
LABEL org.opencontainers.image.licenses="MIT"
RUN pkg install -y patchelf git clang binutils make pkg-config && \
    pip install --no-cache-dir "termux-pip[build]" && \
    pkg clean && \
    rm -rf "$PREFIX"/var/lib/apt/lists/*
USER 0:0