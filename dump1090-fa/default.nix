{ stdenv, fetchFromGitHub, pkg-config, libbladeRF, libusb1, ncurses, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090-fa";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    rev = "e3b3fa879bceee8ab9b5ef1e40ffb21aff3a1f5c";
    sha256 = "16ylywy2fdwf5kqr8kgl9lbzy1zwx4ckj9y122k3h86pfkswljs9";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libbladeRF libusb1 ncurses rtl-sdr ];

  installPhase = ''
    mkdir -p $out/bin
    cp dump1090 view1090 $out/bin
  '';
  # mkdir -p $out/share
  # cp -r public_html $out/share/dump1090
}
