{ python311, fetchFromGitHub }: (

python311.pkgs.buildPythonApplication rec {
  pname = "mlat-client";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "adsbxchange";
    repo = "mlat-client";
    rev = "v${version}";
    hash = "sha256-V//LpYmBXtT8haX1aZ4XldzzyUY2YN7x3lTpQ2csTmw=";
  };
  pyproject = true;
  build-system = [ python311.pkgs.setuptools ];
}

)
