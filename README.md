# Termux-PyPI Docker Images

Pre-configured [termux-docker](https://github.com/termux/termux-docker) images with **Python 3.14 (`cp314`)** and [termux-pip](https://github.com/termux-pypi/termux-pip) (`tpip`) ready out of the box.

## Available Images

| Image | Description | Tags | Architectures |
| :--- | :--- | :--- | :--- |
| `ghcr.io/termux-pypi/python` | Lightweight runtime with `python`, `pip`, and `tpip setup` applied | `latest`, `3.14`, `3.14-arm64`, `3.14-armeabi`, `3.14-x86_64`, `3.14-x86` | `arm64`, `armeabi`, `x86_64`, `x86` |
| `ghcr.io/termux-pypi/python-builder` | Build environment with `termux-pip[build]`, `patchelf`, `git`, `clang`, `make`, `binutils`, `pkg-config` | `latest`, `3.14`, `3.14-arm64`, `3.14-armeabi`, `3.14-x86_64`, `3.14-x86` | `arm64`, `armeabi`, `x86_64`, `x86` |

## Usage

### Interactive Termux shell (`python` + `tpip` preconfigured)

```sh
docker run -it --rm ghcr.io/termux-pypi/python
```

Inside the container, you can immediately install pre-compiled wheels from Termux-PyPI:

```sh
pip install numpy pandas
python -c "import numpy; print(numpy.__version__)"
```

### Run Python directly

```sh
docker run --rm ghcr.io/termux-pypi/python python -c "import sys; print(sys.version)"
```

### Build and repair wheels (`python-builder`)

Mount your recipe directory and run `tpip build` and `tpip repair`:

```sh
docker run --rm \
  -v "$PWD":/data/data/com.termux/files/home/work \
  ghcr.io/termux-pypi/python-builder \
  bash -lc "cd ~/work && tpip build recipe.yaml -w ~/work/dist && tpip repair ~/work/dist/*.whl"
```

## Running ARM containers on `x86_64` hosts

Register QEMU via `binfmt_misc`:

```sh
docker run --rm --privileged aptman/qus -s -- -p aarch64 arm
```

Depending on your host kernel / Docker seccomp configuration, ARM containers may require `--security-opt seccomp=unconfined` or `--privileged` (see [termux-docker known issues](https://github.com/termux/termux-docker#known-issues)):

```sh
docker run -it --rm --security-opt seccomp=unconfined ghcr.io/termux-pypi/python:3.14-arm64
```

## License

MIT