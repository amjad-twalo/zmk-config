# ZMK Configuration — Photon

This repository contains personal [ZMK](https://zmk.dev/) configurations for the **CannonKeys Photon** keyboard and its associated split-dongle setup.

## ✨ Features
- **ZMK Main & Zephyr 4.1 (HWMv2)**: Fully modernized and compliant with the latest Zephyr hardware models.
- **Official RGBLED Widget**: Integrated `caksoylar/zmk-rgbled-widget` for status and battery indication.
- **Nix-Powered**: Deterministic local builds using Nix Flakes.
- **GitHub Actions**: Automated CI firmware builds.

## 🛠️ Local Build
If you have [Nix](https://nixos.org/) installed with Flakes enabled:
```bash
nix build
```
This will generate all firmware artifacts (`.uf2`) in the `./result` directory.

## 📚 Credits
This project originated from and depends on the base work found in the [CannonKeys ZMK repository](https://github.com/cannonkeys/zmk-cannonkeys-keyboards). 

Special thanks to the [ZMK firmware](https://github.com/zmkfirmware/zmk) community and [zmk-nix](https://github.com/lilyinstarlight/zmk-nix) for the local building tools.
