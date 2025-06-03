{ lib, stdenv, fetchurl, radare2 }: (

assert lib.asserts.assertMsg (stdenv.hostPlatform.isAarch64) "fr24feed is only supported on arm64";

stdenv.mkDerivation rec {
  pname = "fr24feed";
  version = "1.0.51-0";

  src = fetchurl {
    url = "https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${version}_arm64.tgz";
    sha256 = "0cmjl38bf3pg99mgqng2w3505dsm92vs9zhz02y39w05b6fqi8dq";
  };

  nativeBuildInputs = [ radare2 ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp fr24feed $out/bin
    ${radare2}/bin/r2 -Q -w -c '/ /bin/bash; s hit0_0; wz /bin/sh; / /sbin/rmmod; s hit1_0; wz "#"; / /usr/bin/pgrep; s hit2_0; wz pgrep; s hit2_1; w ";;;;;;;;;pgrep"; / /bin/netstat; s hit3_0; w ";;;;;"' $out/bin/fr24feed
  '';

  meta = {
    license = lib.licenses.unfree;
  };
}

)
