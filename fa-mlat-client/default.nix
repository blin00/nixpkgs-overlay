{ python311, fetchFromGitHub }: (

python311.pkgs.buildPythonPackage rec {
  pname = "fa-mlat-client";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "mutability";
    repo = "mlat-client";
    rev = "v0.2.13";
    sha256 = "0hgyyxz8632rmayaj5k94c7j3rxwlfh04hjn893zz81w449y8a3x";
  };
  pyproject = true;
  build-system = [ python311.pkgs.setuptools ];
}

)
