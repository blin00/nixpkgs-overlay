{ stdenv, fetchFromGitHub, autoreconfHook, tcl, tclPackages }:

stdenv.mkDerivation rec {
  pname = "tcllauncher";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tcllauncher";
    rev = "fb107c3e9a6eea746876ead65556fd3bae2ab235";
    sha256 = "0sgkk497j7xd8b6hslbp9rn8q9bb837rgqqyhgykiprk1ip9wbg4";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ tcl tcl.tclPackageHook tclPackages.tclx ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--exec_prefix=$(out)"
  ];
}
