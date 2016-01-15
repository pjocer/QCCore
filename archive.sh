#!/bin/bash
# 请先试用xcode编译arm架构和x86架构的framework各一份
# 然后执行本脚本
#
# xcode配置范例：
#####################################################################################
# FRAMEWORK_LOCN="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.framework"
# MERGE_LOCN="${SRCROOT}/Build"
#
# if [ ! -d "$MERGE_LOCN" ]; then
# mkdir -p "$MERGE_LOCN"
# fi
#
# cp -rf "$FRAMEWORK_LOCN" "$MERGE_LOCN/${PLATFORM_NAME}_${PRODUCT_NAME}.framework"
#
# open "$MERGE_LOCN"
#####################################################################################

# 宏定义三个路径
ARMDIR="Build/iphoneos_QCCore.framework"
X86DIR="Build/iphonesimulator_QCCore.framework"
OUTUPTDIR="Build/QCCore.framework"

if [ ! -d "$ARMDIR" ]; then
    echo "build framework by ARM!"
    exit 0
fi

if [ ! -d "$X86DIR" ]; then
    echo "build framework by x86!"
    exit 0
fi

# 先删除旧的合并framework
if [ ! -d "$OUTUPTDIR" ]; then
    rm -rf "$OUTUPTDIR"
fi

# duplicate一份arm_framework，并删除二进制文件
cp -rf "$ARMDIR" "$OUTUPTDIR"
rm -f "$OUTUPTDIR/QCCore"

# 合并
lipo -create "$ARMDIR/QCCore" "$X86DIR/QCCore" -output "$OUTUPTDIR/QCCore"

# 删除两个材料framework
rm -rf "$ARMDIR"
rm -rf "$X86DIR"

# 打开目标文件夹
open "Build"

echo "merge framework success!"
exit 1
