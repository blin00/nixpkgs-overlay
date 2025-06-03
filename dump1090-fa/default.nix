{ stdenv, fetchFromGitHub, pkg-config, libbladeRF, libusb1, ncurses, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090-fa";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    rev = "v10.1";
    sha256 = "01871z5zlr37gpz4ccdj6zzxqf7355qi89gym8m977vbldz7p7gh";
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
