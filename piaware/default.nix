{ stdenv, fetchFromGitHub, dump1090-fa, fa-mlat-client, openssl, tcl, tcllauncher, tclPackages }:

stdenv.mkDerivation rec {
  pname = "piaware";
  version = "10.2";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "piaware";
    rev = "v10.2";
    sha256 = "092ffsyy1h9mrgqsv4d11zxk5v3zxl5nz9rhpz19cl7mq2nj7px6";
  };

  nativeBuildInputs = [ openssl tcl ];
  buildInputs = [ dump1090-fa fa-mlat-client tcllauncher tcl.tclPackageHook tclPackages.tcllib tclPackages.tcltls tclPackages.tclx ];
  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  patches = [ ./helpers-path.patch ];

  installPhase = ''
    runHook preInstall
    export PATH="$PATH''${PATH:+:}${openssl}/bin"
    make DESTDIR="$out" PREFIX= TCLLAUNCHER="${tcllauncher}/bin/tcllauncher" TCLSH="${tcl}/bin/tclsh" install
    ln -s "${dump1090-fa}/bin/faup1090" "$out/lib/piaware/helpers/faup1090"
    ln -s "${fa-mlat-client}/bin/fa-mlat-client" "$out/lib/piaware/helpers/fa-mlat-client"
    runHook postInstall
  '';
}
