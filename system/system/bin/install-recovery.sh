#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/platform/bootdevice/by-name/recovery:33554432:fc576193b683ed59ffcc7bdd07d8308713ef5e6d; then
  applypatch  EMMC:/dev/block/platform/bootdevice/by-name/boot:33554432:f6002eded6e16a7c3b244ffc56d18d812ab04123 EMMC:/dev/block/platform/bootdevice/by-name/recovery fc576193b683ed59ffcc7bdd07d8308713ef5e6d 33554432 f6002eded6e16a7c3b244ffc56d18d812ab04123:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
