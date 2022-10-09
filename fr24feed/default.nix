{ lib, stdenv, fetchurl, radare2 }: (

assert lib.asserts.assertMsg (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) "fr24feed is only supported on ARM";

stdenv.mkDerivation rec {
  pname = "fr24feed";
  version = "1.0.30-3";

  src = fetchurl {
    url = "https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${version}_armhf.tgz";
    sha256 = "1z8g8hm580zf3lf8mc7nkzxh2c4bw3qq2padymwzs1ckidg7x344";
  };

  nativeBuildInputs = [ radare2 ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp fr24feed $out/bin
    ${radare2}/bin/r2 -Q -w -c '/ /bin/bash; s hit0_0; wz /bin/sh; / /sbin/rmmod; s hit1_0; wx 2300' $out/bin/fr24feed
  '';

  meta = {
    license = lib.licenses.unfree;
  };
}

)
