self: super:

with super;

{
  dump1090-fa = callPackage (import ./dump1090-fa) {};
  fr24feed = callPackage (import ./fr24feed) {};
  mlat-client = callPackage (import ./mlat-client) {};
  rtl-sdr = callPackage (import ./rtl-sdr) {};
}
