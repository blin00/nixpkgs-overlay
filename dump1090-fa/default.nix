{ stdenv, fetchFromGitHub, pkgconfig, libbladeRF, libusb, ncurses, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090-fa";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    rev = "849a3b73299b4f56620ab16a6b62d88e17f35608";
    sha256 = "0vlv9bd805kid202xxkrnl51rh02cyrl055gbcqlqgk51j5rrq8w";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libbladeRF libusb ncurses rtl-sdr ];

  installPhase = ''
    mkdir -p $out/bin
    cp dump1090 view1090 $out/bin
  '';
  # mkdir -p $out/share
  # cp -r public_html $out/share/dump1090
}
