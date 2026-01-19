{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  boost177,
  db4,
  libevent,
  openssl,
  zeromq,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "garlicoind";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "GarlicoinOrg";
    repo = "Garlicoin";
    rev = "v0.18.0";
    sha256 = "0gi3cmxakwrp0g7xab1myqqq77cr1mijsldvx8idnmn6ydlayyjz";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost177
    db4
    libevent
    openssl
    zeromq
  ];

  configureFlags = [
    "--with-boost-libdir=${boost177}/lib"
    "--without-miniupnpc"
    "--disable-bench"
    "--disable-tests"
    "--disable-gui-tests"
  ];

  patches = [ ./fix.patch ];

  enableParallelBuilding = true;

  meta = {
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
