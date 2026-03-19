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
    rev = "31985359cf2dceec7fd3b699698f9cf0baa59968";
    sha256 = "sha256-tK84BHijDkjqfNPuB0bXYinthK+QzkjGmBFYWRqn/Hw=";
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
