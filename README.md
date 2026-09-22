# adb-trace-cleaner 🔧

**English** | [中文](README.zh-CN.md)

A shell script that eliminates USB debugging traces on Android devices. Designed for module developers, reverse engineers, and testers.

---

## Features

- ✅ Sets the system property `sys.usb.adb.disabled` to an empty value, disabling USB debugging
- ✅ Automatically finds and stops ADB service processes (`adbd` / `adb`)
- ✅ Verifies the resulting property value
- ✅ **Bilingual output** — every message is printed separately in Chinese and English, clearly and readably
- ✅ Detailed error handling and return-value checks

---

## Requirements

- Rooted Android device (`setprop` / `getprop` permission required)
- A `/system/bin/sh` environment
- BusyBox, or a shell that supports `pidof`

> Root access is required. Works on most AOSP-based systems.

---

## Usage

```sh
# Run as root
su -c ./adb_trace_cleaner.sh
```

## Script Flow

1. **Check root** → exit immediately if not root
2. **Set property** → `setprop sys.usb.adb.disabled ""`
3. **Stop ADB** → find `adbd` / `adb` processes and `am force-stop` them
4. **Verify** → confirm the property took effect with `getprop`

---

## Notes

- Some systems (such as MIUI and ColorOS) may restrict `setprop` on specific properties
- `am force-stop` may not stop the ADB service on every system
- The script does not modify `persist` properties, so changes are reverted after a reboot

---

## License

MIT
