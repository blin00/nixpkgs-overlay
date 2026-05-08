{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
  gmp,
  jansson,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "cpuminer-opt";
  version = "26.1";

  src = fetchFromGitHub {
    owner = "JayDDee";
    repo = "cpuminer-opt";
    rev = "v${version}";
    sha256 = "sha256-3kYlq0gYyPtSQHlqrsHbb6LXzUy7U0DBYczyR03IArU=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    curl
    gmp
    jansson
    openssl
  ];

  configureFlags = [ "--with-curl" ];

  enableParallelBuilding = true;

  meta = {
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
})
