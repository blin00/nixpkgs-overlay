{ lib, stdenv, fetchurl, radare2 }: (

assert lib.asserts.assertMsg (stdenv.hostPlatform.isAarch64) "fr24feed is only supported on arm64";

stdenv.mkDerivation rec {
  pname = "fr24feed";
  version = "1.0.54-0";

  src = fetchurl {
    url = "https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${version}_arm64.tgz";
    hash = "sha256-se7WgYa8U5SOhYvUJ5giREL9INNq/U5nRegSKDBNL6s=";
  };

  nativeBuildInputs = [ radare2 ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
  
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp fr24feed $out/bin
    ${radare2}/bin/r2 -Q -w -c '/ /bin/bash; s hit0_0; wz /bin/sh; / /sbin/rmmod; s hit1_0; wz "#"; / /usr/bin/pgrep; s hit2_0; wz pgrep; s hit2_1; wz false; / /bin/netstat; s hit3_0; w ";;;;;"' $out/bin/fr24feed
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.unfree;
  };
}

)
