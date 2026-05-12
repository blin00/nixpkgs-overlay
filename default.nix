self: super:

with super;

{
  agnos = callPackage (import ./agnos) {};
  chrony-nts-pool = callPackage (import ./chrony-nts-pool) {};
  chrony-wait = callPackage (import ./chrony-wait) {};
  cpuminer-opt = callPackage (import ./cpuminer-opt) {};
  dump1090-fa = callPackage (import ./dump1090-fa) {};
  electrumx = callPackage (import ./electrumx) {};
  fake-hwclock = callPackage (import ./fake-hwclock) {};
  fr24feed = callPackage (import ./fr24feed) {};
  garlicoind = callPackage (import ./garlicoind) {};
  install-safe = callPackage (import ./install-safe) {};
  mlat-client = callPackage (import ./mlat-client) {};
  mlucas = callPackage (import ./mlucas) {};
  piaware = callPackage (import ./piaware) {};
  tcllauncher = callPackage (import ./tcllauncher) {};
  tor-monitor = callPackage (import ./tor-monitor) {};
  u-boot-orangepizero3 = callPackage (import ./u-boot-orangepizero3) {};
  yopass = callPackage (import ./yopass) {};

  tor-awslc = (pkgs.tor.override {
    openssl = pkgs.aws-lc;
  }).overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [ ./tor-awslc.patch ];
  });

  # https://github.com/NixOS/nixpkgs/pull/471091/changes
  linuxPackages_rt_6_18 = pkgs.linuxPackagesFor (let linux = pkgs.linux_6_18; version = linux.version; in linux.override {
    argsOverride = {
      pname = "linux-rt";
    };
    structuredExtraConfig =
      with lib.kernel;
      (
        {
          # Enable expert mode (required by PREEMPT_RT, see kernel/Kconfig.preempt)
          EXPERT = yes;
          # Enable PREEMPT_RT
          PREEMPT_RT = yes;
          # Fix error: option not set correctly: PREEMPT (wanted 'n', got 'y').
          PREEMPT = lib.mkForce yes;
          PREEMPT_LAZY = lib.mkForce unset;
          # Fix error: error: unused option: PREEMPT_VOLUNTARY
          PREEMPT_VOLUNTARY = lib.mkForce unset;
          # i915 GVT is incompatible with PREEMPT_RT
          # https://lists.freedesktop.org/archives/intel-gfx/2022-February/289691.html
          DRM_I915_GVT = lib.mkForce unset;
          DRM_I915_GVT_KVMGT = lib.mkForce unset;
        }
      );
  });
}
