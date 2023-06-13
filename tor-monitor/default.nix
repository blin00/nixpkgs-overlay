{ pkgs, stdenv }: (

stdenv.mkDerivation rec {
  name = "tor-monitor";
  propagatedBuildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [
      stem
    ]))
  ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./tor-monitor.py} $out/bin/tor-monitor";
}

)
