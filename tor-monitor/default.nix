{ pkgs, stdenv, fetchFromGitHub }: (

let
  python = let
    packageOverrides = self: super: {
      stem = super.stem.overridePythonAttrs(old: rec {
        version = "1.8.2";
        src = fetchFromGitHub {
          owner = "torproject";
          repo = "stem";
          rev = "refs/tags/${version}";
          hash = "sha256-9BXeE/sVa13jr8G060aWjc49zgDVBhjaR6nt4lSxc0g=";
        };
        patches = [];
        checkPhase = ''
          runHook preCheck
          runHook postCheck
        '';
      });
    };
  in pkgs.python312.override {inherit packageOverrides; self = python;};
in
stdenv.mkDerivation rec {
  name = "tor-monitor";
  propagatedBuildInputs = [
    (python.withPackages (ps: with ps; [
      stem
    ]))
  ];
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 ${./tor-monitor.py} $out/bin/tor-monitor
    runHook postInstall
  '';
}

)
