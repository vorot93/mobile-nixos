{ config, lib, pkgs, ... }:

{
  mobile.device.name = "nokia-nb1";
  mobile.device.identity = {
    name = "Nokia 8";
    manufacturer = "HMD Global";
  };

  mobile.hardware = {
    soc = "qualcomm-msm8998";
    ram = 1024 * 4;
    screen = {
      width = 1440; height = 2560;
    };
  };

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
  };

  mobile.system.android = {
    # This device has an A/B partition scheme
    ab_partitions = true;

    bootimg.flash = {
      offset_base = "0x00000000";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0x01000000";
      offset_second = "0x00f00000";
      offset_tags = "0x00000100";
      pagesize = "4096";
    };
  };

  mobile.system.vendor.partition = "/dev/disk/by-partlabel/vendor_a";

  boot.kernelParams = [
    # From TWRP
    "androidboot.hardware=walleye"
    "androidboot.console=ttyMSM0"
    "lpm_levels.sleep_disabled=1"
    "user_debug=31"
    "msm_rtb.filter=0x37"
    "ehci-hcd.park=3"
    "service_locator.enable=1"
    "swiotlb=2048"
    "firmware_class.path=/vendor/firmware"
    "loop.max_part=7"
    "raid=noautodetect"
    "androidboot.fastboot=1"
    "buildvariant=eng"

    # Using `quiet` fixes early framebuffer init, for stage-1
    "quiet"
  ];

  mobile.system.type = "android";

  mobile.usb.mode = "gadgetfs";
  # HMD Global
  mobile.usb.idVendor = "2e04";
  # Nokia 8
  mobile.usb.idProduct = "c025";

  mobile.usb.gadgetfs.functions = {
    rndis = "gsi.rndis";
    # FIXME: This is the right function name, but doesn't work.
    # adb = "ffs.usb0";
  };
}
