#!/system/bin/sh

# 获取当前脚本所在的绝对路径
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
TARGET_FILE="$CURRENT_DIR/vmlinux.btf"

echo "[*] 开始检测内核 BTF 环境..."

# 1. 检查内核是否支持 BTF
if [ ! -f "/sys/kernel/btf/vmlinux" ]; then
    echo "❌ 错误: 当前手机内核不支持 BTF (找不到 /sys/kernel/btf/vmlinux)"
    echo "提示: 你的内核可能过旧，或者编译时未开启 CONFIG_DEBUG_INFO_BTF。"
    exit 1
fi

echo "[*] 正在安全复制 BTF 二进制文件到当前目录..."

# 2. 直接使用 cp 复制（不通过 cat 管道流，确保二进制数据绝对安全、不损坏）
cp "/sys/kernel/btf/vmlinux" "$TARGET_FILE"

# 3. 检查复制是否成功
if [ $? -eq 0 ] && [ -f "$TARGET_FILE" ]; then
    # 修改权限，确保普通用户/应用和浏览器可以正常读取和上传
    chmod 0666 "$TARGET_FILE"
    
    echo "========================================="
    echo "✅ 提取成功！"
    echo "文件已保存至: $TARGET_FILE"
    echo "现在你可以直接将该文件上传到 GitHub 仓库了。"
    echo "========================================="
else
    echo "❌ 错误: 文件复制失败，请检查是否正确勾选了 Root 权限执行。"
    exit 1
fi
