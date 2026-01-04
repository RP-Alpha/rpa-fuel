# rpa-fuel

<div align="center">

![GitHub Release](https://img.shields.io/github/v/release/RP-Alpha/rpa-fuel?style=for-the-badge&logo=github&color=blue)
![GitHub commits](https://img.shields.io/github/commits-since/RP-Alpha/rpa-fuel/latest?style=for-the-badge&logo=git&color=green)
![License](https://img.shields.io/github/license/RP-Alpha/rpa-fuel?style=for-the-badge&color=orange)
![Downloads](https://img.shields.io/github/downloads/RP-Alpha/rpa-fuel/total?style=for-the-badge&logo=github&color=purple)

**Hybrid Vehicle Fuel System**

</div>

---

## ✨ Features

- 🎯 **Target Integration** - Refuel via Third Eye on pumps
- ⛽ **Consumption Logic** - RPM and vehicle class based usage
- 🔧 **Nozzle Props** - Visual feedback during refueling
- ⚡ **Optimized** - Minimal resource usage when not driving

---

## � Dependencies

- `rpa-lib` (Required)
- `ox_target` or `qb-target` (Required)

---

## 📥 Installation

1. Download the [latest release](https://github.com/RP-Alpha/rpa-fuel/releases/latest)
2. Extract to your `resources` folder
3. Add to `server.cfg`:
   ```cfg
   ensure rpa-lib
   ensure rpa-fuel
   ```

---

## ⚙️ Configuration

```lua
Config.FuelPrice = 3.50  -- Price per liter
Config.RefuelSpeed = 0.5  -- Liters per tick

-- Consumption multipliers by vehicle class
Config.ConsumptionRates = {
    [0] = 1.0,   -- Compacts
    [1] = 1.1,   -- Sedans
    [6] = 1.5,   -- Sports
    [7] = 2.0,   -- Super
}
```

---

## 📚 Usage

Drive to a gas station and use Third Eye on the pump to refuel.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/RP-Alpha">RP-Alpha</a></sub>
</div>
