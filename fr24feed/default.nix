{ stdenv, fetchurl, radare2 }: (

assert stdenv.lib.asserts.assertMsg (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) "fr24feed is only supported on ARM";

stdenv.mkDerivation rec {
  pname = "fr24feed";
  version = "1.0.26-9";

  src = fetchurl {
    url = "https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${version}_armhf.tgz";
    sha256 = "09a2cpsmac76bnf7p5mb0wd5vwvv6zr2jwxw1d8dapmypxr2p9hm";
  };

  nativeBuildInputs = [ radare2 ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp fr24feed $out/bin
    ${radare2}/bin/r2 -Q -w -c '/ /bin/bash; s hit0_0; wz /bin/sh; / /sbin/rmmod; s hit1_0; wx 2300' $out/bin/fr24feed
  '';

  meta = {
    license = stdenv.lib.licenses.unfree;
  };
}

)
