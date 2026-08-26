{ stdenv, fetchFromGitHub, dump1090-fa, mlat-client, openssl, tcl, tcllauncher, tclPackages }:

stdenv.mkDerivation rec {
  pname = "piaware";
  version = "11.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "piaware";
    rev = "v${version}";
    hash = "sha256-FRgqz2aZdMrIJXRFtTTc6xdzIGvN8eJ/RrWJd7oD27k=";
  };

  nativeBuildInputs = [ openssl ];
  buildInputs = [ dump1090-fa mlat-client tcllauncher tcl tcl.tclPackageHook tclPackages.tcllib tclPackages.tcltls tclPackages.tclx ];
  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  patches = [ ./helpers-path.patch ];

  installPhase = ''
    runHook preInstall
    export PATH="$PATH''${PATH:+:}${openssl}/bin"
    make DESTDIR="$out" PREFIX= TCLLAUNCHER="${tcllauncher}/bin/tcllauncher" TCLSH="${tcl}/bin/tclsh" install
    ln -s "${dump1090-fa}/bin/faup1090" "$out/lib/piaware/helpers/faup1090"
    ln -s "${mlat-client}/bin/fa-mlat-client" "$out/lib/piaware/helpers/fa-mlat-client"
    runHook postInstall
  '';
}
