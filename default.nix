self: super:

with super;

{
  chrony-wait = callPackage (import ./chrony-wait) {};
  dump1090-fa = callPackage (import ./dump1090-fa) {};
  fake-hwclock = callPackage (import ./fake-hwclock) {};
  fr24feed = callPackage (import ./fr24feed) {};
  mlat-client = callPackage (import ./mlat-client) {};
  rtl-sdr = callPackage (import ./rtl-sdr) {};

  owncast = callPackage (import ./owncast) {};
}
