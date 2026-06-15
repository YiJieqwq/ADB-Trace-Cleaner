#!/system/bin/sh
# 双语版 / Bilingual Version — 调试痕迹消除脚本 / Debug Trace Cleanup Script

# ============================================================
# 检查 Root 权限 / Check Root Privileges
# ============================================================
if [ "$(id -u)" -ne 0 ]; then
    echo ""
    echo "【错误】请以root权限运行此脚本，否则无法修改系统属性。"
    echo ""
    echo "[Error] Please run this script as root; otherwise system properties cannot be modified."
    echo ""
    exit 1
fi

# ============================================================
# 设置系统属性 / Set System Property
# ============================================================
echo ""
echo "【信息】正在尝试设置系统属性 sys.usb.adb.disabled..."
echo ""
echo "[Info] Attempting to set system property sys.usb.adb.disabled..."
echo ""

setprop sys.usb.adb.disabled ""
if [ $? -ne 0 ]; then
    echo ""
    echo "【错误】设置系统属性 sys.usb.adb.disabled 失败。"
    echo ""
    echo "[Error] Failed to set system property sys.usb.adb.disabled."
    echo ""
    echo "请检查："
    echo "  1. 系统是否支持此属性设置"
    echo "  2. 属性名和值是否正确"
    echo ""
    echo "Please check:"
    echo "  1. Whether the system supports this property"
    echo "  2. Whether the property name and value are correct"
    echo ""
    exit 1
fi

echo ""
echo "【成功】系统属性 sys.usb.adb.disabled 已成功设置。"
echo ""
echo "[OK] System property sys.usb.adb.disabled has been set successfully."
echo ""

# ============================================================
# 停止 ADB 服务 / Stop ADB Service
# ============================================================
echo ""
echo "【信息】正在尝试停止 ADB 服务……"
echo ""
echo "[Info] Attempting to stop ADB service..."
echo ""

# 查找 ADB 进程 / Locate ADB process
adb_pid=$(pidof adbd)
if [ -z "$adb_pid" ]; then
    adb_pid=$(pidof adb)
fi

if [ -z "$adb_pid" ]; then
    echo ""
    echo "【警告】未找到 ADB 服务进程（adbd 或 adb）。"
    echo ""
    echo "[Warn] No ADB service process found (adbd or adb)."
    echo ""
    echo "可能该系统没有运行 ADB 服务。"
    echo ""
    echo "The system may not be running ADB."
    echo ""
else
    # 尝试通过包名停止 / Attempt to stop via package name
    am force-stop com.android.adbd 2>/dev/null
    if [ $? -ne 0 ]; then
        am force-stop com.android.adb 2>/dev/null
    fi
    if [ $? -eq 0 ]; then
        echo ""
        echo "【成功】ADB 服务已停止，有助于消除调试痕迹。"
        echo ""
        echo "[OK] ADB service has been stopped, helping to remove debug traces."
        echo ""
    else
        echo ""
        echo "【警告】停止 ADB 服务失败，可能该系统不支持此操作。"
        echo ""
        echo "[Warn] Failed to stop ADB service; this operation may not be supported."
        echo ""
        echo "不影响属性设置。"
        echo ""
        echo "This does not affect the property setting."
        echo ""
    fi
fi

# ============================================================
# 验证设置结果 / Verify Property Setting
# ============================================================
echo ""
echo "【信息】正在验证系统属性……"
echo ""
echo "[Info] Verifying system property..."
echo ""

is_disabled=$(getprop sys.usb.adb.disabled)

if [ "$is_disabled" = "" ]; then
    echo ""
    echo "【成功】系统属性 sys.usb.adb.disabled 已成功设置，USB 调试可能已被禁用。"
    echo ""
    echo "[OK] sys.usb.adb.disabled has been set successfully. USB debugging may be disabled."
    echo ""
else
    echo ""
    echo "【警告】虽然执行了设置操作，但属性值未如预期更改（当前值: $is_disabled）。"
    echo ""
    echo "[Warn] Although the set command was executed, the property value did not change as expected (current value: $is_disabled)."
    echo ""
    echo "USB 调试痕迹可能未完全消除。"
    echo ""
    echo "Debug traces may not be fully removed."
    echo ""
fi

echo ""
echo "【完成】脚本执行完毕。"
echo ""
echo "[Done] Script execution finished."
echo ""
