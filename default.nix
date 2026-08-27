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
  gratttool = callPackage (import ./gratttool) {};
  install-safe = callPackage (import ./install-safe) {};
  mlat-client = callPackage (import ./mlat-client) {};
  mlucas = callPackage (import ./mlucas) {};
  piaware = callPackage (import ./piaware) {};
  tcllauncher = callPackage (import ./tcllauncher) {};
  tor-monitor = callPackage (import ./tor-monitor) {};
  yopass = callPackage (import ./yopass) {};

  aws-lc = super.aws-lc.overrideAttrs (finalAttrs: previousAttrs: {
    version = "5.3.0";
    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-lc";
      rev = "v${finalAttrs.version}";
      hash = "sha256-5LkoppiMyDVg5QODmSTB5v9WNVJKk8wmjENCAcfMajg=";
    };
    postInstall = ''
      moveToOutput lib/crypto/cmake "$dev"
      moveToOutput lib/ssl/cmake "$dev"
    '';
  });

  # do not use to run a relay (weird connection drops)
  tor-awslc = (tor.override {
    openssl = self.aws-lc;
  }).overrideAttrs (previousAttrs: {
    patches = (previousAttrs.patches or []) ++ [ ./tor-awslc.patch ];
  });
}
