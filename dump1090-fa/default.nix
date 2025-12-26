{ stdenv, fetchFromGitHub, pkg-config, libbladeRF, libusb1, ncurses, rtl-sdr }:

stdenv.mkDerivation rec {
  pname = "dump1090-fa";
  version = "10.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "dump1090";
    rev = "v10.2";
    sha256 = "0dc1f18n1xlamdhxg96db6cm6kp04cqzxb36qmd141d0rca7qcli";
  };

  nativeBuildInputs = [ pkg-config ];

  # omit stuff we don't use
  buildInputs = [ libusb1 ncurses rtl-sdr ];

  postBuild = ''
    make faup1090
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp dump1090 faup1090 view1090 $out/bin
    cp -r public_html $out/share/dump1090
    runHook postInstall
  '';
}
