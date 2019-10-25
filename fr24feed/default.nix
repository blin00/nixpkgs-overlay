{ stdenv, fetchurl, radare2 }: (

assert stdenv.lib.asserts.assertMsg (stdenv.hostPlatform.system == "aarch64-linux") "fr24feed is only supported on aarch64-linux";

stdenv.mkDerivation rec {
  pname = "fr24feed";
  version = "1.0.24-4";

  src = fetchurl {
    url = "https://repo-feed.flightradar24.com/rpi_binaries/fr24feed_${version}_armhf.tgz";
    sha256 = "12m9272sagg534mdn1ilydyycs8hz7srhcnznl51w7g52sqmp55p";
  };

  nativeBuildInputs = [ radare2 ];
  phases = [ "unpackPhase" "installPhase" ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp fr24feed $out/bin
    ${radare2}/bin/r2 -Q -w -c '/ /bin/bash; s hit0_0; wz /bin/sh; / hostname -I; s hit1_0; wz hostname -i; / /sbin/rmmod; s hit2_0; wz #' $out/bin/fr24feed
  '';

  meta = {
    license = stdenv.lib.licenses.unfree;
  };
}

)
