self: super:

with super;

{
  chrony-wait = callPackage (import ./chrony-wait) {};
  dump1090-fa = callPackage (import ./dump1090-fa) {};
  fake-hwclock = callPackage (import ./fake-hwclock) {};
  fa-mlat-client = callPackage (import ./fa-mlat-client) {};
  fr24feed = callPackage (import ./fr24feed) {};
  mlat-client = callPackage (import ./mlat-client) {};
  mlucas = callPackage (import ./mlucas) {};
  owncast = callPackage (import ./owncast) {};
  piaware = callPackage (import ./piaware) {};
  tcllauncher = callPackage (import ./tcllauncher) {};
  tor-monitor = callPackage (import ./tor-monitor) {};
  u-boot-orangepizero3 = callPackage (import ./u-boot-orangepizero3) {};
}
