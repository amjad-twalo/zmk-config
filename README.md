# Amjad's ZMK Configs ⌨️

My personal collection of [ZMK](https://zmk.dev/) keyboard configurations.

## 🚀 Keyboards Included
### 1. [CannonKeys Photon](config/boards/cannonkeys/photon/)
- **Configuration**: Split-dongle mode using Seeed XIAO BLE as a central USB receiver.
- **Modernization**: Fully upgraded to ZMK Main / Zephyr 4.1 (HWMv2).
- **Features**: Remote battery/status indication via `caksoylar/zmk-rgbled-widget`.

---

## 🛠️ How to Build

### Local Development (Nix)
If you have [Nix](https://nixos.org/) installed with Flakes enabled:
```bash
nix build
```
This will build **all** firmware targets across all keyboards and place the resulting `.uf2` files in the `./result` directory.

### GitHub Actions (Remote)
Every push to `main` triggers an automated build via GitHub Actions, providing downloadable firmware artifacts without local setup.

## 📚 Credits & Attribution
Base board definitions and initial configurations for the Photon were sourced from the [CannonKeys ZMK repository](https://github.com/cannonkeys/zmk-cannonkeys-keyboards). 
Special thanks to the ZMK community and the `zmk-nix` maintainers.
