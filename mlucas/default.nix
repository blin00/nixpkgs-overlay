{ stdenv, fetchFromGitHub, bash, gmp, hwloc }:

stdenv.mkDerivation rec {
  pname = "mlucas";
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "Mlucas";
    rev = "d082c2a00b42410d6d87605212c68be25f9f4d7d";
    sha256 = "1jpkg5a9k4a3fr74jlhb30i9z96nv4qg49n13xcwrrl3qjvqlgb0";
  };

  buildInputs = [ gmp hwloc ];
  nativeBuildInputs = [ bash ];

  patches = [ ./pointer-types.patch ];

  buildPhase = ''
    runHook preBuild
    ${bash}/bin/bash makemake.sh use_hwloc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp obj/Mlucas $out/bin/mlucas
    runHook postInstall
  '';
}
