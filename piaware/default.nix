{ stdenv, fetchFromGitHub, openssl, tcl, tcllauncher, tclPackages }:

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
  buildInputs = [ tcllauncher tcl.tclPackageHook tclPackages.tcllib tclPackages.tcltls tclPackages.tclx ];
  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    runHook preInstall
    export PATH="$PATH''${PATH:+:}${openssl}/bin"
    make DESTDIR="$out" PREFIX= TCLLAUNCHER="${tcllauncher}/bin/tcllauncher" TCLSH="${tcl}/bin/tclsh" install
    runHook postInstall
  '';
}
