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
  yopass = callPackage (import ./yopass) {};

  aws-lc = super.aws-lc.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.73.0";
    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-lc";
      rev = "v${finalAttrs.version}";
      hash = "sha256-fDDkAN/dIqcvAWCE23zveQB5ZPOAesAxSk9GRJzTDzw=";
    };
    outputs = [ "out" ]; # needed for 1.71.0 and above, otherwise cycle detected
  });

  # do not use to run a relay (weird connection drops)
  tor-awslc = (tor.override {
    openssl = self.aws-lc;
  }).overrideAttrs (previousAttrs: {
    patches = (previousAttrs.patches or []) ++ [ ./tor-awslc.patch ];
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

  linuxPackages_sbc_6_18 = let version = "6.18.32"; in pkgs.linuxPackagesFor ((pkgs.linuxManualConfig {
    inherit version;
    pname = "linux-sbc";
    src = pkgs.fetchurl {
      url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
      hash = "sha256-Bn2t1EVXgoTqYVjzEveXDYlA/tPglNvknP9m0YjTvaQ=";
    };
    # enabled (from n):
    # * CONFIG_CRYPTO_DEV_SUN8I_CE_HASH/PRNG/TRNG
    # * CONFIG_SUN50I_IOMMU
    # enabled (from m):
    # * CONFIG_SUN50I_H6_PRCM_PPU
    # * CONFIG_ARM_ALLWINNER_SUN50I_CPUFREQ_NVMEM
    # * CONFIG_ARM_RASPBERRYPI_CPUFREQ
    # changed:
    # * NR_CPUS from 384 to 64
    # disabled: a bunch of random stuff
    configfile = ./sbc.config;
    kernelPatches = [
      kernelPatches.bridge_stp_helper
      kernelPatches.request_key_helper
    ];
  }).overrideAttrs (finalAttrs: previousAttrs: {
    passthru = {
      configEnv = finalAttrs.finalPackage.overrideAttrs (previousAttrs: {
        nativeBuildInputs = previousAttrs.nativeBuildInputs or [ ]
          ++ [
            pkg-config
            ncurses
          ];
      });
    };
  }));
}
