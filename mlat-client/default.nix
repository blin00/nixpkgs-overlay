{ python38, fetchFromGitHub }: (

python38.pkgs.buildPythonPackage rec {
  pname = "mlat-client";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "adsbxchange";
    repo = "mlat-client";
    rev = "84eb4e6903455397c0d3334075c78ef0f7875a2c";
    sha256 = "1fa2sz5r658z2zhw349asjl5cfz9liai689ilpfg4sp775xkf20d";
  };
}

)
