{ lib, stdenv, fetchFromGitHub, buildGoModule, fetchYarnDeps, yarnConfigHook, yarnBuildHook, nodejs }:

let
  pname = "yopass";
  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "jhaals";
    repo = "yopass";
    rev = "${version}";
    hash = "sha256-oW012JUZun/TuXOVzadNaIa1z2fA9mp4pcylsCgppbs=";
  };

  src-website = "${src}/website";

  website = stdenv.mkDerivation {
    pname = "${pname}-website";
    src = src-website;
    inherit version;
    offlineCache = fetchYarnDeps {
      yarnLock = "${src-website}/yarn.lock";
      hash = "sha256-8VnAGidDOc6ScMJAhP66qgoZWEjJZDXlXXn0xKHmwe8=";
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

  vendorHash = "sha256-IZnQy9vVqMcSHXLY9dVxPFRV7gJ8/niuOLOUJRhGJbg=";
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
