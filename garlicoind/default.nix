{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost182,
  db4,
  libevent,
  openssl,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "garlicoind";
  version = "0.18.6";

  src = fetchFromGitHub {
    owner = "garlicoin";
    repo = "Garlicoin";
    rev = "v0.18.6";
    hash = "sha256-ScK2hxoURMmJPaJxF3sVDYLaG+fukl7OwReAVc2uP3E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost182
    db4
    libevent
    openssl
    zeromq
  ];

  configureFlags = [
    "--with-boost-libdir=${boost182}/lib"
    "--without-miniupnpc"
    "--disable-bench"
    "--disable-tests"
    "--disable-gui-tests"
  ];

  patches = [
    # ./fix_compile.patch
    # ./fix_reindex.patch
    # ./CVE-2024-52911.patch
    # ./CVE-2024-35202.patch
    # ./CVE-2024-52912.patch
  ];

  enableParallelBuilding = true;

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
