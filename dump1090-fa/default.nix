{ stdenv, fetchFromGitHub, pkgconfig, libbladeRF, libusb, ncurses, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090-fa";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    rev = "089684e20f4d44f328ca9b8242b2da33afc8662b";
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
