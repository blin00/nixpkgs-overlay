{ lib, stdenv, fetchFromGitHub, buildGoModule, fetchYarnDeps, yarnConfigHook, yarnBuildHook, nodejs }:

let
  pname = "yopass";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    rev = "${version}";
    hash = "sha256-Cof7Qk4dR7eX3xOvjK/fRmJQSwOKvmMb9BpNCyQcwn0=";
  };

  src-website = "${src}/website";

  website = stdenv.mkDerivation {
    pname = "${pname}-website";
    src = src-website;
    inherit version;
    offlineCache = fetchYarnDeps {
      yarnLock = "${src-website}/yarn.lock";
      hash = "sha256-D0iZXPoIekb+xNa4DKCobSB1zPIwgxagvtg4V7urEMg=";
    };
    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-2xNssM/0x+Pvm9gTpoBBgM12TAm1B5aohpHjPjVkHXg=";
  subPackages = [
    "./cmd/yopass"
    "./cmd/yopass-server"
  ];

  postInstall = ''
    mkdir -p $out/share/${pname}
    ln -s ${website}/dist $out/share/${pname}/public
  '';

  meta = {
    license = lib.licenses.asl20;
  };
}
