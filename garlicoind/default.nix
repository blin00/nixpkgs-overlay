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
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "garlicoin";
    repo = "Garlicoin";
    rev = "a4881b1c39d049aa1737088c1a183762630a9f8a";
    hash = "sha256-05hc4hgVJlpN03xr7AN5Qnj82I6wGjtLdTWUS4OhXuc=";
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
    ./fix_compile.patch
    ./fix_reindex.patch
    # ./CVE-2024-52911.patch
    # ./CVE-2024-35202.patch
    ./CVE-2024-52912.patch
  ];

  enableParallelBuilding = true;

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
