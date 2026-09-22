# adb-trace-cleaner 🔧

[English](README.md) | **中文**

Android 设备 USB 调试痕迹消除脚本，中英双语输出，适合模块开发者、逆向工程师、测试人员使用。

---

## 功能

- ✅ 设置系统属性 `sys.usb.adb.disabled` 为空值，禁用 USB 调试
- ✅ 自动查找并停止 ADB 服务进程（`adbd` / `adb`）
- ✅ 验证属性设置结果
- ✅ **中英双语输出**，每条信息中文与英文分开发送，清晰易读
- ✅ 详细的错误处理与返回值检查

---

## 要求

- Android 设备已 root（需 `setprop` / `getprop` 权限）
- `/system/bin/sh` 环境
- BusyBox 或支持 `pidof` 的 shell

---

## 使用方法

```sh
# 以 root 执行
su -c ./adb_trace_cleaner.sh
```

## 脚本流程

1. **检查 Root 权限** → 非 root 直接退出
2. **设置属性** → `setprop sys.usb.adb.disabled ""`
3. **停止 ADB** → 查找 `adbd` / `adb` 进程并 `am force-stop`
4. **验证结果** → `getprop` 确认属性已生效

---

## 注意事项

- 部分系统（如 MIUI、ColorOS）可能限制 `setprop` 对特定属性的修改
- `am force-stop` 停止 ADB 服务可能在某些系统上不生效
- 脚本不会修改 `persist` 属性，重启后恢复原状

---

## 许可

基于 MIT 协议开源
