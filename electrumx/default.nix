{ python3, fetchFromGitHub, lib }: (

let python = python3; in python.pkgs.buildPythonApplication rec {
  pname = "electrumx";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "spesmilo";
    repo = "electrumx";
    rev = "${version}";
    sha256 = "sha256-aThM9kir4kgtcv5Fui7jFA1mrcwVhSz0DKMdMhIbub4=";
  };
  pyproject = true;
  build-system = [ python.pkgs.setuptools ];
  dependencies = with python.pkgs; [
    aiohttp
    aiorpcx
    attrs
    plyvel
    ujson
  ];
}

)
