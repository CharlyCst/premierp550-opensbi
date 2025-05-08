# Sifive Hifive Premier P550 OpenSBI artifact

This repository automates the build of [OpenSBI](https://github.com/riscv-software-src/opensbi/) for the [Sifive HiFive Premier P550 board](https://www.sifive.com/boards/hifive-premier-p550).

The binary is available as a release artifact.

## How to release new artifacts

Create a new tag and push it to upstream, e.g.:

```sh
git tag v0.1.0
git push origin v0.1.0
```

