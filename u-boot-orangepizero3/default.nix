{ buildUBoot, armTrustedFirmwareAllwinnerH616, ... }:

buildUBoot {
  defconfig = "orangepi_zero3_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  BL31 = "${armTrustedFirmwareAllwinnerH616}/bl31.bin";
  filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
  extraPatches = [ ./u-boot-sunxi.patch ];
}
